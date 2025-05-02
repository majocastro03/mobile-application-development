import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VistaRuta2 extends StatelessWidget {
  final String data;

  const VistaRuta2({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String textData = Get.arguments ?? data;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vista Ruta 3'),
      ),
      body: Center(
        child: Text('Datos recibidos: $textData'),
      ),
    );
  }
}
