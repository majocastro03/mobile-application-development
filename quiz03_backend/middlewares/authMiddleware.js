const jwt = require('jwt-simple');

const authenticateJWT = (req, res, next) => {
  const token = req.header('Authorization')?.split(' ')[1];
  if (!token) return res.status(401).send('Acceso denegado');

  jwt.decode(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) return res.status(400).send('Token no válido');
    req.user = decoded;
    next();
  });
};

module.exports = authenticateJWT;
