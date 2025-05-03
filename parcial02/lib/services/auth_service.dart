import 'package:http/http.dart' as http;
import 'dart:convert';

// Servicio para autenticación
class AuthService {
  // Método para registrar un usuario
  static Future<bool> register(
      String name, String email, String password, String? fcmToken) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.9:3000/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'full_name': name,
          'email': email,
          'password': password,
          'fcm_token': fcmToken,
        }),
      );
      print(response.body);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error en registro: $e');
      return false;
    }
  }

  // Método para iniciar sesión
  static Future<bool> login(
      String email, String password, String? fcmToken) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.9:3000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'fcm_token': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        //TO DO
        // guardar el token de autenticación
        final data = json.decode(response.body);
        // Guardar token en SharedPreferences, etc.
        return true;
      }
      return false;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }
}
