import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz02/lista_ofertas.dart';
import 'lista_articulos.dart';
import 'menu_principal.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const MenuPrincipal(),
      '/articulos': (context) => const ListaArticulos(),
      '/ofertas': (context) => const ListaOfertas(),
    },
  ));
}
