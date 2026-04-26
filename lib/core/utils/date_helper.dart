class DateHelper {
  static int getdaysCount(DateTime startDate) {
    return DateTime.now().difference(startDate).inDays;
  }

  static Map<String, String> getDetailedTime(DateTime startDate) {
    final diff = DateTime.now().difference(startDate);

    return {
      'days': (diff.inDays).toString(),
      'hours': (diff.inHours % 24).toString(),
      'minutes': (diff.inMinutes % 60).toString(),
      'seconds': (diff.inSeconds % 60).toString(),
    };
  }
}
