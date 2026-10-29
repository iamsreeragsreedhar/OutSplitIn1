import 'package:flutter/material.dart';

class Stat extends StatelessWidget {
  final String value;
  final String title;

  const Stat({super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}
