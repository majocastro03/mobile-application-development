import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz03/views/login.dart';

import 'menu.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String id = 'home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _secureStorage = const FlutterSecureStorage();
  bool _isBiometricEnabled =
      false; // Para rastrear si la biometría está habilitada
  bool _hasJWT = false; // Para saber si hay un JWT almacenado

  @override
  void initState() {
    super.initState();
    _checkJWT();
  }

  // Revisar si existe un JWT en almacenamiento seguro
  Future<void> _checkJWT() async {
    final token = await _secureStorage.read(key: 'secure_jwt_token');
    if (token != null) {
      setState(() {
        _isBiometricEnabled =
            true; // Si hay un JWT, la biometría está habilitada
        _hasJWT = true; // Se marca que hay un JWT
      });
    }
  }

  // Función para mostrar el primer modal (huella digital con botón verde)
  void _showFingerprintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Validar huella para inicio de sesión.',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Imagen de huella digital
              Image.asset(
                'assets/fingerprint.png',
                height: 80,
                width: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.fingerprint, size: 80);
                },
              ),
              const SizedBox(height: 20),
              // Botón verde de confirmación
              ElevatedButton(
                onPressed: () {
                  // Cerrar el primer modal
                  Navigator.pop(context);
                  // Mostrar el segundo modal
                  _showConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                ),
                child: const Icon(Icons.check, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  // Función para mostrar el segundo modal (confirmación de inicio con huella)
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirmar inicio de sesión con huella.',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              // Campo Usuario
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Usuario',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Campo Clave
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Contraseña',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Botón Confirmar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Guardar JWT en almacenamiento seguro
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? token = prefs
                        .getString('token'); // Suponiendo que ya está guardado
                    if (token != null) {
                      await _secureStorage.write(
                          key: 'secure_jwt_token', value: token);
                    }

                    // Cerrar el modal de confirmación
                    Navigator.pop(context);

                    // Cambiar el estado del botón
                    setState(() {
                      _isBiometricEnabled =
                          true; // Se habilita la opción de biometría
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: const Text('Confirmar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Función para mostrar el modal para deshabilitar la biometría
  void _showDisableBiometricDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Deseas deshabilitar la autenticación biométrica?',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Botón verde para confirmar deshabilitar
              ElevatedButton(
                onPressed: () async {
                  // Borrar el JWT de almacenamiento seguro
                  await _secureStorage.delete(key: 'secure_jwt_token');
                  setState(() {
                    _isBiometricEnabled =
                        false; // Cambiar estado a no habilitado
                    _hasJWT = false; // Marcar que ya no hay JWT
                  });
                  Navigator.pop(context); // Cerrar el modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                ),
                child: const Icon(Icons.check, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navegar hacia el LoginView en lugar de pop
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mostrar el botón "Habilitar" o "Deshabilitar"
              if (!_isBiometricEnabled)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showFingerprintDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Habilitar'),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDisableBiometricDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Deshabilitar'),
                  ),
                ),
              const SizedBox(height: 20),
              // Botón de Menú
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MenuPrincipal()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text('Menú'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
