const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

/**
 * weekly_horoscopes_general/{sign} belgesine her yazıldığında tetiklenir.
 * O burca sahip kullanıcılara FCM push bildirimi gönderir.
 */
exports.notifyWeeklyHoroscope = onDocumentWritten(
  "weekly_horoscopes_general/{sign}",
  async (event) => {
    const sign = event.params.sign;
    const data = event.data?.after?.data();

    if (!data) return; // Silme işlemi — bildirim gönderme

    const title = data.title ?? `${sign} Haftalık Burç Yorumu`;
    const body = data.body ?? "";
    const preview = body.length > 80 ? `${body.substring(0, 80)}…` : body;

    const db = getFirestore();

    // Bu burca sahip kullanıcıların FCM tokenlarını çek
    const snapshot = await db
      .collection("users")
      .where("zodiacSign", "==", sign)
      .get();

    const tokens = [];
    snapshot.forEach((doc) => {
      const token = doc.data().fcmToken;
      if (token && typeof token === "string") {
        tokens.push(token);
      }
    });

    if (tokens.length === 0) {
      console.log(`${sign} için token bulunamadı.`);
      return;
    }

    // FCM çok-alıcılı bildirim (500'er parça)
    const chunkSize = 500;
    let totalSent = 0;
    let totalFailed = 0;

    for (let i = 0; i < tokens.length; i += chunkSize) {
      const chunk = tokens.slice(i, i + chunkSize);
      const message = {
        notification: {
          title: `✨ ${title}`,
          body: preview,
        },
        android: {
          priority: "high",
          notification: { sound: "default", channelId: "horoscope_weekly" },
        },
        apns: {
          payload: { aps: { sound: "default" } },
        },
        tokens: chunk,
      };

      const response = await getMessaging().sendEachForMulticast(message);
      totalSent += response.successCount;
      totalFailed += response.failureCount;
    }

    console.log(
      `${sign}: ${totalSent} bildirim gönderildi, ${totalFailed} başarısız.`
    );
  }
);

// ── Jeton Satın Alma Doğrulama ────────────────────────────────────────────────
//
// Google Play Console'da tanımlanması gereken ürün ID'leri:
//   zodiona_jetons_010  → 10 jeton
//   zodiona_jetons_025  → 25 jeton
//   zodiona_jetons_050  → 50 jeton
//   zodiona_jetons_100  → 100 jeton
//   zodiona_jetons_250  → 250 jeton
//
// Play Console → Uygulamanız → Para kazanma → Ürünler → Ürün oluştur
// Tip: "Yönetilen ürün" (one-time consumable), fiyatı TL olarak gir.

const IAP_TOKEN_MAP = {
  zodiona_jetons_010: 10,
  zodiona_jetons_025: 25,
  zodiona_jetons_050: 50,
  zodiona_jetons_100: 100,
  zodiona_jetons_250: 250,
};

exports.verifyAndAddTokens = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Giriş yapılmamış.");
  }

  const { productId, purchaseToken, platform } = request.data ?? {};

  if (!productId || !purchaseToken || !platform) {
    throw new HttpsError("invalid-argument", "Eksik parametre.");
  }

  const addedTokens = IAP_TOKEN_MAP[productId];
  if (!addedTokens) {
    throw new HttpsError("invalid-argument", `Geçersiz ürün ID: ${productId}`);
  }

  const db = getFirestore();

  // Aynı purchaseToken daha önce işlendi mi? (tekrar saldırısını engelle)
  const processedRef = db
    .collection("processed_purchases")
    .doc(purchaseToken);

  const processedSnap = await processedRef.get();
  if (processedSnap.exists) {
    // Zaten işlendi — hata fırlatma, sadece mevcut sonucu dön
    return { addedTokens: 0, alreadyProcessed: true };
  }

  // Transaction: jeton ekle + satın almayı kaydet (atomik)
  await db.runTransaction(async (tx) => {
    const userRef = db.collection("users").doc(uid);
    tx.update(userRef, {
      jetonBakiye: FieldValue.increment(addedTokens),
    });
    tx.set(processedRef, {
      uid,
      productId,
      platform,
      processedAt: new Date().toISOString(),
    });
  });

  console.log(`[IAP] ${uid} → ${productId} → +${addedTokens} jeton`);
  return { addedTokens };
});

// ── Danışmanlık Satın Alma Doğrulama ─────────────────────────────────────────
//
// Google Play Console'da tanımlanması gereken ürün ID'leri (Yönetilen ürün):
//   zodiona_danisman_yillik    → Yıllık Öngörü         (₺4.799,99)
//   zodiona_danisman_iliski    → İlişki Uyumu           (₺4.799,99)
//   zodiona_danisman_horary    → Danışmana Sor - Horary (₺899,99)
//   zodiona_danisman_dogum     → Doğum Haritası Analizi (₺1.799,99)
//   zodiona_danisman_elektion  → Eleksiyon Astrolojisi  (₺1.399,00)
//   zodiona_danisman_astrokart → Astrokartografi        (₺1.399,00)

const IAP_CONSULTATION_MAP = {
  zodiona_danisman_yillik: "Yıllık Öngörü",
  zodiona_danisman_iliski: "İlişki Uyumu",
  zodiona_danisman_horary: "Danışmana Sor - Horary",
  zodiona_danisman_dogum: "Doğum Haritası Analizi",
  zodiona_danisman_elektion: "Eleksiyon Astrolojisi",
  zodiona_danisman_astrokart: "Astrokartografi",
};

exports.verifyAndCreateConsultation = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Giriş yapılmamış.");
  }

  const { productId, purchaseToken, platform, advisorName } =
    request.data ?? {};

  if (!productId || !purchaseToken || !platform || !advisorName) {
    throw new HttpsError("invalid-argument", "Eksik parametre.");
  }

  const consultationType = IAP_CONSULTATION_MAP[productId];
  if (!consultationType) {
    throw new HttpsError(
      "invalid-argument",
      `Geçersiz ürün ID: ${productId}`
    );
  }

  const db = getFirestore();

  // Aynı purchaseToken daha önce işlendi mi? (tekrar saldırısını engelle)
  const processedRef = db
    .collection("processed_purchases")
    .doc(purchaseToken);

  const processedSnap = await processedRef.get();
  if (processedSnap.exists) {
    return {
      chatId: processedSnap.data().chatId ?? "",
      alreadyProcessed: true,
    };
  }

  // Kullanıcı profilini al
  const userDoc = await db.collection("users").doc(uid).get();
  const userProfile = userDoc.data() ?? {};

  // Transaction: danışman sohbeti oluştur + satın almayı kaydet (atomik)
  const chatRef = db.collection("advisor_chats").doc();
  const chatId = chatRef.id;

  await db.runTransaction(async (tx) => {
    tx.set(chatRef, {
      userId: uid,
      userEmail: userProfile.email ?? "",
      userName: userProfile.name ?? "",
      advisorName,
      consultationType,
      status: "open",
      createdAt: new Date(),
      updatedAt: new Date(),
      lastMessage: "",
      unreadByAdmin: false,
      unreadByUser: false,
      userProfile,
      paymentProductId: productId,
      paymentPlatform: platform,
    });
    tx.set(processedRef, {
      uid,
      productId,
      platform,
      chatId,
      advisorName,
      processedAt: new Date().toISOString(),
    });
  });

  console.log(
    `[CONSULTATION] ${uid} → ${productId} (${advisorName}) → chatId: ${chatId}`
  );
  return { chatId };
});
