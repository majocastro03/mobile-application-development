import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final TextEditingController controller;

  const CalculatorDisplay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 202, 224, 166),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color.fromARGB(255, 173, 173, 173)),
      ),
      child: TextField(
        controller: controller,
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
