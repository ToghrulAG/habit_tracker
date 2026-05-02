import 'package:isar/isar.dart';
part 'habit_model.g.dart';

@collection
class HabitModel {
  Id id = Isar.autoIncrement;

  final String title;
  final String userId;
  final int color;
  final DateTime startDate;
  final String icon;
  final int attempt;
  List<DateTime> failDates;
  final int? record;

  @ignore
  int get daysCount => DateTime.now().difference(startDate).inDays;
  @ignore
  Duration get timePassed => DateTime.now().difference(startDate);

  HabitModel({
    this.record,
    required this.title,
    this.attempt = 1,
    required this.userId,
    required this.color,
    required this.startDate,
    required this.icon,
    this.failDates = const [],
    this.id = Isar.autoIncrement,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      title: json['title'],
      attempt: json['attempt'],
      userId: json['user_id'],
      color: json['color'],
      startDate: DateTime.parse(json['start_date']),
      icon: json['icon'],
      id: json['id'],
      record: json['record'],
      failDates:
          (json['fail_dates'] as List?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'user_id': userId,
      'color': color,
      'attempt': attempt,
      'start_date': startDate.toIso8601String(),
      'icon': icon,
      'fail_dates': failDates.map((e) => e.toIso8601String()).toList(),
      'id': id,
      'record' : record
    };
  }

  HabitModel copyWith({
    String? title,
    int? color,
    DateTime? startDate,
    String? icon,
    String? userId,
    List<DateTime>? failDates,
    int? attempt,
    int? record,
  }) {
    return HabitModel(
      id: id,
      title: title ?? this.title,
      userId: this.userId,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      icon: icon ?? this.icon,
      failDates: failDates ?? this.failDates,
      attempt: attempt ?? this.attempt,
      record: record ?? this.record
    );
  }
}
