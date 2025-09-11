extension CompareDates on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  bool isNextDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day - 1;
  }
  bool isBeforeDay(DateTime other) {
    return DateTime(year, month, day)
        .isBefore(DateTime(other.year, other.month, other.day));
  }

  bool isAfterDay(DateTime other) {
    return DateTime(year, month, day)
        .isAfter(DateTime(other.year, other.month, other.day));
  }

  List<DateTime> getAllDatesInMonth() {
    final List<DateTime> dates = [];

    // Get the first day of the month
    DateTime currentDate = DateTime(year, month, 1);

    // Add the first day
    dates.add(currentDate);

    // Add the remaining days until the next month is reached
    while (currentDate.month == month) {
      currentDate = currentDate.add(const Duration(days: 1));
      dates.add(currentDate);
    }
    dates.removeLast();

    return dates.reversed.toList();
  }
}
