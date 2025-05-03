const express = require('express');
const pool = require('../config/db');
const verifyToken = require('../middlewares/auth');
const router = express.Router();

// Obtener todos los usuarios registrados
router.get('/', verifyToken, async (req, res) => {
  try {
    const [users] = await pool.query('SELECT email, full_name, phone, role, photo_url, created_at FROM users');
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener usuarios', error: error.message });
  }
});

module.exports = router;