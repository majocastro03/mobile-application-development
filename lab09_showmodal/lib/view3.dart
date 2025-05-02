import 'package:flutter/material.dart';

class View3 extends StatelessWidget {
  final String buttonText;

  const View3({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista 3'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Botón presionado',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
