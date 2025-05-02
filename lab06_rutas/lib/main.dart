import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab06_rutas/vista_login.dart';
import 'package:lab06_rutas/vista_ruta1.dart';
import 'package:lab06_rutas/vista_ruta2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => VistaLogin()),
        GetPage(name: '/vista2', page: () => VistaRuta1(data: '')),
        GetPage(name: '/vista3', page: () => VistaRuta2(data: '')),
      ],
    );
  }
}
