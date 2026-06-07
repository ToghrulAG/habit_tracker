import 'package:badhabit_tracker/logic/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/cubits/auth_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationEnabled = true;
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state;

    final currentTheme = context.watch<ThemeCubit>().state;

    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Settings'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Container(
            child: Column(
              children: [
                Card(
                  color: const Color.fromARGB(255, 33, 33, 33),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20.r,
                      foregroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,

                      child: Icon(Icons.import_contacts),
                    ),
                    title: Text(
                      user?.displayName
                              ?.split(' ')
                              .where(
                                (s) => !RegExp(
                                  r"[''"
                                  "‘’“”]",
                                ).hasMatch(s),
                              )
                              .join(' ') ??
                          'UserName',
                    ),
                    subtitle: Text(user?.email ?? 'Email'),
                  ),
                ),
                SizedBox(height: 3.h),
                Card(
                  color: const Color.fromARGB(255, 33, 33, 33),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Change Password',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Update and strengthen account security',
                        ),
                        leading: Icon(Icons.key),
                      ),
                      ListTile(
                        title: Text(
                          'Terms of use',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Update and strengthen account security',
                        ),
                        leading: Icon(Icons.notifications),
                      ),
                      SwitchListTile(
                        secondary: Icon(Icons.notifications),
                        title: Text(
                          'Push Notifications',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Customize your notification preferences',
                        ),
                        value: isNotificationEnabled,
                        onChanged: (newValue) {
                          setState(() {
                            isNotificationEnabled = newValue;
                          });
                        },
                      ),
                      BlocBuilder<ThemeCubit, ThemeMode>(
                        builder: (context, themeMode) {
                          final isDarkMode = themeMode == ThemeMode.dark;

                          return SwitchListTile(
                            value: isDarkMode,
                            onChanged: (bool newValue) {
                              context.read<ThemeCubit>().changeTheme(newValue);
                            },
                          );
                        },
                      ),
                      // SwitchListTile(value: value, onChanged: onChanged)
                      SizedBox(height: 10.h),
                      ListTile(
                        onTap: () {
                          context.read<AuthCubit>().logOut();
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.logout,
                          color: const Color.fromARGB(167, 255, 72, 59),
                        ),
                        title: Text(
                          'Log out',
                          style: TextStyle(
                            color: Color.fromARGB(167, 255, 72, 59),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
