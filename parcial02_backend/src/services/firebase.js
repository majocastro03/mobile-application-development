const admin = require('firebase-admin');

// Inicializar Firebase Admin SDK con las credenciales
admin.initializeApp({
  credential: admin.credential.cert(require('../../parcial-final-b5832-firebase-adminsdk-fbsvc-649beeebf4.json')),
});

// Función para enviar notificaciones push
const sendPushNotification = async (fcmToken, title, body) => {
  const message = {
    notification: {
      title,
      body,
    },
    token: fcmToken,
  };

  try {
    const response = await admin.messaging().send(message);
    return { success: true, response };
  } catch (error) {
    return { success: false, error: error.message };
  }
};

module.exports = { sendPushNotification };