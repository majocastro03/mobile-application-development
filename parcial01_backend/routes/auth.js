const express = require('express');
const router = express.Router();
const db = require('../database/db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const SECRET_KEY = 'majocastrox';

// Inicio de sesión
router.post('/login', (req, res) => {
    const { email, password_hash } = req.body;
  
    // Validar que los datos no estén vacíos
    if (!email || !password_hash) {
      return res.status(400).json({ message: 'Email y contraseña son requeridos' });
    }
  
    // Buscar al usuario en la base de datos
    const user = db.prepare('SELECT * FROM usuarios WHERE email = ?').get(email);
    if (!user) {
      return res.status(400).json({ message: 'Usuario no encontrado' });
    }
  
    // Validar que el usuario tenga una contraseña almacenada
    if (!user.password_hash) {
      return res.status(500).json({ message: 'La contraseña del usuario no está configurada' });
    }
  
    // Verificar la contraseña
    try {
      const isPasswordValid = bcrypt.compareSync(password_hash, user.password_hash);
      if (!isPasswordValid) {
        return res.status(400).json({ message: 'Contraseña incorrecta' });
      }
    } catch (error) {
      console.error('Error al comparar contraseñas:', error);
      return res.status(500).json({ message: 'Error interno al verificar la contraseña' });
    }
  
    // Generar un token JWT con expiración de 7 días
    const token = jwt.sign({ id: user.id }, SECRET_KEY, { expiresIn: '7d' });
  
    // Devolver el token y el ID del usuario
    res.json({
      message: 'Inicio de sesión exitoso',
      token,
      userId: user.id 
    });
  });

// Cerrar sesión
router.post('/logout', (req, res) => {
  res.json({ message: 'Sesión cerrada exitosamente' });
});

module.exports = router;