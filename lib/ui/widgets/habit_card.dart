import 'package:badhabit_tracker/data/models/habit_model.dart';
import 'package:badhabit_tracker/logic/cubits/habit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 40, 40, 40),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(habit.icon, width: 50, height: 50),
            SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        habit.title,
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(habit.color),
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 5,),
                          Text(
                            'Current Goal',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(
                                '${_getDaysCount(habit.startDate)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(habit.color),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text('days', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 5,),
                          Text(
                            'Attempt',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            '15',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(habit.color),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 5,),
                          Text(
                            'Record',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(
                                '15',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(habit.color),
                                ),
                              ),
                              SizedBox(width: 5),

                              Text('days', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
      title: const Text('Are you so WEAK bro?'),
      content: Text('Dont delete, keep going brother?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
          },
          child: const Text('I am going to win it'),
        ),
        TextButton(
          onPressed: () {
            context.read<HabitCubit>().removeHabit(habit.id);
            Navigator.pop(context);
          },
          child: const Text('I am Loser', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
