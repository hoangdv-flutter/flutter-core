extension DateTimeExt on DateTime {
  bool areTheSameDayWith(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
