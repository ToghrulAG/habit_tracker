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
    emit(HabitLoading());

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
      // 1. Kayıt (record) hesaplamasını yapıyoruz
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

 
}
