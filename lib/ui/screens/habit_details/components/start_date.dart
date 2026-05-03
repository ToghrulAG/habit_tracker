import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StartDate extends StatelessWidget {
  final DateTime date;

  const StartDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch, color: Colors.green),
          const SizedBox(width: 12),
          Text(
            DateFormat('MMM d yyyy - HH:mm').format(date),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
