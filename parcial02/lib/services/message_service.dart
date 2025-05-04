import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/message.dart';

// Servicio para obtener y manejar mensajes
class MessageService {
  static const String baseUrl = 'http://192.168.1.9:3000/api';

  // Método para obtener mensajes enviados
  static Future<List<Message>> getSentMessages() async {
    try {
      // Obtener el token desde SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Verifica si el token existe
      if (token == null) {
        throw Exception('Token no encontrado');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/messages/sent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> messagesJson = json.decode(response.body);
        return messagesJson
            .map((message) => Message.fromJson(message))
            .toList();
      } else {
        throw Exception('Error al cargar mensajes enviados: ${response.body}');
      }
    } catch (e) {
      print('Error al obtener mensajes enviados: $e');
      return [];
    }
  }

  // Método para obtener mensajes recibidos
  static Future<List<Message>> getReceivedMessages() async {
    try {
      // Obtener el token desde SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Verifica si el token existe
      if (token == null) {
        throw Exception('Token no encontrado');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/messages/received'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> messagesJson = json.decode(response.body);
        return messagesJson
            .map((message) => Message.fromJson(message))
            .toList();
      } else {
        throw Exception('Error al cargar mensajes recibidos: ${response.body}');
      }
    } catch (e) {
      print('Error al obtener mensajes recibidos: $e');
      return [];
    }
  }
}
