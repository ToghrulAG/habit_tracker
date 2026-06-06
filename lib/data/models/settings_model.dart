import 'package:isar/isar.dart';
part 'settings_model.g.dart';

@collection
class SettingsModel {
  Id id = 1;

  final bool? isDarkMode;
  final bool? isNotificationEnabled;

  SettingsModel({this.isDarkMode, this.isNotificationEnabled});
}
