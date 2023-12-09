import 'package:flutter/material.dart';

convertTimeOfDayToDateTime(TimeOfDay timeOfDay, DateTime date) {
  return DateTime(
      date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
}
