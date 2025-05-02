const express = require('express');
const router = express.Router();
const db = require('../database/db');

// Obtener todos los artículos
router.get('/', (req, res) => {
  const { usuario_id } = req.query;

  if (!usuario_id) {
    return res.status(400).json({ message: 'Falta el parámetro usuario_id' });
  }

  const query = `
  SELECT 
    a.*,
    f.id AS id_favorito,
    CASE 
      WHEN f.articulo_id IS NOT NULL THEN 1 
      ELSE 0 
    END AS es_favorito
  FROM 
    articulos a
  LEFT JOIN 
    favoritos f 
  ON 
    a.id = f.articulo_id AND f.usuario_id = ?
  `;

  const articulos = db.prepare(query).all(usuario_id);
  res.json(articulos);
});

module.exports = router;