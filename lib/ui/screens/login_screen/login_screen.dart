import 'dart:ui';
import 'package:badhabit_tracker/logic/cubits/auth_cubit.dart';
import 'package:badhabit_tracker/ui/screens/signIn_screen/signIn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final String welcomeText = 'Welcome !';
  final String subTitleText = 'Your life is under your control. Change it!';

  late AnimationController _welcomeController;
  late AnimationController _subtitleController;

  late Animation<int> _welcomeAnimation;
  late Animation<int> _subTitleAnimation;

  @override
  void initState() {
    super.initState();
    _welcomeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _welcomeAnimation = IntTween(
      begin: 0,
      end: welcomeText.length,
    ).animate(_welcomeController);

    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _subTitleAnimation = IntTween(
      begin: 0,
      end: subTitleText.length,
    ).animate(_subtitleController);

    _welcomeController.forward().then((onValue) {
      _subtitleController.forward();
    });
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. KATMAN: Arka Plan (ShaderMask & Monochrome)
          Positioned.fill(
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: const [0.6, 1.0],
                ).createShader(rect);
              },
              child: Opacity(
                opacity: 0.1,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Image.asset(
                    'lib/assets/icons/loginBackground.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // 2. KATMAN: İçerik (Kaydırma kaldırıldı)
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 150.w,
                      child: Image.asset('lib/assets/icons/logo.png'),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'HABIT',
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 37, 76, 142),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'HERO',
                            style: TextStyle(
                              fontSize: 25.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),

                    // Typing Animasyonu: Welcome
                    AnimatedBuilder(
                      animation: _welcomeAnimation,
                      builder: (context, child) {
                        String textToShow = welcomeText.substring(
                          0,
                          _welcomeAnimation.value,
                        );
                        return Text(
                          textToShow,
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Typing Animasyonu: Subtitle
                    AnimatedBuilder(
                      animation: _subTitleAnimation,
                      builder: (context, child) {
                        String textToShow = subTitleText.substring(
                          0,
                          _subTitleAnimation.value,
                        );
                        return Text(
                          textToShow,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        );
                      },
                    ),

                    const Spacer(flex: 2),

                    // Aksiyon Butonları
                    SizedBox(
                      width: double.infinity,
                      height: 40.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            37,
                            76,
                            142,
                          ),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 37, 76, 142),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    Text(
                      'Sign in with:',
                      style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                    ),
                    SizedBox(height: 15.h),

                    // Sosyal İkonlar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.read<AuthCubit>().signInWithGoogle();
                          },
                          icon: Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: 32.sp,
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Icon(Icons.facebook, color: Colors.white, size: 32.sp),
                      ],
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
