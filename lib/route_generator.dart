import 'package:birthday_reminder/pages/birthday_page.dart';
import 'package:birthday_reminder/pages/add_reminder.dart';
import 'package:birthday_reminder/pages/home_page.dart';
import 'package:birthday_reminder/pages/walk_through.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/MainPage':
        return MaterialPageRoute(builder: (context) => HomePage());
      case '/AddReminder':
        return MaterialPageRoute(
          builder: (context) => AddReminder(),
        );
      case '/BirthdayPage':
        return MaterialPageRoute(
          builder: (context) => BirthDayPage(),
        );
      case '/WalkThrough':
        return MaterialPageRoute(
          builder: (context) => WalkThrough(),
        );

      default:
      return MaterialPageRoute(
        builder: (context) => WalkThrough(),
      );
      //? in case no route has been specified [for safety]
    }
  }
}
