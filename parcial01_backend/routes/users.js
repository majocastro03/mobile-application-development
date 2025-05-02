const express = require('express');
const router = express.Router();
const db = require('../database/db');

// Obtener todos los usuarios
router.get('/', (req, res) => {
  const usuarios = db.prepare('SELECT * FROM usuarios').all();
  res.json(usuarios);
});

// Obtener un usuario por ID
router.get('/:id', (req, res) => {
  const usuario = db.prepare('SELECT * FROM usuarios WHERE id = ?').get(req.params.id);
  if (!usuario) return res.status(404).json({ message: 'Usuario no encontrado' });
  res.json(usuario);
});

module.exports = router;