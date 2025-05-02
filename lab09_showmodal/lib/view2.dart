import 'package:flutter/material.dart';
import 'view3.dart';

class View2 extends StatelessWidget {
  const View2({super.key});

  void _navigateToView3(BuildContext context, String buttonText) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => View3(buttonText: buttonText),
      ),
    );
  }

  _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => _navigateToView3(context, 'Lila'),
                child: const Text(
                  'Botón Lila',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => _navigateToView3(context, 'Rojo'),
                child: const Text(
                  'Botón Rojo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => _navigateToView3(context, 'Naranja'),
                child: const Text(
                  'Botón Naranja',
                  style: TextStyle(color: Colors.white),
                ),
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
        title: const Text('Vista 2'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          onPressed: () => _showOptionsModal(context),
          child: const Text(
            'Mostrar opciones',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
