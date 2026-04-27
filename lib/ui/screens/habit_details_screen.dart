import 'package:badhabit_tracker/core/utils/date_helper.dart';
import 'package:badhabit_tracker/data/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/cubits/habit_cubit.dart';
import '../../logic/cubits/habit_state.dart';
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
  Color _animationColor = Colors.transparent;

  // Başlangıç değerini widget'tan alıyoruz
  late HabitModel _currentDisplayHabit;

  @override
  void initState() {
    super.initState();
    _currentDisplayHabit = widget.habit;

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
          title: const Text('Are U so weak'),
          content: const Text('This will delete your progress forever!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('No i will stay'),
            ),
            TextButton(
              onPressed: () {
                context.read<HabitCubit>().removeHabit(widget.habit.id);
                Navigator.pop(context);
                Navigator.pop(dialogContext);
              },
              child: const Text('Yes  iam so weak'),
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
            onSelected: (value) {
              if (value == 'edit') {
                print('edit');
              } else if (value == 'delete') {
                _showDeleteDialog();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          // ÖNEMLİ: Build içinde değişken atamak yerine yerel bir değişken kullanıyoruz
          // Bu, RangeError ve Memory Leak sorununu çözer.
          final displayHabit = (state is HabitLoaded)
              ? state.habits.firstWhere(
                  (h) => h.id == widget.habit.id,
                  orElse: () => _currentDisplayHabit,
                )
              : _currentDisplayHabit;

          // Güncel veriyi buton basıldığında kullanmak üzere sakla
          _currentDisplayHabit = displayHabit;

          final timeData = DateHelper.getDetailedTime(displayHabit.startDate);
          final reversedLogs = displayHabit.failDates.reversed.toList();

          return SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeaderSection(displayHabit, timeData),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.r,
                      vertical: 15.h,
                    ),
                    child: Text(

                      'Attempts History',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= reversedLogs.length) return const SizedBox.shrink();
                      
                      return _buildHistoryItem(
                        reversedLogs[index],
                        index,
                        reversedLogs.length,
                      );
                    },
                    childCount: reversedLogs.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(
    HabitModel currentHabit,
    Map<String, String> timeData,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30.r),
                decoration: BoxDecoration(
                  border: Border.all( // Düzeltildi: BoxBorder.all yerine Border.all
                    width: 10.r,
                    color: Color(currentHabit.color),
                  ),
                  borderRadius: BorderRadius.circular(70.r),
                ),
                width: 140.w,
                child: Image.asset(currentHabit.icon),
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: _animationColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20.w,
                      children: [
                        LiveCounter(value: '${timeData['days']}', label: 'Days'),
                        LiveCounter(value: '${timeData['hours']}', label: 'Hours'),
                        LiveCounter(value: '${timeData['minutes']}', label: 'Minutes'),
                        LiveCounter(value: '${timeData['seconds']}', label: 'Seconds'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          context.read<HabitCubit>().giveUp(currentHabit);
                          if (mounted) {
                            setState(() {
                              _animationColor = Colors.red.withOpacity(0.3);
                            });
                          }
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) {
                              setState(() {
                                _animationColor = Colors.transparent;
                              });
                            }
                          });
                        },
                        child: const Text(
                          'Give Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(DateTime date, int index, int totalCount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.r, vertical: 8.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 81, 0, 0),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            child: Text(
              "${totalCount - index}",
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}",
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}