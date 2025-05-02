import 'package:flutter/material.dart';

class Valoracion extends StatelessWidget {
  final int valoracionEntera;

  const Valoracion({Key? key, required this.valoracionEntera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double valoracionDecimal = valoracionEntera / 10;
    int valoracionRedondeada =
        (valoracionDecimal - valoracionDecimal.floor() >= 0.6)
            ? valoracionDecimal.ceil()
            : valoracionDecimal.floor();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          valoracionDecimal.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Icon(
            index < valoracionRedondeada ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
      ],
    );
  }
}
