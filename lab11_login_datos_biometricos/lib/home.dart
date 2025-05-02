import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    loadBiometricStatus();
  }

  Future<void> loadBiometricStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;
    });
  }

  Future<void> enableBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('http://localhost:5000/api/enable-biometrics'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token ?? '',
      },
    );

    if (response.statusCode == 200) {
      await prefs.setBool('biometrics_enabled', true);
      setState(() => biometricsEnabled = true);
      showSnackbar('Autenticación biométrica habilitada');
    } else {
      showSnackbar('Error al habilitar biometría');
    }
  }

  void showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: Center(
        child: biometricsEnabled
            ? const Text("Autenticación biométrica ya habilitada")
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onPressed: enableBiometrics,
                child: const Text("Habilitar reconocimiento biométrico"),
              ),
      ),
    );
  }
}
