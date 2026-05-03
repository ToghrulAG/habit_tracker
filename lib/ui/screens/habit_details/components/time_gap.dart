import 'package:flutter/material.dart';

class TimeGap extends StatelessWidget {
  final Duration duration;

  const TimeGap({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    String gapText = "";

    if (duration.inDays > 0) {
      gapText = "${duration.inDays} Gün Dayandın";
    } else if (duration.inHours > 0) {
      gapText = "${duration.inHours} Saat Dayandın";
    } else {
      gapText = "${duration.inMinutes} Dakika Dayandın";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: Colors.white38,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  gapText,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 2,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
