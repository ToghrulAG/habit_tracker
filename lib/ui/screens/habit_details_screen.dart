import 'package:badhabit_tracker/core/utils/date_helper.dart';
import 'package:badhabit_tracker/data/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/cubits/habit_cubit.dart';
import '../../logic/cubits/habit_state.dart';
import '../widgets/live_counter.dart';
import 'dart:async';
import 'package:intl/intl.dart';

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
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == reversedLogs.length) {
                      return _buildStartDate(widget.habit.startDate);
                    }

                    final currentDate = reversedLogs[index];

                    DateTime? previousDate;

                    if (index + 1 < reversedLogs.length) {
                      previousDate = reversedLogs[index + 1];
                    } else {
                      previousDate = widget.habit.startDate;
                    }

                    final differenceDate = currentDate.difference(previousDate).abs();

                    return Column(
                      children: [
                        _buildHistoryItem(
                          reversedLogs[index],
                          index,
                          reversedLogs.length,
                        ),
                        _buildTimeGap(differenceDate),
                      ],
                    );
                  }, childCount: reversedLogs.length + 1),
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
                  border: Border.all(
                    // Düzeltildi: BoxBorder.all yerine Border.all
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 150.w,
                      height: 40.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 113, 3, 3),
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 8, 8).withOpacity(0.2), 
        border: Border.all(color: const Color.fromARGB(154, 206, 2, 22)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.block_rounded, color: Color.fromARGB(174, 206, 2, 22)),
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

  Widget _buildTimeGap(Duration duration) {
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

          // Alttaki kutuya uzanan dikey bağlantı çizgisi
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

  Widget _buildStartDate(DateTime date) {
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
