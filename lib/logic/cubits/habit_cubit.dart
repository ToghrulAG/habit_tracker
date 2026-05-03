import 'package:badhabit_tracker/logic/cubits/habit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/habit_model.dart';
import '../../data/repositories/habit_repository.dart';

class HabitCubit extends Cubit<HabitState> {
  final HabitRepository repository;

  HabitCubit(this.repository) : super(HabitInitial());

  Future<void> fetchHabits() async {
    emit(HabitLoading());
    try {
      final habits = await repository.getAllHabits();
      print('FETCH HABITS ISLEDI (CUBIT), STATEYI YENILEYIREM ');

      emit(HabitLoaded(habits: habits));
    } catch (e) {
      emit(HabitError(message: 'FETCH HABITS ERRORUMUZ VAR (CUBIT)'));
      throw Exception('$e');
    }
  }

  Future<void> newHabit(HabitModel newHabit) async {
    emit(HabitLoading());
    try {
      final initialRecord = DateTime.now().difference(newHabit.startDate).inDays;

      final habitWithRecord = newHabit.copyWith(
        record: initialRecord
      );
      await repository.addHabit(habitWithRecord);
      await fetchHabits();
      print('NEWHABIT ISLEDI (CUBIT), STATEYI YENILEYIREM ');
    } catch (e) {
      emit(
        HabitError(message: 'YENI HABIT ELAVE ETMEK MUMKUN OLMADI (CUBIT) $e'),
      );
      throw Exception('YENI HABIT ELAVE OLUNMADI (CUBIT)');
    }
  }

  Future<void> removeHabit(int habitId) async {
    emit(HabitLoading());
    try {
      await repository.deleteHabit(habitId);
      await fetchHabits();
    } catch (e) {
      emit(HabitError(message: 'Yeni habit elave olunmadi $e'));
      throw Exception('$habitId li habit silinmedi (CUBIT)');
    }
  }

  Future<void> giveUp(HabitModel habit) async {

    final recordCheck = DateTime.now().difference(habit.startDate).inDays;
    final updatedRecord = recordCheck > (habit.record ?? 0) ? recordCheck : habit.record;

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
      await fetchHabits();
    } catch (e) {
      print('CUBIT YANILENMEDI GIVEUP');
      emit(HabitError(message: '$e'));
    }
  }
}
