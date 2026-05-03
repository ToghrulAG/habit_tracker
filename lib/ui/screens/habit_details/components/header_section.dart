import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/models/habit_model.dart';
import '../../../../logic/cubits/habit_cubit.dart';
import '../components/live_counter.dart';

class HeaderSection extends StatefulWidget {
  final HabitModel currentHabit;
  final Map<String, String> timeData;

  const HeaderSection({
    super.key, 
    required this.currentHabit, 
    required this.timeData,
  });

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  // Animasyon rengini burada yerel olarak tutuyoruz
  Color _flashColor = Colors.transparent;

  void _triggerFlashEffect() {
    if (!mounted) return;
    
    setState(() {
      _flashColor = Colors.red.withOpacity(0.3);
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _flashColor = Colors.transparent;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // Habit İkonu
              Container(
                padding: EdgeInsets.all(30.r),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 10.r,
                    color: Color(widget.currentHabit.color),
                  ),
                  borderRadius: BorderRadius.circular(70.r),
                ),
                width: 140.w,
                child: Image.asset(widget.currentHabit.icon),
              ),
              SizedBox(height: 20.h),
              
              // Sayaçlar ve Efekt Alanı
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: _flashColor, // Yerel değişkeni kullanıyoruz
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20.w,
                  children: [
                    LiveCounter(value: '${widget.timeData['days']}', label: 'Days'),
                    LiveCounter(value: '${widget.timeData['hours']}', label: 'Hours'),
                    LiveCounter(value: '${widget.timeData['minutes']}', label: 'Minutes'),
                    LiveCounter(value: '${widget.timeData['seconds']}', label: 'Seconds'),
                  ],
                ),
              ),
              
              // Give Up Butonu
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
                      // Hem veriyi güncelle hem efekti başlat
                      context.read<HabitCubit>().giveUp(widget.currentHabit);
                      _triggerFlashEffect();
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
        ),
      ],
    );
  }
}