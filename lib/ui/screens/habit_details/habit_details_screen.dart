import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../data/models/habit_model.dart';
import '../../../logic/cubits/habit_cubit.dart';
import '../../../logic/cubits/habit_state.dart';
import '../../../core/utils/date_helper.dart';


import 'components/header_section.dart';
import 'components/history_item.dart';
import 'components/time_gap.dart';
import 'components/start_date.dart';

class HabitDetailsScreen extends StatefulWidget {
  final HabitModel habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  Timer? _timer;
  late HabitModel _currentDisplayHabit;

  @override
  void initState() {
    super.initState();
    _currentDisplayHabit = widget.habit;

   
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Are U so weak?'),
        content: const Text('This will delete your progress forever!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No, I will stay'),
          ),
          TextButton(
            onPressed: () {
              context.read<HabitCubit>().removeHabit(widget.habit.id);
              Navigator.pop(context); // Ekrandan çık
              Navigator.pop(dialogContext); // Dialogu kapat
            },
            child: const Text('Yes, I am weak'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _showDeleteDialog();
            },
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
            ],
          ),
        ],
      ),
      body: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          // Güncel veriyi Bloc'tan çekiyoruz
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
                  child: HeaderSection(
                    currentHabit: displayHabit,
                    timeData: timeData,
                  ),
                ),

                // Başlık: Attempts History
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

                // Geçmiş Listesi
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    // 1. Durum: Yolculuğun başı (En alttaki yeşil kart)
                    if (index == reversedLogs.length) {
                      return StartDate(date: widget.habit.startDate);
                    }

                    // 2. Durum: Normal Loglar ve Aradaki Boşluklar
                    final currentDate = reversedLogs[index];
                    final previousDate = (index + 1 < reversedLogs.length)
                        ? reversedLogs[index + 1]
                        : widget.habit.startDate;

                    final differenceDate = currentDate
                        .difference(previousDate)
                        .abs();

                    return Column(
                      children: [
                        HistoryItemWidget(
                          date: currentDate,
                          index: index,
                          totalCount: reversedLogs.length,
                        ),
                        TimeGap(duration: differenceDate),
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
}
