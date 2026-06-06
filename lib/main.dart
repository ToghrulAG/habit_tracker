import 'package:badhabit_tracker/firebase_options.dart';
import 'package:badhabit_tracker/logic/cubits/auth_cubit.dart';
import 'package:badhabit_tracker/ui/screens/login_screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/habit_repository.dart';
import 'logic/cubits/habit_cubit.dart';
import 'ui/screens/home_screen/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase init hatası: $e");
  }

  await GoogleSignIn.instance.initialize();

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
        create: (context) => AuthCubit(habitRepository),
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          builder: (context, child) {
            return BlocBuilder<AuthCubit, User?>(
              builder: (context, user) {
                if (user != null) {
                  return BlocProvider(
                    key: ValueKey(user.uid),
                    create: (context) =>
                        HabitCubit(habitRepository, userId: user.uid),
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
                  );
                } else {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'BadHabit tracker',
                    theme: ThemeData(
                      useMaterial3: true,
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple,
                        brightness: Brightness.dark,
                      ),
                    ),
                    home: const LoginScreen(),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}