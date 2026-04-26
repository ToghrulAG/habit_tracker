import 'package:badhabit_tracker/core/utils/date_helper.dart';
import 'package:badhabit_tracker/data/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/cubits/habit_cubit.dart';
import '../widgets/live_counter.dart';
import 'dart:async';

class HabitDetailsScreen extends StatefulWidget {
  final HabitModel habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Are U so weak'),
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
    final timeData = DateHelper.getDetailedTime(widget.habit.startDate);

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15.h),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(30.r),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          width: 10.r,
                          color: Color(widget.habit.color),
                        ),
                        borderRadius: BorderRadius.circular(70.r),
                      ),
                      width: 140.w,
                      child: Image.asset(widget.habit.icon),
                    ),
                    SizedBox(height: 20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 20.w,
                          children: [
                            LiveCounter(
                              value: '${timeData['days']}',
                              label: 'Days',
                            ),
                            LiveCounter(
                              value: '${timeData['hours']}',
                              label: 'Hours',
                            ),
                            LiveCounter(
                              value: '${timeData['minutes']}',
                              label: 'Minutes',
                            ),
                            LiveCounter(
                              value: '${timeData['seconds']}',
                              label: 'Seconds',
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
