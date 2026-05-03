import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryItemWidget extends StatelessWidget {
  final DateTime date;
  final int index;
  final int totalCount;

  const HistoryItemWidget({
    super.key,
    required this.date,
    required this.index,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 8, 8).withOpacity(0.2),
        border: Border.all(color: const Color.fromARGB(154, 206, 2, 22)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.block_rounded,
            color: Color.fromARGB(174, 206, 2, 22),
          ),
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
