const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const sqlite3 = require('better-sqlite3');
const jwt = require('jsonwebtoken'); 

const app = express();
const PORT = 5000;

app.use(cors());
app.use(bodyParser.json());

// Conexión a la base de datos SQLite
const db = sqlite3('users.db');

// Clave secreta para firmar los tokens JWT
const SECRET_KEY = 'majocastrox';

// Ruta para iniciar sesión
app.post('/api/login', (req, res) => {
  const { usuario, contraseña } = req.body; 

  // Buscar al usuario en la base de datos
  const user = db.prepare('SELECT * FROM users WHERE email = ?').get(usuario);

  if (!user) {
    return res.status(400).json({ message: 'Usuario no encontrado' });
  }

  // Verificar la contraseña
  if (contraseña !== user.contraseña) {
    return res.status(400).json({ message: 'Contraseña incorrecta' });
  }

  // Generar un token JWT
  const token = jwt.sign({ id: user.iduser }, SECRET_KEY, { expiresIn: '1h' });

  // Respuesta de éxito con el token
  res.status(200).json({ message: 'Inicio de sesión exitoso', token });
});

app.get('/api/protected', (req, res) => {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(401).json({ message: 'Token no proporcionado' });
  }

  // Verificar el token
  jwt.verify(token, SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: 'Token inválido o expirado' });
    }
    res.status(200).json({ message: 'Acceso concedido', userId: decoded.id });
  });
});

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});