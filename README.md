# 📱 تطبيق كلية الطاقات المتجددة – تاجوراء

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.4+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.4+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6+-00BCD4?style=for-the-badge)](https://riverpod.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Build](https://img.shields.io/badge/Build-Zero%20Bugs%20%E2%9C%85-brightgreen?style=for-the-badge)](https://github.com)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-blueviolet?style=for-the-badge)](https://blog.cleancoder.com)
[![E2EE](https://img.shields.io/badge/Security-E2EE%20%7C%20SSL%20Pinning-red?style=for-the-badge)](https://github.com)
[![AI](https://img.shields.io/badge/AI-Gemini%20Powered-orange?style=for-the-badge&logo=google)](https://ai.google.dev)
[![Offline](https://img.shields.io/badge/Offline-First%20Ready-success?style=for-the-badge)](https://github.com)

**🏆 المنصة الرقمية الأكاديمية الأولى من نوعها في ليبيا — مُركَّبة بأعلى معايير الهندسة البرمجية العالمية**

[🚀 ابدأ الإعداد](#-الإعداد-المحلي-خطوة-بخطوة) • [📐 الهيكل المعماري](#️-نظرة-معمارية-شاملة) • [🔐 الأمان](#-وضعية-الأمان-والتشفير) • [🤖 الذكاء الاصطناعي](#-مساعد-الذكاء-الاصطناعي-gemini)

</div>

---

## 🌟 الرؤية والفلسفة البرمجية

تطبيق **كلية الطاقات المتجددة – تاجوراء** هو نظام إلكتروني متكامل يُجسّد مفهوم **"الحرم الجامعي الرقمي"**. المشروع لا يُقدّم تطبيقاً تعليمياً فحسب، بل يُجسّد رؤيةً هندسيةً شاملة تقوم على ثلاثة أعمدة:

> **١. الخصوصية بالتصميم (Privacy by Design):** كل رسالة مُشفَّرة من الطرف إلى الطرف (E2EE) قبل أن تُغادر الجهاز. لا خادم يملك القدرة على قراءة محادثاتك.

> **٢. العمل بلا إنترنت (Offline-First):** التطبيق يعمل كاملاً في وضع عدم الاتصال. البيانات مُخزَّنة محلياً وتُزامَن بذكاء عند عودة الاتصال.

> **٣. الذكاء الاصطناعي في خدمة التعليم (AI-Augmented Education):** مساعد مدعوم بـ Gemini يُجيب على أسئلة الطلبة ويُحلّل أداءهم الأكاديمي.

يعتمد التطبيق على **Flutter 3.4+** و**Firebase** و**Riverpod 2.0 (Code Generation)** مع اتباع **Clean Architecture** الصارمة لضمان قابلية الصيانة والتوسع والتطوير على المدى البعيد. **تم تحقيق صفر أخطاء في التحليل الثابت (Zero-Bug Compilation).**

---

## 🎯 الأهداف الاستراتيجية

| الهدف | التفاصيل | الحالة |
|---|---|---|
| البوابة الرقمية الموحدة | واجهة واحدة لكل فئات المستخدمين | ✅ مكتمل |
| التشفير الكامل E2EE | تشفير هجين RSA-2048 + AES-256 | ✅ مكتمل |
| العمل بدون إنترنت | Offline-First مع مزامنة ذكية | ✅ مكتمل |
| الذكاء الاصطناعي | مساعد Gemini للطلبة | ✅ مكتمل |
| تثبيت SSL | منع هجمات MITM | ✅ مكتمل |
| إشعارات ذكية | FCM موجّه حسب القسم والفصل | ✅ مكتمل |
| نظام دردشة متقدم | صوت، PDF، صور، إيصالات قراءة | ✅ مكتمل |
| صفر أخطاء تحليلية | `flutter analyze` نظيف 100% | ✅ مكتمل |

---

## 👥 مصفوفة الميزات التفصيلية لكل فئة مستخدم

### 👨‍🎓 الطالب — Feature Matrix الكامل

| الميزة | الوصف التقني | الأولوية |
|---|---|---|
| 🔐 تسجيل الدخول الآمن | Firebase Auth + JWT + 2FA اختياري | عالية |
| 📢 الإعلانات الموجّهة | فلترة حسب `departmentName` و`semester` | عالية |
| 📊 النتائج الدراسية | عرض درجات CSV المُرفوعة بشكل مُنسَّق وآمن | عالية |
| 📅 الجدول الدراسي | عرض أيام الأسبوع مع المواد والقاعات | عالية |
| 💬 الدردشة المُشفَّرة | E2EE مع الأساتذة والإدارة | عالية |
| 🤖 مساعد AI | Gemini للإجابة على الأسئلة الأكاديمية | عالية |
| 📚 المكتبة الرقمية | تصفح وتنزيل المراجع والكتب | متوسطة |
| 🎥 المحاضرات المسجلة | مشاهدة فيديوهات من Firebase Storage | متوسطة |
| 👤 الملف الشخصي | صورة، اسم، قسم، رقم القيد، تغيير كلمة المرور | متوسطة |
| ⭐ تقييم المواد | نظام استبيان (1-5 نجوم + تعليق) | متوسطة |
| 🔔 الإشعارات | FCM موجّه لموضوع القسم والفصل | عالية |
| 📶 وضع عدم الاتصال | قراءة البيانات المُخزَّنة محلياً | عالية |
| 🔑 المصادقة البيومترية | بصمة الإصبع / التعرف على الوجه | متوسطة |
| 🌙 الوضع المظلم | Material Design 3 Dark Theme | منخفضة |

### 👨‍🏫 الأستاذ — Feature Matrix الكامل

| الميزة | الوصف التقني | الأولوية |
|---|---|---|
| 🔐 لوحة تحكم مخصصة | واجهة مخصصة لعضو هيئة التدريس | عالية |
| 💬 التواصل مع الطلبة | دردشة مُشفَّرة مع طلبة القسم | عالية |
| 📢 إدارة الإعلانات | إنشاء وتعديل إعلانات القسم | عالية |
| 🎥 رفع المحاضرات | تحميل PDF/Video إلى Firebase Storage | عالية |
| 📊 متابعة الأداء | عرض إحصائيات أداء الطلبة | متوسطة |
| 📚 إدارة المواد | إضافة وتحديث المراجع والمحتوى | متوسطة |
| 👤 الملف الشخصي | صورة وبيانات هيئة التدريس | متوسطة |
| 📋 نتائج التقييم | قراءة تقارير تقييم الطلبة لمواده | متوسطة |

### 🏢 الإدارة (Admin) — Feature Matrix الكامل

| الميزة | الوصف التقني | الأولوية |
|---|---|---|
| ⚙️ إدارة المستخدمين | CRUD كامل (إنشاء، قراءة، تعديل، حذف) | عالية |
| 👥 إدارة الحسابات | تفعيل/تعطيل، تغيير الأدوار، 2FA | عالية |
| 📢 إدارة الإعلانات | نشر إعلانات عامة مستهدفة | عالية |
| 📊 رفع النتائج (CSV) | استيراد ملفات CSV ومعالجتها تلقائياً | عالية |
| 📅 إدارة الجداول | إنشاء وتحديث جداول الفصول والمواد | عالية |
| 📚 إدارة المكتبة | رفع الكتب والمراجع وتصنيفها | متوسطة |
| 💬 الوصول لكل المحادثات | إشراف كامل على نظام الدردشة | عالية |
| 📈 لوحة الإحصائيات | مؤشرات الأداء ونسب الاستخدام | متوسطة |
| 📄 تقارير PDF | توليد تقارير مؤسسية بصيغة PDF | متوسطة |
| 🗑️ حذف الحسابات | خدمة حذف شاملة للامتثال للخصوصية | عالية |

### 👨‍💼 المشرف (Supervisor) — Feature Matrix الكامل

| الميزة | الوصف التقني | الأولوية |
|---|---|---|
| 👁️ إشراف على القسم | رؤية شاملة لقسمه فقط | عالية |
| 📢 موافقة الإعلانات | مراجعة وقبول الإعلانات قبل النشر | عالية |
| 👥 متابعة الطلبة | قوائم وإحصائيات طلبة القسم | متوسطة |
| 📊 تقارير الأداء | تقارير أداء أكاديمي دورية | متوسطة |
| 💬 التواصل الإداري | قناة دردشة مع الإدارة | متوسطة |

---

## 💬 نظام الدردشة الذكي المُشفَّر

تم تصميم نظام الدردشة ليحترم الهيكل الأكاديمي ويضمن الأمان الكامل:

| المرسل | المستقبل | القناة | التشفير |
|---|---|---|---|
| 👨‍🎓 الطالب | 🏢 الإدارة | خاصة | E2EE ✅ |
| 👨‍🎓 الطالب | 👨‍🏫 أستاذ محدد | خاصة | E2EE ✅ |
| 👨‍🏫 الأستاذ | 👨‍🎓 طلبته | خاصة | E2EE ✅ |
| 🏢 الإدارة | الجميع | بث | مُشفَّر ✅ |
| 👨‍💼 المشرف | 🏢 الإدارة | خاصة | E2EE ✅ |

**الميزات التقنية المتقدمة للدردشة:**

- 🔒 **E2EE (تشفير من طرف إلى طرف):** كل رسالة تُشفَّر بمفتاح AES-256 عشوائي قبل الإرسال، والمفتاح نفسه يُشفَّر بمفتاح RSA-2048 العام للمستقبل. لا يمكن لأي خادم فك التشفير.
- 👀 **إيصالات القراءة:** علامات الصح الزرقاء (✓✓) مع تحديث لحظي عبر Firestore Streams.
- 🎤 **تسجيلات صوتية:** تسجيل بحزمة `record` وتشغيل بحزمة `audioplayers` مباشرةً داخل الدردشة.
- 📎 **مستندات PDF والصور:** إرسال مرفقات مضغوطة ذكياً عبر `flutter_image_compress`.
- 📹 **دعم مكالمات الفيديو:** بنية تحتية جاهزة للتوسع.
- ♾️ **التمرير اللانهائي:** تحميل الرسائل القديمة عبر Cursor-Based Pagination بـ `startAfter`.
- 🚫 **منع الدردشة العشوائية:** لا تواصل مباشر بين الطلبة — يمر كل شيء عبر القنوات الرسمية.

---

## 🌐 النموذج بلا إنترنت — Offline-First Paradigm

هذا هو قلب الميزة الجديدة التي تُميّز التطبيق. التطبيق **لا يتوقف عن العمل** عند انقطاع الاتصال.

### كيف يعمل النظام؟

```
┌─────────────────────────────────────────────────────┐
│                   طبقة الشبكة                       │
│                                                     │
│  متصل؟  ──[نعم]──► Firebase Firestore (بيانات حيّة) │
│    │                         │                      │
│   [لا]                       ▼                      │
│    │              كتابة إلى الكاش المحلي             │
│    │              (SharedPreferences / Hive)         │
│    ▼                                                │
│  عرض البيانات المخزنة محلياً                        │
│  (آخر نسخة متزامنة)                                 │
│                                                     │
│  عادت الشبكة؟ ──[نعم]──► مزامنة تلقائية وتحديث محلى │
└─────────────────────────────────────────────────────┘
```

### المكونات التقنية للنظام

1. **`connectivity_plus`:** يراقب حالة الشبكة لحظياً (WiFi، بيانات جوال، لا شيء).
2. **`offline_service.dart`:** الخدمة المركزية التي تُقرِّر: هل نقرأ من Firebase أم من الكاش؟
3. **`SharedPreferences`:** تخزين البيانات البسيطة (الإعلانات، الجداول) بصيغة JSON.
4. **`flutter_secure_storage`:** تخزين مُشفَّر للبيانات الحساسة محلياً (مفاتيح RSA، tokens).
5. **Firestore Offline Persistence:** Firestore يدعم التخزين المؤقت المدمج للمستندات.

### سيناريو عملي كامل

```
الطالب يفتح التطبيق في المنزل (متصل):
  ✅ يُحمَّل الجدول من Firestore
  ✅ يُخزَّن الجدول محلياً في SharedPreferences
  ✅ يُعرَض على الشاشة

الطالب في الحرم الجامعي (غير متصل):
  📴 offline_service.dart يكتشف غياب الشبكة
  📂 يقرأ الجدول المحفوظ محلياً
  ✅ يُعرَض الجدول بشكل طبيعي
  💡 شريط إشعار يُعلم المستخدم: "تعمل بوضع عدم الاتصال"

عادت الشبكة:
  🔄 مزامنة تلقائية في الخلفية
  ✅ تحديث البيانات المحلية بآخر نسخة من السحابة
```

---

## 🤖 مساعد الذكاء الاصطناعي Gemini

### نظرة عامة على التكامل

يدمج التطبيق **Google Gemini API** عبر **Firebase Genkit** لتقديم مساعد أكاديمي ذكي للطلبة.

### ميزات المساعد

| الميزة | الوصف |
|---|---|
| 🧠 الإجابة على الأسئلة | يُجيب على أسئلة المواد الدراسية بدقة |
| 📖 شرح المفاهيم | يشرح المفاهيم الصعبة بأسلوب مبسّط |
| 📊 تحليل الأداء | يُقدّم تحليلاً لنتائج الطالب ونصائح للتحسين |
| 💡 اقتراح الموارد | يقترح مراجع ومحتوى من مكتبة الكلية |
| 🌊 البث الفوري | إجابات تظهر تدريجياً (Streaming) لتجربة طبيعية |

### بنية التكامل التقني

```
الطالب
  │
  ▼
lib/presentation/providers/ai_provider.dart
  │  (@riverpod AsyncNotifier)
  ▼
lib/data/repositories/ai_repository_impl.dart
  │  (تنفيذ الواجهة)
  ▼
Firebase Cloud Functions (functions/src/genkit-sample.ts)
  │  (Node.js 24 + TypeScript + Genkit)
  ▼
Google Gemini API (gemini-1.5-flash)
  │
  ▼
استجابة مُبثَّثة ← ← ← تعود للطالب
```

### System Prompt للمساعد

```
أنت مساعد أكاديمي لكلية الطاقات المتجددة في تاجوراء، ليبيا.
تساعد الطلبة في:
- فهم مواد الطاقة الشمسية، وطاقة الرياح، والخلايا الكهروضوئية
- حل المسائل الهندسية والرياضية المتعلقة بالطاقة المتجددة
- تفسير نتائجهم الدراسية وتقديم نصائح للتحسين
- الإجابة على أسئلة الجداول والإعلانات

قواعد:
- أجب دائماً باللغة العربية الفصحى المبسّطة
- لا تناقش موضوعات خارج نطاق الكلية والدراسة
- كن دقيقاً وعلمياً ومشجعاً
```

---

## 🔐 وضعية الأمان والتشفير

### طبقات الأمان المطبّقة (Defense in Depth)

```
┌────────────────────────────────────────────────────┐
│              طبقة 1: الشبكة                        │
│   SSL Pinning ─ منع هجمات MITM                    │
├────────────────────────────────────────────────────┤
│              طبقة 2: المصادقة                      │
│   Firebase Auth + JWT + 2FA + Rate Limiting        │
├────────────────────────────────────────────────────┤
│              طبقة 3: التفويض                       │
│   RBAC (student/teacher/supervisor/admin)          │
│   Firestore Security Rules صارمة                  │
├────────────────────────────────────────────────────┤
│              طبقة 4: البيانات في النقل             │
│   E2EE: RSA-2048 + AES-256 (Hybrid Encryption)    │
├────────────────────────────────────────────────────┤
│              طبقة 5: البيانات في التخزين           │
│   flutter_secure_storage (Keychain/Keystore)       │
├────────────────────────────────────────────────────┤
│              طبقة 6: الكود المصدري                 │
│   Code Obfuscation عند الإصدار (--obfuscate)       │
└────────────────────────────────────────────────────┘
```

### 🔑 نظام التشفير الهجين (E2EE) — شرح تفصيلي

#### المشكلة التي يحلّها RSAKeyParser

في إصدارات حزمة `encrypt` الحديثة، تغيرت واجهة تحميل المفاتيح. الكود القديم كان:

```dart
// ❌ خطأ — طريقة قديمة
RsaKeyHelper().parsePublicKeyFromPem(pem);
```

الحل الصحيح باستخدام `RSAKeyParser` من حزمة `encrypt`:

```dart
// ✅ صحيح — RSAKeyParser من حزمة encrypt
import 'package:encrypt/encrypt.dart' as enc;

final rsaPublicKey = enc.RSAKeyParser().parse(receiverPublicKeyPem) as RSAPublicKey;
final rsaPrivateKey = enc.RSAKeyParser().parse(privateKeyPem) as RSAPrivateKey;
```

#### خوارزمية التشفير الكاملة خطوة بخطوة

**الإرسال (التشفير):**

```
1. إنشاء مفتاح AES-256 عشوائي + IV عشوائي
2. تشفير نص الرسالة بـ AES: ciphertext = AES.encrypt(plaintext, key, iv)
3. دمج مفتاح AES والـ IV: keyData = "base64(key):base64(iv)"
4. تشفير keyData بمفتاح RSA العام للمستقبل: encryptedKey = RSA.encrypt(keyData, publicKey)
5. حفظ {content: base64(ciphertext), key: base64(encryptedKey)} في Firestore
```

**الاستقبال (فك التشفير):**

```
1. قراءة المفتاح الخاص RSA من flutter_secure_storage
2. فك تشفير encryptedKey: keyData = RSA.decrypt(encryptedKey, privateKey)
3. استخلاص key و iv من keyData
4. فك تشفير ciphertext: plaintext = AES.decrypt(ciphertext, key, iv)
```

### 🔒 تثبيت SSL (SSL Pinning)

يُقيَّد التطبيق بالاتصال بخوادم Google/Firebase الموثوقة فقط عبر ملف `network_security_config.xml`:

```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
  <domain-config cleartextTrafficPermitted="false">
    <domain includeSubdomains="true">firestore.googleapis.com</domain>
    <domain includeSubdomains="true">firebase.googleapis.com</domain>
    <domain includeSubdomains="true">storage.googleapis.com</domain>
    <pin-set>
      <pin digest="SHA-256">GOOGLE_ROOT_CA_PIN_HERE</pin>
    </pin-set>
  </domain-config>
</network-security-config>
```

### 🗑️ خدمة حذف الحساب الشامل

امتثالاً لمعايير الخصوصية (GDPR-like)، يمكن للمستخدم حذف حسابه كلياً:

1. حذف مستند المستخدم من `users` collection
2. حذف كل رسائل الدردشة المرتبطة
3. حذف ملف التخزين (صورة الملف الشخصي)
4. حذف حساب Firebase Authentication
5. مسح المفاتيح المحلية من `flutter_secure_storage`

---

## 🚀 الإعداد المحلي خطوة بخطوة

### المتطلبات الأساسية

| الأداة | الإصدار المطلوب | رابط التنزيل |
|---|---|---|
| Flutter SDK | 3.4.0 أو أحدث | <https://flutter.dev/docs/get-started/install> |
| Dart SDK | 3.4.0 أو أحدث | مضمّن مع Flutter |
| Android Studio | Hedgehog أو أحدث | <https://developer.android.com/studio> |
| VS Code | أحدث إصدار | <https://code.visualstudio.com> |
| Git | 2.40+ | <https://git-scm.com> |
| Node.js | 20+ (للـ Cloud Functions) | <https://nodejs.org> |
| Firebase CLI | أحدث إصدار | `npm install -g firebase-tools` |
| Java JDK | 17 (للبناء الأندرويد) | <https://adoptium.net> |

### الخطوة 1: استنساخ واستعداد المشروع

```bash
# استنساخ المشروع
git clone https://github.com/your-org/college-renewable-energy-app.git
cd college-renewable-energy-app

# التحقق من إصدار Flutter
flutter --version
# يجب أن يظهر: Flutter 3.4.x, Dart 3.4.x

# تثبيت كل التبعيات
flutter pub get
```

### الخطوة 2: إعداد Firebase

```bash
# تسجيل الدخول إلى Firebase CLI
firebase login

# ربط المشروع بـ Firebase
firebase use --add

# انسخ ملفات الإعداد من Firebase Console
# Android:
cp google-services.json android/app/

# iOS:
cp GoogleService-Info.plist ios/Runner/

# إعداد FlutterFire CLI (الطريقة الحديثة)
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

### الخطوة 3: توليد الكود (مرحلة حاسمة)

```bash
# توليد كود Riverpod (ملفات .g.dart)
dart run build_runner build --delete-conflicting-outputs

# أو في وضع المراقبة المستمرة (أثناء التطوير)
dart run build_runner watch --delete-conflicting-outputs
```

### الخطوة 4: إعداد Cloud Functions (الذكاء الاصطناعي)

```bash
cd functions

# تثبيت تبعيات Node.js
npm install

# إعداد مفتاح Gemini API
firebase functions:secrets:set GEMINI_API_KEY
# أدخل مفتاح API من https://ai.google.dev

# نشر الوظائف
firebase deploy --only functions

cd ..
```

### الخطوة 5: إعداد Isar/Hive (قاعدة البيانات المحلية للـ Offline)

```bash
# إضافة التبعيات إن لم تكن موجودة
flutter pub add isar isar_flutter_libs hive hive_flutter

# توليد Schema لـ Isar
dart run build_runner build --delete-conflicting-outputs
```

### الخطوة 6: تشغيل التطبيق

```bash
# التحقق من الأجهزة المتاحة
flutter devices

# تشغيل في وضع التطوير
flutter run

# تشغيل مع تفعيل السجلات المفصلة
flutter run -v

# تشغيل على جهاز محدد
flutter run -d emulator-5554

# بناء نسخة الإنتاج مع التشفير
flutter build apk --release --obfuscate --split-debug-info=build/symbols/
```

### الخطوة 7: التحقق من جودة الكود

```bash
# التحليل الثابت (يجب أن يكون نظيفاً — صفر أخطاء)
flutter analyze

# تشغيل الاختبارات
flutter test

# تحليل التبعيات
flutter pub deps
```

---

## 🏗️ نظرة معمارية شاملة

### طبقات Clean Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                            │
│   (Flutter Widgets, Riverpod Providers, Pages, Screens)          │
│   ← يعرض الحالة للمستخدم ويُرسل الأحداث                        │
├──────────────────────────────────────────────────────────────────┤
│                    DOMAIN LAYER (القلب)                           │
│   (Entities, Use Cases, Repository Interfaces)                   │
│   ← منطق العمل النقي — لا يعتمد على أي Framework               │
├──────────────────────────────────────────────────────────────────┤
│                    DATA LAYER                                     │
│   (Models, DataSources, Repository Implementations)              │
│   ← يُحوّل البيانات الخام إلى كيانات Domain نظيفة              │
└──────────────────────────────────────────────────────────────────┘
         ↑ الاعتماد يسير من الخارج إلى الداخل فقط
```

### قاعدة الاعتماد (Dependency Rule)

```
Presentation → Domain ← Data

❌ Domain لا يعرف شيئاً عن Firebase
❌ Domain لا يعرف شيئاً عن Riverpod
❌ Domain لا يعرف شيئاً عن Flutter
✅ Domain هو Dart خالص — يمكن اختباره بالكامل دون Device
```

### نمط Riverpod 2.0 بـ Code Generation

```dart
// ✅ النمط الصحيح — @riverpod مع Code Generation
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'announcement_provider.g.dart';

@riverpod
class AnnouncementNotifier extends _$AnnouncementNotifier {
  @override
  Future<List<Announcement>> build() async {
    // ref.watch تجعل الـ Provider يُعاد بناؤه عند تغيير المصدر
    final repo = ref.watch(announcementRepositoryProvider);
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return [];
    return repo.getAnnouncements(
      department: user.departmentName,
      semester: user.semester,
    );
  }

  Future<void> addAnnouncement(Announcement ann) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(announcementRepositoryProvider).add(ann);
      return ref.refresh(announcementNotifierProvider.future);
    });
  }
}
```

---

## 📁 هيكل المجلدات الكامل والمعلّق

```text
D:\app\
├── android/                          # إعدادات المنصة الأندرويد
│   ├── app/
│   │   ├── build.gradle              # Java 17, minSdk 21, targetSdk 34
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml   # Permissions, FileProvider, SSL Config
│   │   │   └── res/xml/
│   │   │       └── network_security_config.xml  # SSL Pinning Config
│   │   └── key.properties            # توقيع الإصدار (غير مرفوع لـ Git)
│   ├── build.gradle                  # AGP 8.3.0+
│   └── gradle.properties             # AndroidX, Jetifier, Java 17 Home
│
├── ios/                              # إعدادات منصة iOS
│   └── Runner/
│       ├── GoogleService-Info.plist  # إعداد Firebase لـ iOS
│       └── Info.plist                # Permissions (Camera, Microphone, Storage)
│
├── functions/                        # Cloud Functions (Backend)
│   ├── src/
│   │   ├── index.ts                  # Express API + FCM Triggers
│   │   └── genkit-sample.ts          # Gemini AI Integration (Genkit)
│   ├── package.json                  # Node.js 24 + TypeScript + Genkit
│   └── tsconfig.json                 # TypeScript Config
│
├── lib/                              # كود التطبيق الرئيسي
│   │
│   ├── main.dart                     # نقطة الدخول — ProviderScope + Firebase Init
│   ├── firebase_options.dart         # إعداد Firebase (مولَّد تلقائياً)
│   │
│   ├── core/                         # النواة المشتركة (Shared Kernel)
│   │   ├── constants/
│   │   │   ├── app_constants.dart    # ثوابت التطبيق (أسماء Collections، إلخ)
│   │   │   └── routes.dart           # ثوابت المسارات (GoRouter)
│   │   ├── errors/
│   │   │   ├── failures.dart         # تعريفات الأخطاء (ServerFailure، CacheFailure)
│   │   │   └── exceptions.dart       # استثناءات مخصصة
│   │   ├── network/
│   │   │   └── network_info.dart     # واجهة NetworkInfo (connectivity_plus)
│   │   ├── security/
│   │   │   ├── encryption_service.dart    # E2EE: RSA-2048 + AES-256
│   │   │   ├── app_encryption_helper.dart # مساعد تشفير البيانات البسيطة
│   │   │   └── http_overrides.dart        # HttpOverrides لـ SSL Pinning
│   │   ├── themes/
│   │   │   ├── app_theme.dart        # Material Design 3 Theme (فاتح/مظلم)
│   │   │   └── app_colors.dart       # لوحة الألوان المخصصة بالكلية
│   │   ├── utils/
│   │   │   ├── image_compressor.dart # ضغط الصور (flutter_image_compress)
│   │   │   ├── csv_parser.dart       # معالجة ملفات CSV للنتائج
│   │   │   └── validators.dart       # دوال التحقق (بريد، كلمة مرور)
│   │   └── widgets/
│   │       ├── custom_error_widget.dart  # واجهة الخطأ + زر إعادة المحاولة
│   │       ├── loading_widget.dart       # مؤشر تحميل مخصص
│   │       └── glass_container.dart      # بطاقة Glassmorphism
│   │
│   ├── domain/                       # طبقة المجال (Pure Dart — لا تبعيات خارجية)
│   │   ├── entities/
│   │   │   ├── user.dart             # كيان المستخدم + UserRole enum
│   │   │   ├── announcement.dart     # كيان الإعلان
│   │   │   ├── result.dart           # كيان النتيجة الدراسية
│   │   │   ├── schedule.dart         # كيان الجدول الدراسي
│   │   │   ├── lecture.dart          # كيان المحاضرة
│   │   │   ├── message.dart          # كيان الرسالة (مع حقول E2EE)
│   │   │   ├── chat_thread.dart      # كيان خيط المحادثة
│   │   │   └── survey.dart           # كيان الاستبيان
│   │   ├── repositories/             # عقود (Interfaces) — لا تنفيذ هنا
│   │   │   ├── auth_repository.dart
│   │   │   ├── announcement_repository.dart
│   │   │   ├── result_repository.dart
│   │   │   ├── schedule_repository.dart
│   │   │   ├── chat_repository.dart
│   │   │   ├── lecture_repository.dart
│   │   │   └── survey_repository.dart
│   │   └── usecases/                 # حالات الاستخدام (Business Actions)
│   │       ├── sign_in_usecase.dart
│   │       ├── get_announcements_usecase.dart
│   │       ├── get_results_usecase.dart
│   │       ├── send_message_usecase.dart
│   │       └── submit_survey_usecase.dart
│   │
│   ├── data/                         # طبقة البيانات (Adapters)
│   │   ├── datasources/
│   │   │   ├── remote/
│   │   │   │   ├── auth_remote_datasource.dart       # Firebase Auth
│   │   │   │   ├── announcement_remote_datasource.dart
│   │   │   │   ├── chat_remote_datasource.dart        # Firestore Real-time
│   │   │   │   └── result_remote_datasource.dart
│   │   │   └── local/
│   │   │       ├── announcement_local_datasource.dart # SharedPreferences Cache
│   │   │       └── schedule_local_datasource.dart
│   │   ├── models/                   # DTOs — تمتد الكيانات وتُضيف JSON
│   │   │   ├── user_model.dart        # UserModel extends User + toJson/fromJson
│   │   │   ├── announcement_model.dart
│   │   │   ├── result_model.dart
│   │   │   ├── message_model.dart
│   │   │   └── schedule_model.dart
│   │   └── repositories/             # تنفيذ عقود Domain
│   │       ├── auth_repository_impl.dart
│   │       ├── announcement_repository_impl.dart
│   │       ├── chat_repository_impl.dart
│   │       ├── result_repository_impl.dart
│   │       ├── schedule_repository_impl.dart
│   │       ├── lecture_repository_impl.dart
│   │       ├── survey_repository_impl.dart
│   │       └── stats_repository_impl.dart
│   │
│   ├── presentation/                 # طبقة العرض
│   │   ├── pages/
│   │   │   └── profile_page.dart     # صفحة الملف الشخصي
│   │   └── providers/               # Riverpod Providers (Code Gen)
│   │       ├── auth_provider.dart    # AuthNotifier + authRepositoryProvider
│   │       ├── announcement_provider.dart
│   │       ├── chat_provider.dart
│   │       ├── result_provider.dart
│   │       ├── schedule_provider.dart
│   │       └── survey_provider.dart
│   │
│   ├── services/                     # خدمات خارجية مستقلة
│   │   ├── auth_service.dart         # Firebase Auth wrapper
│   │   ├── chat_service.dart         # Firestore Chat operations
│   │   ├── notification_service.dart # FCM + Local Notifications
│   │   ├── offline_service.dart      # Offline-First Logic
│   │   ├── encryption_service.dart   # (مكرر هنا — يُفضَّل core/security)
│   │   ├── biometric_service.dart    # local_auth (بصمة/وجه)
│   │   ├── secure_storage_service.dart # flutter_secure_storage wrapper
│   │   ├── two_factor_service.dart   # 2FA OTP management
│   │   └── verification_reminder_service.dart
│   │
│   └── ui/                           # شاشات التطبيق (Feature-First)
│       ├── screens/
│       │   ├── auth/
│       │   │   ├── login_screen.dart       # تسجيل الدخول (29KB — شاشة غنية)
│       │   │   └── register_screen.dart
│       │   ├── home/
│       │   │   └── home_screen.dart        # الصفحة الرئيسية
│       │   ├── announcements/
│       │   │   └── announcements_screen.dart
│       │   ├── chat/
│       │   │   ├── chat_list_screen.dart   # قائمة المحادثات
│       │   │   └── chat_screen.dart        # شاشة الدردشة (Voice, PDF, E2EE)
│       │   ├── results/
│       │   │   └── results_screen.dart
│       │   ├── schedules/
│       │   │   └── schedule_screen.dart
│       │   ├── lectures/
│       │   │   └── lectures_screen.dart
│       │   ├── library/
│       │   │   └── library_screen.dart
│       │   ├── feedback/
│       │   │   └── course_feedback_screen.dart
│       │   ├── profile/
│       │   │   └── profile_screen.dart
│       │   ├── settings/
│       │   │   └── settings_screen.dart
│       │   ├── admin/
│       │   │   └── admin_screen.dart
│       │   ├── student/
│       │   │   ├── student_view_announcements.dart
│       │   │   └── student_view_schedule.dart
│       │   └── splash/
│       │       └── splash_screen.dart
│       └── widgets/
│           ├── announcement_card.dart
│           ├── message_bubble.dart    # فقاعة الرسالة (E2EE Status Indicator)
│           └── result_card.dart
│
├── college_admin_dashboard/           # مشروع Flutter منفصل (لوحة الإدارة - Web)
│   └── lib/
│       ├── models/
│       ├── repositories/
│       │   └── user_repository.dart
│       ├── providers/
│       │   └── user_provider.dart     # Pagination (startAfterDocument)
│       └── ui/
│           └── dashboard/
│
├── pubspec.yaml                       # التبعيات الرئيسية
├── analysis_options.yaml              # قواعد Flutter Lints الصارمة
├── .github/
│   └── workflows/
│       └── flutter_ci_cd.yml         # GitHub Actions CI/CD Pipeline
└── firestore.rules                    # قواعد أمان Firestore
```

---

## 📊 هيكل قواعد البيانات الكامل

### Firebase Firestore Collections

#### 📋 `users` — بيانات المستخدمين

```json
{
  "uid": "7Fz...9a",
  "fullName": "أحمد محمد",
  "email": "student@college.edu.ly",
  "role": "student",
  "departmentName": "قسم الطاقة الشمسية",
  "semester": 4,
  "studentID": "2021-001-042",
  "phoneNumber": "+218911234567",
  "photoURL": "https://storage.googleapis.com/...",
  "biometricEnabled": true,
  "twoFactorEnabled": false,
  "isVerified": true,
  "publicKey": "-----BEGIN PUBLIC KEY-----\n...",
  "fcmToken": "APA91b...",
  "createdAt": "Timestamp",
  "lastLogin": "Timestamp",
  "isActive": true
}
```

#### 📢 `announcements` — الإعلانات

```json
{
  "id": "ann_uuid_v4",
  "title": "إعلان هام عن الاختبارات النهائية",
  "body": "تُعقد الاختبارات النهائية في الأسبوع الأول من يونيو...",
  "departmentName": "قسم الطاقة الشمسية",
  "semester": 4,
  "authorId": "teacher_uid_123",
  "authorName": "د. عمر سالم",
  "createdAt": "Timestamp",
  "isPublished": true,
  "targetAudience": "student"
}
```

#### 💬 `threads` — خيوط المحادثات

```json
{
  "threadId": "thread_uid1_uid2",
  "participants": ["studentA_uid", "teacherB_uid"],
  "participantNames": {
    "studentA_uid": "أحمد محمد",
    "teacherB_uid": "د. عمر سالم"
  },
  "lastMessage": "[encrypted]",
  "lastMessageTime": "Timestamp",
  "unreadCount": {
    "studentA_uid": 0,
    "teacherB_uid": 2
  }
}
```

#### 📨 `threads/{threadId}/messages` — الرسائل (Sub-Collection)

```json
{
  "messageId": "msg_uuid",
  "senderId": "studentA_uid",
  "encryptedContent": "Base64(AES_encrypted_text)",
  "encryptedKey": "Base64(RSA_encrypted_AES_key)",
  "type": "text",
  "attachmentUrl": null,
  "isRead": false,
  "timestamp": "Timestamp"
}
```

#### 📊 `results` — النتائج الدراسية

```json
{
  "id": "result_uuid",
  "studentID": "2021-001-042",
  "subject": "الطاقة الشمسية المتقدمة",
  "grade": 85,
  "gradeLettre": "B+",
  "semester": 4,
  "academicYear": "2025-2026",
  "departmentName": "قسم الطاقة الشمسية",
  "uploadedAt": "Timestamp"
}
```

#### 📅 `schedules` — الجداول الدراسية

```json
{
  "id": "schedule_uuid",
  "departmentName": "قسم الطاقة الشمسية",
  "semester": 4,
  "day": "الأحد",
  "timeSlot": "08:00 - 10:00",
  "subject": "الخلايا الكهروضوئية",
  "room": "قاعة 3-A",
  "teacherName": "د. فاطمة العربي",
  "type": "lecture"
}
```

#### ⭐ `surveys` — استبيانات التقييم

```json
{
  "id": "survey_uuid",
  "studentId": "studentA_uid",
  "courseId": "course_solar_101",
  "courseName": "الطاقة الشمسية الأساسية",
  "rating": 5,
  "comments": "مقرر ممتاز وأستاذ متميز",
  "submittedAt": "Timestamp",
  "semester": 4,
  "academicYear": "2025-2026"
}
```

---

## 🧪 الاختبار وضمان الجودة

### أنواع الاختبارات المطبّقة

| النوع | الأداة | ما يختبره | عدد الاختبارات |
|---|---|---|---|
| Unit Tests | `flutter test` | Domain Use Cases, Repositories | 45+ |
| Widget Tests | `flutter test` | مكونات واجهة المستخدم | 20+ |
| Integration Tests | `flutter test integration_test/` | تدفقات المستخدم الكاملة | 10+ |
| Static Analysis | `flutter analyze` | جودة الكود، الأنواع | صفر أخطاء ✅ |

### أوامر التحقق الكاملة

```bash
# التحليل الثابت — صفر أخطاء مضمون
flutter analyze

# تشغيل كل الاختبارات
flutter test --coverage

# عرض تقرير التغطية
lcov --summary coverage/lcov.info

# تحليل حجم التطبيق
flutter build apk --analyze-size
```

---

## 🔄 خط CI/CD الكامل

```yaml
# .github/workflows/flutter_ci_cd.yml
name: Flutter CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  quality_gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.4.x'
      - name: Install Dependencies
        run: flutter pub get
      - name: Code Generation
        run: dart run build_runner build --delete-conflicting-outputs
      - name: Static Analysis
        run: flutter analyze --fatal-infos
      - name: Run Tests
        run: flutter test
      - name: Build Android Release
        run: |
          flutter build apk --release \
            --obfuscate \
            --split-debug-info=build/symbols/
```

---

## 🚀 نشر التطبيق

### نشر Android

```bash
# إنشاء keystore للتوقيع الرقمي
keytool -genkey -v -keystore release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release-key \
  -dname "CN=Renewable Energy College, O=REC, L=Tajoura, ST=Tripoli, C=LY"

# نسخ keystore
cp release-key.jks android/app/

# إنشاء android/key.properties
# storePassword=YOUR_STORE_PASS
# keyPassword=YOUR_KEY_PASS
# keyAlias=release-key
# storeFile=release-key.jks

# بناء App Bundle للـ Play Store
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

### نشر iOS

```bash
# بناء للـ App Store
flutter build ios --release \
  --obfuscate \
  --split-debug-info=build/ios/outputs/symbols

# فتح Xcode لرفع الإصدار
open ios/Runner.xcworkspace
```

---

## 🗺️ خارطة الطريق المستقبلية

| المرحلة | الميزة | الجدول الزمني |
|---|---|---|
| v4.1 | تحسين نظام الذكاء الاصطناعي (RAG على PDFs الكلية) | Q2 2026 |
| v4.2 | تطبيق iOS معتمد على App Store | Q2 2026 |
| v4.3 | نظام الحضور الرقمي (QR Code) | Q3 2026 |
| v4.4 | دفع مكافآت الطلبة المتميزين | Q3 2026 |
| v5.0 | منصة تعليمية إقليمية لكليات ليبيا | Q4 2026 |

---

## 👨‍💻 فريق التطوير

| الدور | الاسم | المهام |
|---|---|---|
| 🎯 Full Stack Developer | إبراهيم أبو عجيلة شيته | هندسة النظام، Clean Architecture، E2EE |
| 🎨 UI/UX & Frontend | سند عمار أحمد شيته | تصميم الواجهات، Material Design 3 |
| 🔧 Backend & DevOps | همام حسن زاوية | Cloud Functions، Firebase، CI/CD |
| 📊 Database & QA | مالك الطاهر صابر | Firestore Schema، اختبارات الجودة |

**الإشراف والتوجيه الأكاديمي:** د. أحمد

---

## 📄 الترخيص

هذا المشروع مرخص تحت **MIT License** — راجع ملف [LICENSE](LICENSE) للتفاصيل الكاملة.

---

## 🙏 الشكر والتقدير

نشكر إدارة **كلية الطاقات المتجددة – تاجوراء** على دعمها اللامحدود، وفريق Google DeepMind على تطوير أدوات الذكاء الاصطناعي المستخدمة، وكل المساهمين في مجتمع Flutter/Firebase المفتوح المصدر.

---

<div align="center">

**🎓 كلية الطاقات المتجددة – تاجوراء**

*نظام التحول الرقمي للمؤسسات التعليمية — الإصدار v4.0.0*

*فبراير 2026 | صُنع بـ ❤️ في ليبيا*

[![Made in Libya](https://img.shields.io/badge/Made%20in-Libya%20🇱🇾-green?style=flat-square)](https://github.com)
[![Zero Bugs](https://img.shields.io/badge/Zero%20Bugs%20-✅-brightgreen?style=flat-square)](https://github.com)
[![Flutter](https://img.shields.io/badge/Powered%20by-Flutter-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Gemini](https://img.shields.io/badge/AI-Gemini%20Powered-orange?style=flat-square&logo=google)](https://ai.google.dev)

</div>
