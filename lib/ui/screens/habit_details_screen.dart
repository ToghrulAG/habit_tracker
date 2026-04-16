import 'package:badhabit_tracker/data/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/habit_cubit.dart';

class HabitDetailsScreen extends StatefulWidget {
  final HabitModel habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Are so weak'),
          content: Text('This will delete your progress forever!'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('No i will stay'),
            ),
            TextButton(
              onPressed: () {
                context.read<HabitCubit>().removeHabit(widget.habit.id);
                Navigator.pop(context);
                Navigator.pop(dialogContext);
                
              },
              child: Text('Yes  iam so weak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              ///
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
            ],
            //
            onSelected: (value) => {
              if (value == 'edit')
                {print('edit')}
              else if (value == 'delete')
                {_showDeleteDialog()},
            },
          ),
        ],
      ),
      body: SafeArea(child: Column(children: [Text('data')])),
    );
  }
}














// void _confirmDelete(BuildContext context, HabitModel habit) {
//   showDialog(
//     context: context,
//     builder: (dialogContext) => AlertDialog(
//       title: const Text('Are you so WEAK bro?'),
//       content: Text('Dont delete, keep going brother?'),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(dialogContext);
//           },
//           child: const Text('I am going to win it'),
//         ),
//         TextButton(
//           onPressed: () {
//             context.read<HabitCubit>().removeHabit(habit.id);
//             Navigator.pop(context);
//           },
//           child: const Text('I am Loser', style: TextStyle(color: Colors.red)),
//         ),
        
        
//       ],
      
      
//     ),
//   );
// }