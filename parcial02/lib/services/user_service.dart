import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/user.dart';

// Servicio para obtener datos de usuarios
class UserService {
  // Método para obtener todos los usuarios
  static Future<List<User>> getUsers() async {
    try {
      // Obtener el token desde SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Verifica si el token existe
      if (token == null) {
        throw Exception('Token no encontrado');
      }
      final response = await http.get(
        Uri.parse('http://192.168.1.9:3000/api/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> usersJson = json.decode(response.body);
        return usersJson.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error al obtener usuarios: $e');
      return [];
    }
  }

  // Método para enviar un mensaje a un usuario
  static Future<bool> sendMessage({
    required String receiverEmail,
    required String title,
    required String body,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('Token no encontrado');
        return false;
      }

      final response = await http.post(
        Uri.parse('http://192.168.1.9:3000/api/messages/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'receiver_email': receiverEmail,
          'title': title,
          'body': body,
        }),
      );

      print('Respuesta: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error al enviar mensaje: $e');
      return false;
    }
  }
}
