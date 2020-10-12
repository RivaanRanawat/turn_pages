class TimeLeft {
  String timeLeft(DateTime dueTime) {
    String retVal;

    Duration _timeUntilDue = dueTime.difference(DateTime.now());

    // FORMULAS idk how i got
    int _daysUntilDue = _timeUntilDue.inDays;
    int _hoursUntilDue = _timeUntilDue.inHours - (_daysUntilDue * 24);
    int _minUntilDue = _timeUntilDue.inMinutes - (_daysUntilDue * 24 * 60) - (_hoursUntilDue * 60);

    if (_daysUntilDue > 0) {
      retVal = _daysUntilDue.toString() +
          " days, " +
          _hoursUntilDue.toString() +
          " hours, " +
          _minUntilDue.toString() +
          " mins";
    } else if (_hoursUntilDue > 0) {
      retVal = _hoursUntilDue.toString() + " hours, " + _minUntilDue.toString() + " mins";
    } else if (_minUntilDue > 0) {
      retVal = _minUntilDue.toString() + " mins";
    } else if (_minUntilDue == 0) {
      retVal = "Due Time Over";
    } else {
      retVal = "Error";
    }

    return retVal;
  }
}
