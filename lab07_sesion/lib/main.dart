import 'package:flutter/material.dart';
import 'package:lab07_sesion/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      home: Login(),
    );
  }
}
