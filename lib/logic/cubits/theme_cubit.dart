import 'package:badhabit_tracker/data/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Isar isar;

  ThemeCubit({required this.isar}) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final settings = await isar.settingsModels.get(1);

    if (settings == null || settings.isDarkMode == null) {
      emit(ThemeMode.system);
    } else if (settings.isDarkMode == true) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }

  Future<void> changeTheme(bool isDark) async {
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    try {
      final currentSetting = await isar.settingsModels.get(1);

      final updatedSettings = SettingsModel(
        isDarkMode: isDark,
        isNotificationEnabled: currentSetting?.isNotificationEnabled,
      )..id = 1;

      await isar.writeTxn(() async {
        await isar.settingsModels.put(updatedSettings);
      });
    } catch (e) {
      emit(!isDark ? ThemeMode.dark : ThemeMode.light);
      print('Error THEME CUBIT $e');
    }
  }
}
