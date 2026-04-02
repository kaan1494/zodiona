const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
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
