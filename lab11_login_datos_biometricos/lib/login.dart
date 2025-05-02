import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'biometric_auth.dart';
import 'home.dart';

class Login extends StatelessWidget {
  Future<String?> _authUser(LoginData data) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': data.name, 'contrasena': data.password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final biometricsEnabled = responseData['biometrico_activo'] == 1;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setBool('biometrics_enabled', biometricsEnabled);

      return null;
    } else {
      final error = jsonDecode(response.body);
      return error['message'];
    }
  }

  Future<String?> _recoverPassword(String name) async {
    return name == 'admin' ? null : 'Usuario no encontrado';
  }

  Future<void> _biometricLogin(BuildContext context) async {
    final authenticated = await BiometricAuth.authenticateWithBiometrics();
    if (authenticated) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const Home(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Autenticación biométrica fallida')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final prefs = snapshot.data as SharedPreferences;
        final biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;

        return Scaffold(
          appBar: AppBar(title: const Text("Login")),
          body: Column(
            children: [
              if (biometricsEnabled)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _biometricLogin(context),
                    icon: const Icon(Icons.fingerprint),
                    label: const Text("Acceder con biometría"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                  ),
                ),
              Expanded(
                child: FlutterLogin(
                  title: 'Mi App',
                  theme: LoginTheme(
                    primaryColor: Colors.blueGrey,
                    accentColor: Colors.white,
                  ),
                  onLogin: _authUser,
                  onRecoverPassword: _recoverPassword,
                  onSubmitAnimationCompleted: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token');
                    if (token != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const Home(),
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
