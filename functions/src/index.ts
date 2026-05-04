import {setGlobalOptions} from "firebase-functions";
import {
  onDocumentCreated,
  onDocumentUpdated,
} from "firebase-functions/v2/firestore";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

admin.initializeApp();
const db = admin.firestore();

setGlobalOptions({maxInstances: 10, region: "europe-west1"});

// ─────────────────────────────────────────────────────────────────────────────
// 1. Send FCM notification when a new announcement is created
// ─────────────────────────────────────────────────────────────────────────────
export const onAnnouncementCreated = onDocumentCreated(
  "announcements/{annId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const title: string = data.title ?? "إعلان جديد";
    const body: string = data.body ?? "";
    const department: string = data.department ?? "الكل";

    // Build FCM topic: "all" or specific department
    const topic = department === "الكل" ? "all" : `dept_${department}`;

    try {
      await admin.messaging().send({
        topic,
        notification: {title, body},
        data: {type: "announcement", annId: event.params.annId},
        android: {priority: "high"},
        apns: {payload: {aps: {sound: "default"}}},
      });
      logger.info(`Announcement notification sent to topic: ${topic}`);
    } catch (err) {
      logger.error("Failed to send announcement notification", err);
    }
  }
);

// ─────────────────────────────────────────────────────────────────────────────
// 1b. Send FCM notification when a new result is published
// ─────────────────────────────────────────────────────────────────────────────
export const onResultCreated = onDocumentCreated(
  "results/{resultId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const department: string = data.department;
    const semester: number = data.semester;
    const subject: string = data.subject ?? "مادة دراسية";

    if (!department || !semester) return;

    const safeDept = department.replace(/ /g, "_");
    const topic = `dept_${safeDept}_sem_${semester}`;

    try {
      await admin.messaging().send({
        topic,
        notification: {
          title: "نتيجة جديدة",
          body: `تم رفع نتيجة جديدة لمادة ${subject}`,
        },
        data: {type: "result", resultId: event.params.resultId},
        android: {priority: "high"},
      });
      logger.info(`Result notification sent to topic: ${topic}`);
    } catch (err) {
      logger.error("Failed to send result notification", err);
    }
  }
);

// ─────────────────────────────────────────────────────────────────────────────
// 1c. Send FCM notification when a new schedule is published
// ─────────────────────────────────────────────────────────────────────────────
export const onScheduleCreated = onDocumentCreated(
  "schedules/{scheduleId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const departmentCode: string = data.departmentCode ?? data.department ?? "";
    const semester: number = data.semester;

    if (!departmentCode || !semester) return;

    const safeDept = departmentCode.replace(/ /g, "_");
    const topic = `dept_${safeDept}_sem_${semester}`;

    try {
      await admin.messaging().send({
        topic,
        notification: {
          title: "جدول دراسي جديد",
          body: "تم نشر/تحديث الجدول الدراسي الخاص بمرحلتك",
        },
        data: {type: "schedule", scheduleId: event.params.scheduleId},
        android: {priority: "high"},
      });
      logger.info(`Schedule notification sent to topic: ${topic}`);
    } catch (err) {
      logger.error("Failed to send schedule notification", err);
    }
  }
);

// ─────────────────────────────────────────────────────────────────────────────
// 2. Auto-subscribe new users to FCM topics based on role/department
// ─────────────────────────────────────────────────────────────────────────────
export const onUserCreated = onDocumentCreated(
  "users/{userId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    // Store creation event in audit_logs
    try {
      await db.collection("audit_logs").add({
        type: "user_created",
        uid: event.params.userId,
        role: data.role ?? "student",
        departmentName: data.departmentName ?? "",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      logger.info(`Audit log created for new user: ${event.params.userId}`);
    } catch (err) {
      logger.error("Failed to write audit log", err);
    }
  }
);

// ─────────────────────────────────────────────────────────────────────────────
// 3. Log role changes in audit_logs
// ─────────────────────────────────────────────────────────────────────────────
export const onUserRoleChanged = onDocumentUpdated(
  "users/{userId}",
  async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after) return;

    if (before.role !== after.role) {
      try {
        await db.collection("audit_logs").add({
          type: "role_changed",
          uid: event.params.userId,
          oldRole: before.role,
          newRole: after.role,
          changedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        logger.info(
          `Role changed for ${event.params.userId}: ` +
          `${before.role} → ${after.role}`
        );
      } catch (err) {
        logger.error("Failed to log role change", err);
      }
    }
  }
);

// ─────────────────────────────────────────────────────────────────────────────
// 4. Callable: Admin manually verifies a user (sets customVerified=true)
// ─────────────────────────────────────────────────────────────────────────────
export const verifyUser = onCall(async (request) => {
  // Must be authenticated
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "يجب تسجيل الدخول أولاً");
  }

  const callerUid = request.auth.uid;
  const callerDoc = await db.collection("users").doc(callerUid).get();
  const callerRole = callerDoc.data()?.role;

  if (callerRole !== "admin" && callerRole !== "supervisor") {
    throw new HttpsError("permission-denied", "غير مصرح لك بهذه العملية");
  }

  const {targetUid} = request.data as { targetUid: string };
  if (!targetUid) {
    throw new HttpsError("invalid-argument", "targetUid مطلوب");
  }

  await db.collection("users").doc(targetUid).update({
    customVerified: true,
    requiresVerification: false,
    verifiedBy: callerUid,
    verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  await db.collection("audit_logs").add({
    type: "user_verified",
    targetUid,
    verifiedBy: callerUid,
    verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  logger.info(`User ${targetUid} verified by ${callerUid}`);
  return {success: true, message: "تم التحقق من المستخدم بنجاح"};
});

// ─────────────────────────────────────────────────────────────────────────────
// 5. Callable: Send targeted notification to a specific user
// ─────────────────────────────────────────────────────────────────────────────
export const sendUserNotification = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "يجب تسجيل الدخول أولاً");
  }

  const callerDoc = await db.collection("users").doc(request.auth.uid).get();
  const callerRole = callerDoc.data()?.role;

  if (callerRole !== "admin" && callerRole !== "supervisor") {
    throw new HttpsError("permission-denied", "غير مصرح لك بهذه العملية");
  }

  const {targetUid, title, body} = request.data as {
    targetUid: string;
    title: string;
    body: string;
  };

  if (!targetUid || !title || !body) {
    throw new HttpsError("invalid-argument", "targetUid و title و body مطلوبة");
  }

  // Save notification to Firestore
  await db.collection("notifications").add({
    targetUid,
    title,
    body,
    read: false,
    sentBy: request.auth.uid,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  logger.info(`Notification sent to ${targetUid} by ${request.auth.uid}`);
  return {success: true};
});

// ─────────────────────────────────────────────────────────────────────────────
// 6. Scheduled Tasks (Cron Jobs)
// ─────────────────────────────────────────────────────────────────────────────
export * from "./scheduled_tasks";
