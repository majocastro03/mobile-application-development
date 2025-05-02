import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz03/views/home.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static String id = 'login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _hasJWT = false;

  Future<void> _checkJWT() async {
    final token = await _secureStorage.read(key: 'secure_jwt_token');
    setState(() {
      _hasJWT = token != null;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkJWT();
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final url = Uri.parse('http://localhost:5000/api/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
          'tokenType': 0,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          // Guardamos también usuario y clave si se quiere login biométrico
          await _secureStorage.write(
              key: 'secure_username', value: _usernameController.text.trim());
          await _secureStorage.write(
              key: 'secure_password', value: _passwordController.text.trim());
          await _secureStorage.delete(
              key: 'secure_jwt_token'); // Asegura que no esté por accidente

          await _checkJWT(); // Actualizamos el estado para reflejar el cambio

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        } else {
          showError('Usuario o clave incorrecta');
        }
      } else {
        Map<String, dynamic> error = jsonDecode(response.body);
        showError(error['message'] ?? 'Error de autenticación');
      }
    } catch (e) {
      showError('Error de conexión: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loginWithFingerprint() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String? storedUsername =
          await _secureStorage.read(key: 'secure_username');
      String? storedPassword =
          await _secureStorage.read(key: 'secure_password');

      if (storedUsername != null && storedPassword != null) {
        final url = Uri.parse('http://localhost:5000/api/login');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': storedUsername,
            'password': storedPassword,
            'tokenType': 1,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['token'];

          if (token != null) {
            final prefs = await SharedPreferences.getInstance();
            await _secureStorage.write(key: 'secure_jwt_token', value: token);

            await _checkJWT(); // Actualizamos estado

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
          } else {
            showError('Usuario o clave incorrecta');
          }
        } else {
          Map<String, dynamic> error = jsonDecode(response.body);
          showError(error['message'] ?? 'Error de autenticación');
        }
      } else {
        showError('No se encontraron credenciales almacenadas');
      }
    } catch (e) {
      showError('Error de conexión: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showError(String message) {
    print('Error: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width * 0.9 > 300 ? 300 : size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Usuario',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Contraseña',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: 10),
              if (_hasJWT)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : loginWithFingerprint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Iniciar sesión con huella'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
