import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/habit_repository.dart';
import 'logic/cubits/habit_cubit.dart';

import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final habitRepo = HabitRepository();

  await habitRepo.init();

  runApp(MyApp(habitRepository: habitRepo));
}

class MyApp extends StatelessWidget {
  final HabitRepository habitRepository;

  const MyApp({super.key, required this.habitRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: habitRepository,
      child: BlocProvider(
        create: (context) => HabitCubit(habitRepository)..fetchHabits(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BadHabit tracker',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
