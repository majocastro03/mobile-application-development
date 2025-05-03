import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

// Servicio para obtener datos de usuarios
class UserService {
  // Método para obtener todos los usuarios
  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.9:3000/api/users'),
        headers: {
          'Content-Type': 'application/json',
          // Aquí puedes incluir el token de autenticación si es necesario
          // 'Authorization': 'Bearer $token',
        },
      );

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
  static Future<bool> sendMessage(String userId, String message) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.9:3000/api/messages'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'message': message,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error al enviar mensaje: $e');
      return false;
    }
  }
}
