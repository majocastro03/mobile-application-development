import 'package:flutter/material.dart';

class VistaRuta1 extends StatelessWidget {
  final String data;

  const VistaRuta1({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String? textData =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vista 2'),
      ),
      body: Center(
        child: Text('Datos recibidos: ${textData ?? data}'),
      ),
    );
  }
}
