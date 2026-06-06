import 'package:badhabit_tracker/logic/cubits/habit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/habit_model.dart';
import '../../data/repositories/habit_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HabitCubit extends Cubit<HabitState> {
  final HabitRepository repository;
  final String userId;

  final _firestore = FirebaseFirestore.instance;

  HabitCubit(this.repository, {required this.userId}) : super(HabitInitial()) {
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    
     print("fetchHabits çalıştı, userId: $userId"); 
    emit(HabitLoading());
    await repository.clearAllLocalDb();

    try {
      final snapShot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .get();

      final List<HabitModel> remoteHabits = snapShot.docs
          .map((doc) => HabitModel.fromJson(doc.data()))
          .toList();

      await repository.syncHabitsWithLocal(remoteHabits);

      final allHabits = await repository.getAllHabits();
      emit(HabitLoaded(habits: allHabits));
    } catch (e) {
      emit(HabitError(message: "Veri Senkronize edilemedi $e"));
    }
  }

  Future<void> newHabit(HabitModel newHabit) async {
    if (state is HabitLoading) return;

    emit(HabitLoading());
    try {
      final initialRecord = DateTime.now()
          .difference(newHabit.startDate)
          .inDays;

      // 2. Güncellenmiş habit nesnesini oluşturuyoruz
      final habitToSave = newHabit.copyWith(record: initialRecord);

      // 3. TEK BİR KAYIT YAPIYORUZ ve ID'yi alıyoruz
      final savedId = await repository.addHabit(habitToSave);

      // 4. Firestore'a bu ID ile kaydediyoruz
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(savedId.toString())
          .set(habitToSave.copyWith(id: savedId).toJson());

      await fetchHabits();

      print('NEWHABIT İŞLEDİ (CUBIT)');
    } catch (e) {
      emit(HabitError(message: 'YENİ HABIT ƏLAVƏ ETMƏK MÜMKÜN OLMADI: $e'));
    }
  }

  Future<void> removeHabit(int habitId) async {
    emit(HabitLoading());
    try {
      await repository.deleteHabit(habitId);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habitId.toString())
          .delete();

      print('FIRESTORE: $habitId nolu habit silindi.');
      await fetchHabits();
    } catch (e) {
      emit(HabitError(message: 'Yeni habit elave olunmadi $e'));
      throw Exception('$habitId li habit silinmedi (CUBIT)');
    }
  }

  Future<void> giveUp(HabitModel habit) async {
    final recordCheck = DateTime.now().difference(habit.startDate).inDays;
    final updatedRecord = recordCheck > (habit.record ?? 0)
        ? recordCheck
        : habit.record;

    List<DateTime> updatedDates = List.from(habit.failDates);

    final giveUpDate = DateTime.now();

    updatedDates.add(giveUpDate);

    final updatedHabit = habit.copyWith(
      startDate: giveUpDate,
      failDates: updatedDates,
      attempt: habit.attempt + 1,
      record: updatedRecord,
    );

    emit(HabitLoading());

    try {
      await repository.addHabit(updatedHabit);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(updatedHabit.id.toString())
          .set(updatedHabit.toJson());

      await fetchHabits();
    } catch (e) {
      print('CUBIT YANILENMEDI GIVEUP');
      emit(HabitError(message: '$e'));
    }
  }

  Future<void> reorderHabits(int oldIndex, int newIndex) async {
  if (state is HabitLoaded) {
    final habits = List<HabitModel>.from((state as HabitLoaded).habits);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // 1. Listedeki yerini değiştir
    final item = habits.removeAt(oldIndex);
    habits.insert(newIndex, item);

    // 2. KRİTİK ADIM: Her bir habit'in position değerini yeni sırasına göre güncelle
    // i değeri 0, 1, 2... diye giderken habitlerin position'ı da öyle olur.
    for (int i = 0; i < habits.length; i++) {
      habits[i] = habits[i].copyWith(position: i);
    }

    // 3. UI'ı hemen güncelle (Gecikme olmasın)
    emit(HabitLoaded(habits: habits));

    try {
      // 4. Yerel Veritabanını (Isar) güncelle
      // syncHabitsWithLocal metoduna bu yeni listeyi gönderiyoruz
      await repository.syncHabitsWithLocal(habits);

      // 5. Firestore'u güncelle
      // Burada bir batch (toplu işlem) kullanmak çok daha hızlıdır
      final batch = _firestore.batch();
      
      for (var habit in habits) {
        final docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('habits')
            .doc(habit.id.toString());
            
        batch.set(docRef, habit.toJson());
      }
      
      await batch.commit(); // Tüm değişiklikleri tek seferde Firestore'a gönderir
      
      print('Sıralama başarıyla kaydedildi.');
    } catch (e) {
      print("Sıralama kaydedilirken hata oluştu: $e");
      // Hata olursa verileri tekrar çekerek listeyi eski haline döndür
      fetchHabits();
    }
  }
}
}
