import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricAuth {
  static final LocalAuthentication auth = LocalAuthentication();

  static Future<bool> canCheckBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> authenticateWithBiometrics() async {
    try {
      final isAvailable = await canCheckBiometrics();
      if (!isAvailable) return false;

      final authenticated = await auth.authenticate(
        localizedReason: 'Autenticación biométrica requerida',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return authenticated;
    } catch (e) {
      print('Error de autenticación biométrica: $e');
      return false;
    }
  }
}
