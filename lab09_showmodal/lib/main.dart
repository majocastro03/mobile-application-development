import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab09_showmodal/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Home()),
      ],
    );
  }
}
