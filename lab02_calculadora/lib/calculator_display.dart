import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String displayValue;

  CalculatorDisplay({required this.displayValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 202, 224, 166),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color.fromARGB(255, 173, 173, 173)),
      ),
      child: TextField(
        controller: TextEditingController(text: displayValue),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 30,
        ),
        readOnly: true,
        textAlign: TextAlign.right,
      ),
    );
  }
}
