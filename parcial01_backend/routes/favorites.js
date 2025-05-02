const express = require('express');
const router = express.Router();
const db = require('../database/db');
const authMiddleware = require('../middleware/authMiddleware');

// Middleware para proteger las rutas
router.use(authMiddleware);

// Obtener favoritos del usuario
router.get('/', (req, res) => {
  const favoritos = db.prepare(`
    SELECT f.id, a.id AS articulo_id, a.titulo, a.descripcion, a.precio, a.imagen_url, a.proveedor, a.calificacion
    FROM favoritos f
    LEFT JOIN articulos a ON f.articulo_id = a.id
    WHERE f.usuario_id = ?
  `).all(req.userId);
  res.json(favoritos);
});

// Agregar un artículo a favoritos
router.post('/', (req, res) => {
  const { articulo_id } = req.body;
  const result = db.prepare('INSERT INTO favoritos (usuario_id, articulo_id) VALUES (?, ?)').run(req.userId, articulo_id);
  res.json({ id: result.lastInsertRowid, usuario_id: req.userId, articulo_id });
});

// Eliminar un artículo de favoritos
router.delete('/:id', (req, res) => {
  const result = db.prepare('DELETE FROM favoritos WHERE id = ? AND usuario_id = ?').run(req.params.id, req.userId);
  if (result.changes === 0) return res.status(404).json({ message: 'Favorito no encontrado' });
  res.json({ message: 'Favorito eliminado' });
});

module.exports = router;