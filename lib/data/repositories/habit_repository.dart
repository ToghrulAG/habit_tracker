import 'package:badhabit_tracker/data/models/settings_model.dart';
import 'package:path_provider/path_provider.dart';
import '../models/habit_model.dart';
import 'package:isar/isar.dart';

class HabitRepository {
  Isar? _isar;
  
  Isar get isar => _isar!; // Sadece bir degisken Isar in kendisini _isar icine aliyoruz

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory(); // Init metodumuz
    // dir adli degiskene veri tabanin addresini atiyor ileride directory ozelligini kullanmak icin

    try {
      if (Isar.instanceNames.isNotEmpty) {
        // Isari instance namesi bos degilse yani varsa bir sey
        // o zaman instansi degiskene aliyoruz
        _isar = Isar.getInstance();
      } else {
        // bossa dbyi aciyoruz ve Habit shemasini tanimliyoruz, dir.path yazarak da onun yerini belirliyoruz

        _isar = await Isar.open([HabitModelSchema, SettingsModelSchema], directory: dir.path);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> addHabit(HabitModel newHabit) async {
    final db = await isar;

    try {
      return await db.writeTxn(() async {
        return await db.habitModels.put(newHabit);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteHabit(int habitId) async {
    final db = await isar;
    try {
      await db.writeTxn(() async {
        await db.habitModels.delete(habitId);
      });
      print('$habitId idli HABIT SILINDI');
    } catch (e) {
      throw Exception('$habitId idli HABIT SILINEMEDI $e');
    }
  }

  Future<List<HabitModel>> getAllHabits() async {
    final db = await isar;
    try {
      return await db.habitModels.where().sortByPosition().findAll();
    } catch (e) {
      return [];
    }
  }

  Future<void> syncHabitsWithLocal(List<HabitModel> remoteHabits) async {
    final db = await isar;

    try {
      await db.writeTxn(() async {
        await db.habitModels.putAll(remoteHabits);
      });
    } catch (e) {
      throw Exception("Local DB senkronizasyon hatasi $e");
    }
  }

  Future<void> clearAllLocalDb() async {
    final db = await isar;

    await db.writeTxn(() async {
      await db.habitModels.clear();
    });
  }
}
