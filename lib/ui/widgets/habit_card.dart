import 'package:badhabit_tracker/data/models/habit_model.dart';
// import 'package:badhabit_tracker/logic/cubits/habit_cubit.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/habit_details_screen.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetailsScreen(habit: habit),
            ),
          );
        },
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
                            SizedBox(height: 5),
                            Text(
                              'Current Goal',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  '${habit.daysCount}',
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
                            SizedBox(height: 5),
                            Text(
                              'Attempt',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
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
                            SizedBox(height: 5),
                            Text(
                              'Record',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
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
      ),
    );
  }
}




