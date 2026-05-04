import {onSchedule} from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

// Daily digest: runs every day at 08:00 AM Europe/London timezone
export const dailyDigestNotification = onSchedule(
  {
    schedule: "0 8 * * *",
    timeZone: "Europe/London",
    retryCount: 3,
  },
  async (event) => {
    logger.info("Starting daily digest notification...", event);

    const title = "صباح الخير! ☀️";
    const body = "لا تنس التحقق من جدولك الدراسي وإعلانات الكلية لهذا اليوم.";

    try {
      // Send to the 'all' topic which all app users subscribe to via NotificationTopicsProvider
      await admin.messaging().send({
        topic: "all",
        notification: {title, body},
        data: {type: "daily_digest"},
        android: {priority: "normal"},
        apns: {payload: {aps: {sound: "default"}}},
      });
      logger.info("Daily digest notification sent successfully.");
    } catch (error) {
      logger.error("Failed to send daily digest notification:", error);
    }
  }
);

// Process scheduled notifications every 60 minutes
export const processScheduledNotifications = onSchedule(
  {
    schedule: "every 60 minutes",
    timeoutSeconds: 120,
  },
  async (event) => {
    logger.info("Sweeping for scheduled notifications...");
    const now = admin.firestore.Timestamp.now();
    const db = admin.firestore();

    try {
      // Query for notifications scheduled to run at or before NOW
      // and have not been processed yet.
      const querySnapshot = await db
        .collection("scheduled_notifications")
        .where("scheduledFor", "<=", now)
        .where("processed", "==", false)
        .limit(100)
        .get();

      if (querySnapshot.empty) {
        logger.info("No scheduled notifications to process.");
        return;
      }

      for (const doc of querySnapshot.docs) {
        const data = doc.data();

        logger.info(`Processing scheduled notification ${doc.id}`);

        const messagePayload: any = {
          notification: {
            title: data.title ?? "إشعار مُجدول",
            body: data.body ?? "",
          },
          data: data.dataPayload ?? {},
        };

        // Deliver to target user or topic
        if (data.targetUid) {
          const userDoc = await db.collection("users").doc(data.targetUid).get();
          const fcmToken = userDoc.data()?.fcmToken;

          if (fcmToken) {
            messagePayload.token = fcmToken;
          } else {
            // User might not have a token yet or opted out
            logger.warn(`No FCM token found for user ${data.targetUid}`);
            // Mark as processed anyway so we don't retry forever
            await doc.ref.update({processed: true, error: "No FCM token"});
            continue;
          }
        } else if (data.targetTopic) {
          messagePayload.topic = data.targetTopic;
        } else {
          // Default fallback
          messagePayload.topic = "all";
        }

        try {
          await admin.messaging().send(messagePayload as admin.messaging.Message);
          // Mark as successfully processed
          await doc.ref.update({
            processed: true,
            processedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
          logger.info(`✅ Successfully sent scheduled notification: ${doc.id}`);
        } catch (sendError) {
          logger.error(`❌ Failed to send scheduled notification ${doc.id}`, sendError);
          // Mark error but keep processed=false if we want to retry?
          // Actually, let's mark true to avoid infinite loops, or use retry logic
          await doc.ref.update({
            processed: true, // For simplicity in this implementation
            error: String(sendError),
          });
        }
      }
    } catch (error) {
      logger.error("Error sweeping scheduled notifications", error);
    }
  }
);
