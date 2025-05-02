import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:lab07_sesion/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  // Autenticar usuario en la API
  Future<String?> _authUser(LoginData data) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': data.name, 'contraseña': data.password}),
    );

    if (response.statusCode == 200) {
      // Login exitoso
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];

      // Guardar el token en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return null; // Indica éxito
    } else {
      // Error en el login
      Map<String, dynamic> error = jsonDecode(response.body);
      return error['message'];
    }
  }

  // Simulación de recuperación de contraseña
  Future<String?> _recoverPassword(String name) async {
    if (name == 'admin') {
      return null;
    }
    return 'Usuario no encontrado';
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'My App',
      theme: LoginTheme(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.white,
      ),
      onLogin: _authUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () async {
        // Verificar si hay un token almacenado antes de navegar al Home
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        if (token != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(),
          ));
        } else {
          // Si no hay token, mostrar un mensaje de error o redirigir al login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: No se encontró un token válido')),
          );
        }
      },
    );
  }
}
