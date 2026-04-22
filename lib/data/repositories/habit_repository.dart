import 'package:path_provider/path_provider.dart';

import '../models/habit_model.dart';
import 'package:isar/isar.dart';

class HabitRepository {
  Isar? _isar; // Sadece bir degisken Isar in kendisini _isar icine aliyoruz

  Future<Isar> get isar async {
    // Basit bit getter, _isar degiskenin veri tabanina olan erisimini kontrol eder
    if (_isar != null) return _isar!;
    // Eger null degilse o zaman kesin null degil diye return veriyoruz
    await init();
    // Bu sart ise yaramazsa, init metoduna geciyoruz
    return _isar!;
    // Init bittikten sonra null olmayan _isar i geri veriyoruz
  }

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

        _isar = await Isar.open([HabitModelSchema], directory: dir.path);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addHabit(HabitModel newHabit) async {
    final db = await isar;

    try {
      await db.writeTxn(() async {
        await db.habitModels.put(newHabit);
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
      return await db.habitModels.where().findAll();
    } catch (e) {
      return [];
    }
  }
}
