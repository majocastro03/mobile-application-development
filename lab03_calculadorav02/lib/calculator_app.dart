import 'package:flutter/material.dart';
import 'calculator_page.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorPage(),
    );
  }
}
