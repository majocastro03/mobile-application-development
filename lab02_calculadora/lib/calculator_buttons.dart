import 'package:flutter/material.dart';

class CalculatorButtons extends StatelessWidget {
  final Function(String) onButtonPressed;

  CalculatorButtons({required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildButtonRow(['AC', 'CE', '%', '÷']),
        SizedBox(height: 8),
        buildButtonRow(['7', '8', '9', '×']),
        SizedBox(height: 8),
        buildButtonRow(['4', '5', '6', '-']),
        SizedBox(height: 8),
        buildSpecialButtonRow(),
      ],
    );
  }

  Row buildButtonRow(List<String> labels) {
    return Row(
      children:
          labels.map((label) => Expanded(child: buildButton(label))).toList(),
    );
  }

  Row buildSpecialButtonRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              buildButtonRow(['1', '2', '3']),
              SizedBox(height: 8),
              buildButtonRow(['0', '.', '=']),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 145,
            child: buildButton('+'),
          ),
        ),
      ],
    );
  }

  Widget buildButton(String label) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          onPressed: () => onButtonPressed(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: getButtonColor(label),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color getButtonColor(String button) {
    if (button == 'AC' || button == 'CE') {
      return const Color.fromARGB(255, 238, 176, 84);
    }
    return Color.fromARGB(255, 78, 78, 78);
  }
}
