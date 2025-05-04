import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _positionController = TextEditingController();
  final _photoUrlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Obtener el token FCM desde el servicio existente
      final fcmToken = await FirebaseMessaging.instance.getToken();

      // Registrar usuario con los nuevos campos
      final success = await AuthService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        fcmToken,
        _phoneController.text,
        _positionController.text,
        _photoUrlController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Navegar a la pantalla de inicio
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Mostrar error
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al registrarse. Intente nuevamente.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                _buildTextField(_nameController, 'Nombre', Icons.person),
                const SizedBox(height: 16),
                _buildTextField(
                    _emailController, 'Correo Electrónico', Icons.email,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(_passwordController, 'Contraseña', Icons.lock,
                    obscureText: true),
                const SizedBox(height: 16),
                _buildTextField(_phoneController, 'Teléfono', Icons.phone),
                const SizedBox(height: 16),
                _buildTextField(_positionController, 'Cargo', Icons.work),
                const SizedBox(height: 16),
                _buildTextField(_photoUrlController, 'Foto (URL)', Icons.image),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('CREAR CUENTA'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese $label';
            }
            return null;
          },
    );
  }
}
