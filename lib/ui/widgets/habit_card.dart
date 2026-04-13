import 'package:badhabit_tracker/data/models/habit_model.dart';
import 'package:badhabit_tracker/logic/cubits/habit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: Color(habit.color), width: 7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Deyn v zabyaske ${_getDaysCount(habit.startDate)}',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
          IconButton(
            onPressed: () => _confirmDelete(context, habit),
            icon: const Icon(Icons.delete_forever_outlined),
          ),
        ],
      ),
    );
  }
}

int _getDaysCount(DateTime startDate) {
  return DateTime.now().difference(startDate).inDays;
}

void _confirmDelete(BuildContext context, HabitModel habit) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('DELETE HABIT?'),
      content: Text('Are u sure bro?'),
      actions: [
        TextButton(
          onPressed: () {
            context.read<HabitCubit>().removeHabit(habit.id);
            Navigator.pop(dialogContext);
          },
          child: const Text('Net brad ya derjus'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Da udalay naxuy',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
