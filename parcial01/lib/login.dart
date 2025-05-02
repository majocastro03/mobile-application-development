import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Login extends StatelessWidget {
  // Autenticar usuario en el backend
  Future<String?> _authUser(LoginData data) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': data.name, 'password_hash': data.password}),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];
      int userId = responseData['userId'];
      // Guardar el token y el userId en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('userId', userId);
      return null;
    } else {
      Map<String, dynamic> error = jsonDecode(response.body);
      return error['message'];
    }
  }

  // Simulación de recuperación de contraseña
  Future<String?> _recoverPassword(String name) async {
    print("Recuperar contraseña");
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Stockio',
      theme: LoginTheme(
        primaryColor: const Color.fromARGB(179, 172, 111, 111),
      ),
      onLogin: _authUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () async {
        // Verificar si hay un token almacenado antes de navegar al Home
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? token = preferences.getString('token');
        if (token != null) {
          //Usar navigator.of para que el usuario no pueda volver al inicio de sesión
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(),
          ));
        } else {
          // Si no hay token, mostrar un mensaje de error o redirigir al inicio de sesión
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: No se encontró un token válido')),
          );
        }
      },
    );
  }
}
