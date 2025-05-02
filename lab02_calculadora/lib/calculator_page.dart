import 'package:flutter/material.dart';
import 'calculator_display.dart';
import 'calculator_buttons.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 175, 182, 165),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 226, 205),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalculatorDisplay(displayValue: _display),
                SizedBox(height: 10),
                CalculatorButtons(onButtonPressed: onButtonPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onButtonPressed(String button) {
    setState(() {
      _display = button;
    });
  }
}
