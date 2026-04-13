import 'package:badhabit_tracker/data/models/habit_model.dart';
import 'package:equatable/equatable.dart';

abstract class HabitState extends Equatable {}

class HabitInitial extends HabitState {
  @override
  List<Object?> get props => [];
}

class HabitLoading extends HabitState {
  @override
  List<Object?> get props => [];
}

class HabitLoaded extends HabitState {
  final List<HabitModel> habits;

  HabitLoaded({required this.habits});

  @override
  List<Object?> get props => [habits];
}

class HabitError extends HabitState {
  final String message;

  HabitError({required this.message});

  @override
  List<Object?> get props => [message];
}
