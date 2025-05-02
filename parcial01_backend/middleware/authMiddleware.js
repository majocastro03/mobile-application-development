const jwt = require('jsonwebtoken');

const SECRET_KEY = 'majocastrox';

module.exports = (req, res, next) => {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(401).json({ message: 'Token no proporcionado' });
  }

  jwt.verify(token, SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: 'Token inválido o expirado' });
    }
    req.userId = decoded.id; // Adjuntar el ID del usuario al objeto request
    next();
  });
};