import 'package:path_provider/path_provider.dart';

import '../models/habit_model.dart';
import 'package:isar/isar.dart';

class HabitRepository {
  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      isar = await Isar.open([HabitModelSchema], directory: dir.path);
    } else {
      isar = Isar.getInstance()!;
    }
  }

  Future<void> addHabit(HabitModel newHabit) async {
    try {
      await isar.writeTxn(() async {
        await isar.habitModels.put(newHabit);
      });
      print('YENI HABIT DATA BAZAYA ELAVE OLUNDU (HABIT REPOSITORY)');
    } catch (e) {
      throw Exception(
        'YENI HABIT DATA BAZAYA ELAVE OLUNMADI (HABIT REPOSITORY) $e',
      );
    }
  }

  Future<void> deleteHabit(int habitId) async {
    try {
      await isar.writeTxn(() async {
        await isar.habitModels.delete(habitId);
      });
      print('$habitId idli HABIT SILINDI');
    } catch (e) {
      throw Exception('$habitId idli HABIT SILINEMEDI $e');
    }
  }

  Future<List<HabitModel>> getAllHabits() async {
    try {
      return await isar.habitModels.where().findAll();
    } catch (e) {
      return [];
    }
  }
}
