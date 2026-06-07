import '../../../logic/cubits/auth_cubit.dart';
import 'package:badhabit_tracker/ui/screens/add_habit/add_habit_screen.dart';
import 'package:badhabit_tracker/ui/screens/home_screen/components/empty_list.dart';
import 'package:badhabit_tracker/ui/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/cubits/habit_cubit.dart';
import '../../../logic/states/habit_state.dart';
import 'components/habit_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double dynamicPadding = screenWidth * 0.05;

    final user = context.watch<AuthCubit>().state;
    final habitCubit = context.read<HabitCubit>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            CircleAvatar(
              radius: 25.r,
              foregroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,

              child: const Icon(Icons.person, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hey ${user?.displayName?.split(' ')[0] ?? 'User'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dynamicPadding),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<HabitCubit, HabitState>(
          builder: (context, state) {
            if (state is HabitError) {
              return Center(child: Text(state.message));
            }
            if (state is HabitLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HabitLoaded) {
              final habits = state.habits;

              if (habits.isEmpty) {
                return const EmptyList();
              }

              return ReorderableListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    key: ValueKey(habits[index].id),
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: HabitCard(habit: habits[index]),
                  );
                },
                itemCount: habits.length,
                onReorder: (oldIndex, newIndex) {
                  context.read<HabitCubit>().reorderHabits(oldIndex, newIndex);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: habitCubit,
                  child: const AddHabitScreen(),
                ),
              ),
            );
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning!";
    if (hour < 17) return "Good Afternoon!";
    return "Good Evening !";
  }
}
