import 'package:flutter/material.dart';
import 'views/lista_articulos.dart';
import 'views/login.dart';
import 'views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoginView.id,
      routes: {
        LoginView.id: (context) => const LoginView(),
        HomeView.id: (context) => const HomeView(),
        '/articulos': (context) => const ListaArticulos(
              soloOfertas: false,
              titulo: 'Lista de Artículos',
              colorTitulo: Colors.blue,
            ),
        '/ofertas': (context) => const ListaArticulos(
              soloOfertas: true,
              titulo: 'Lista de Ofertas',
              colorTitulo: Colors.red,
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
