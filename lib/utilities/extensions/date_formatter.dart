extension DateFormatter on DateTime {
  /// yyyy-MM-dd
  String toYearMonthDayFormatte() {
    return "${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }

  /// yyyy-MM-dd HH:mm:ss
  String toYearMonthDayHourMinuteSecondFormatte() {
    return "${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
  }
}
