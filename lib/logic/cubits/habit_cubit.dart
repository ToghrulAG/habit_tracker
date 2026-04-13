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
      throw Exception('FETCH HABITS ERRORUMUZ VAR (CUBIT) $e');
    }
  }

  Future<void> newHabit(HabitModel newHabit) async {
    emit(HabitLoading());
    try {
      await repository.addHabit(newHabit);
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
}
