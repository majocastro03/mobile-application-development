const express = require('express');
const pool = require('../config/db');
const { sendPushNotification } = require('../services/firebase');
const verifyToken = require('../middlewares/auth');
const router = express.Router();

// Enviar mensaje
router.post('/send', verifyToken, async (req, res) => {
  const { receiver_email, title, body } = req.body;
  const sender_email = req.user.email;

  try {
    // Verificar que el destinatario existe
    const [receiver] = await pool.query('SELECT * FROM users WHERE email = ?', [receiver_email]);
    if (receiver.length === 0) {
      return res.status(400).json({ message: 'Destinatario no encontrado' });
    }

    // Guardar mensaje en la base de datos
    const [messageResult] = await pool.query(
      'INSERT INTO messages (sender_email, receiver_email, title, body) VALUES (?, ?, ?, ?)',
      [sender_email, receiver_email, title, body]
    );
    const messageId = messageResult.insertId;

    // Obtener tokens FCM del destinatario
    const [tokens] = await pool.query('SELECT fcm_token FROM fcm_tokens WHERE user_email = ?', [receiver_email]);

    // Enviar notificaciones push
    const notificationResults = [];
    for (const token of tokens) {
      const result = await sendPushNotification(token.fcm_token, title, body);

      // Guardar resultado de la notificación
      await pool.query(
        'INSERT INTO push_notifications (message_id, fcm_token, firebase_response) VALUES (?, ?, ?)',
        [messageId, token.fcm_token, JSON.stringify(result)]
      );

      notificationResults.push(result);
    }

    res.json({ message: 'Mensaje enviado', notificationResults });
  } catch (error) {
    res.status(500).json({ message: 'Error al enviar mensaje', error: error.message });
  }
});

module.exports = router;