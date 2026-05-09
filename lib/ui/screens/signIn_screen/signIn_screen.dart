import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          child: SizedBox.expand(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.account_circle, size: 50.r),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    'Login to continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email_outlined),

                        filled: true,
                        fillColor: const Color.fromARGB(255, 30, 30, 30),

                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
                    child: TextField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.password_sharp),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            color: _isObscure
                                ? const Color.fromARGB(119, 76, 175, 79)
                                : const Color.fromARGB(122, 244, 67, 54),
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),

                        filled: true,
                        fillColor: const Color.fromARGB(255, 30, 30, 30),

                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      width: double.infinity,

                      height: 30.h,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 37, 76, 142),
                        ),
                        child: Text('Sign In'),
                      ),
                    ),
                  ),

                  TextButton(onPressed: () {}, child: Text('Forgot password?')),
                Spacer(flex: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dont have any account?'),
                      TextButton(onPressed: () {
                        
                      }, child: Text('Register'))
                    ],
                  )
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
