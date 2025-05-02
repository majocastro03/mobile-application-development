const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');
const router = express.Router();

// Registro de usuario
router.post('/register', async (req, res) => {
  const { email, password, full_name, phone, role, photo_url, fcm_token } = req.body;

  try {
    // Verificar si el usuario ya existe
    const [existingUser] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    if (existingUser.length > 0) {
      return res.status(400).json({ message: 'El usuario ya existe' });
    }

    // Encriptar contraseña
    const hashedPassword = await bcrypt.hash(password, 10);

    // Crear usuario
    await pool.query(
      'INSERT INTO users (email, password, full_name, phone, role, photo_url) VALUES (?, ?, ?, ?, ?, ?)',
      [email, hashedPassword, full_name, phone, role, photo_url]
    );

    // Guardar token FCM
    if (fcm_token) {
      await pool.query('INSERT INTO fcm_tokens (user_email, fcm_token) VALUES (?, ?)', [email, fcm_token]);
    }

    // Generar JWT
    const token = jwt.sign({ email }, process.env.JWT_SECRET || 'majocastrox', { expiresIn: '1h' });

    res.status(201).json({ token });
  } catch (error) {
    res.status(500).json({ message: 'Error al registrar usuario', error: error.message });
  }
});

// Login de usuario
router.post('/login', async (req, res) => {
  const { email, password, fcm_token } = req.body;

  try {
    // Verificar usuario
    const [users] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    if (users.length === 0) {
      return res.status(400).json({ message: 'Usuario no encontrado' });
    }

    const user = users[0];

    // Verificar contraseña
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Contraseña incorrecta' });
    }

    // Guardar nuevo token FCM si es diferente
    if (fcm_token) {
      const [existingTokens] = await pool.query('SELECT * FROM fcm_tokens WHERE user_email = ? AND fcm_token = ?', [email, fcm_token]);
      if (existingTokens.length === 0) {
        await pool.query('INSERT INTO fcm_tokens (user_email, fcm_token) VALUES (?, ?)', [email, fcm_token]);
      }
    }

    // Generar JWT
    const token = jwt.sign({ email }, process.env.JWT_SECRET || 'majocastrox', { expiresIn: '1h' });

    res.json({ token });
  } catch (error) {
    res.status(500).json({ message: 'Error al iniciar sesión', error: error.message });
  }
});

module.exports = router;