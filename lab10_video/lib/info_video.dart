import 'package:flutter/material.dart';

class InfoVideo extends StatelessWidget {
  final String name;
  final String time;
  final String size;

  const InfoVideo({
    super.key,
    required this.name,
    required this.time,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(time),
        Text(size),
      ],
    );
  }
}
