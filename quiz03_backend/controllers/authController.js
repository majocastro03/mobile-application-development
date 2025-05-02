const AuthService = require('../services/authService');

class AuthController {
  static async login(req, res) {
    const { username, password, tokenType } = req.body; // El tipo de token (0 o 1)

    try {
      // Llamar al servicio de autenticación
      const result = await AuthService.login(username, password, tokenType);

      // Si hubo un error, enviamos el mensaje de error
      if (result.error) {
        return res.status(401).send({ error: result.error });
      }

      // Si todo es correcto, enviamos el token generado
      res.json(result); 
    } catch (error) {
      return res.status(500).send({ error: 'Error en el servidor' });
    }
  }
}

module.exports = AuthController;
