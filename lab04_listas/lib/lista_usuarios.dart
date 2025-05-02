import 'package:flutter/material.dart';
import 'package:lab04_listas/item_usuario.dart';

class ListaUsuarios extends StatelessWidget {
  final List<Map<String, dynamic>> aItems = [
    {
      "imagen": "assets/gato.jpeg",
      "nombres": "Andrea Silva",
      "carrera": "Ingeniería Civil",
      "promedio": 3.9
    },
    {
      "imagen": "assets/gatoana.png",
      "nombres": "Ana Sarmiento",
      "carrera": "Ingenieria de Sistemas",
      "promedio": 4.43
    },
    {
      "imagen": "assets/gatocamilo.jpeg",
      "nombres": "Camilo Lopez",
      "carrera": "Ingenieria de Sistemas",
      "promedio": 4.2
    },
    {
      "imagen": "assets/gatojuan.jpeg",
      "nombres": "Juan Lopez",
      "carrera": "Ingenieria de Sistemas",
      "promedio": 4.5
    },
    {
      "imagen": "assets/gatodaniel.jpeg",
      "nombres": "Daniel Valencia",
      "carrera": "Ingenieria de Sistemas",
      "promedio": 4.2
    },
    {
      "imagen": "assets/gatopaola.jpeg",
      "nombres": "Paola Hernandez",
      "carrera": "Ingenieria de Sistemas",
      "promedio": 4.3
    },
    {
      "imagen": "assets/gatoprofe.jpeg",
      "nombres": "Ali Diaz",
      "carrera": "Ingenieria de Sistemas",
      "promedio": 5.0
    }
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> awItems = [];

    for (var aItem in aItems) {
      awItems.add(
        ItemUsuario(
          sImagen: aItem["imagen"].toString(),
          sNombres: aItem["nombres"].toString(),
          sCarrera: aItem["carrera"].toString(),
          fPromedio: aItem["promedio"].toString(),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: awItems,
        ),
      ),
    );
  }
}
