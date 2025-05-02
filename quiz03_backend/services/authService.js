const jwt = require('jwt-simple');
const User = require('../models/user');

class AuthService {
  static async login(username, password, tokenType) {
    return new Promise((resolve, reject) => {
      User.findByUsername(username, (err, results) => {
        if (err) {
          console.log('Error al buscar el usuario:', err); // Depuración
          return reject(err);
        }

        if (results.length === 0) {
          return resolve({ error: 'Usuario no encontrado' });
        }

        const user = results[0];

        // Comparación de contraseñas
        if (password !== user.password) {
          return resolve({ error: 'Contraseña incorrecta' });
        }

        // tiempo de expiración según el tipo de token
        const now = Math.floor(Date.now() / 1000); // tiempo actual en segundos
        let exp;

        // Si el tokenType es 0, token de corta duración
        if (tokenType === 0) {
          exp = now + (15 * 60); // 15 minutos
        }
        // Si el tokenType es 1, generamos un token de larga duración
        else if (tokenType === 1) {
          exp = now + (7 * 24 * 60 * 60); // 7 días
        } else {
          return resolve({ error: 'Tipo de token inválido' });
        }

        // Payload con los datos del usuario
        const payload = {
          userId: user.id,
          username: user.username,
          exp: exp // Definimos el tiempo de expiración del token
        };

        // Generar el token
        const token = jwt.encode(payload, process.env.JWT_SECRET, 'HS256');
        return resolve({ token });
      });
    });
  }
}

module.exports = AuthService;
