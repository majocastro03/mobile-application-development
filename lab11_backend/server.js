const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2/promise');

const app = express();
const PORT = 5000;
const SECRET_KEY = 'majocastrox';

app.use(cors());
app.use(bodyParser.json());

// Conexión a MySQL
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'root', // tu contraseña
  database: 'lab11'
});

// Ruta para habilitar biometría
app.post('/api/enable-biometrics', async (req, res) => {
  const token = req.headers['authorization'];
  if (!token) return res.status(401).json({ message: 'Token no proporcionado' });

  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    const userId = decoded.id;

    const [result] = await pool.execute(
      'UPDATE users SET biometrico_activo = 1 WHERE id = ?',
      [userId]
    );

    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'Biometría habilitada correctamente' });
    } else {
      res.status(404).json({ message: 'Usuario no encontrado' });
    }
  } catch (error) {
    console.error('Error al habilitar biometría:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
});

// Ruta para login
app.post('/api/login', async (req, res) => {
  const { usuario, contrasena } = req.body;

  try {
    const [rows] = await pool.execute('SELECT * FROM users WHERE email = ?', [usuario]);

    if (rows.length === 0) {
      return res.status(400).json({ message: 'Usuario no encontrado' });
    }

    const user = rows[0];

    if (contrasena !== user.contrasena) {
      return res.status(400).json({ message: 'Contraseña incorrecta' });
    }

    const token = jwt.sign({ id: user.id }, SECRET_KEY, { expiresIn: '1h' });

    res.status(200).json({
      message: 'Inicio de sesión exitoso',
      token,
      biometrico_activo: user.biometrico_activo
    });

  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
});

// Ruta protegida
app.get('/api/protected', (req, res) => {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(401).json({ message: 'Token no proporcionado' });
  }

  jwt.verify(token, SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: 'Token inválido o expirado' });
    }

    res.status(200).json({ message: 'Acceso concedido', userId: decoded.id });
  });
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
