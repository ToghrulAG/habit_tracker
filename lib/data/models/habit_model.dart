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

  HabitModel({
    required this.title,
    required this.userId,
    required this.color,
    required this.startDate,
    required this.icon
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      title: json['title'],
      userId: json['user_id'],
      color: json['color'],
      startDate: DateTime.parse(json['start_date']),
      icon : json['icon']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'user_id': userId,
      'color': color,
      'start_date': startDate.toIso8601String(),
      'icon' : icon
    };
  }
}
