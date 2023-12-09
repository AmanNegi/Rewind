import 'package:birthday_reminder/app_theme.dart';
import 'package:birthday_reminder/data/shared_prefs.dart';
import 'package:birthday_reminder/data/sql_database.dart';
import 'package:birthday_reminder/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom/hex_Color.dart';

const restartPlatform =
    const MethodChannel('birthdayReminder.app.restartReceiver');

const mainPlatform =
    const MethodChannel('birthdayReminder.app.mainMethodChannel');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  restartPlatform.setMethodCallHandler(myUtilsHandler);
  await sharedPrefsObject.initDataBase();
  toggleDarkTheme(getFromSharedPrefs());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ValueListenableBuilder(
      valueListenable: appTheme,
      builder: (context, value, child) {
        return MaterialApp(
          title: "Rewind",
          debugShowCheckedModeBanner: false,
          initialRoute: sharedPrefsObject.checkIfExists("isFirstTime")
              ? "/MainPage"
              : '/WalkThrough',
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: ThemeData(
              snackBarTheme: SnackBarThemeData(
                backgroundColor: !value ? Colors.white : Colors.grey[800],
                contentTextStyle: TextStyle(
                    color: value ? Colors.white : Colors.black,
                    fontFamily: GoogleFonts.ubuntu().fontFamily),
              ),
              brightness: value ? Brightness.dark : Brightness.light,
              fontFamily: GoogleFonts.ubuntu().fontFamily,
              textTheme: TextTheme()
                  .apply(bodyColor: Colors.white, displayColor: Colors.white),
              primarySwatch: Colors.deepOrange,
              accentColor: HexColor("#ff5e62")),
        );
      },
    );
  }
}

// ! Handling calls from native side
Future<dynamic> myUtilsHandler(MethodCall methodCall) async {
  switch (methodCall.method) {
    case 'getData':
      {
        print("in get Data Utils Handler [BirthdayReminder] ");
        await dataBase.initDatabase();
        print("init database complete");
        List data = await dataBase.getDataForRestartingTimers();
        print("Got data from data base length ${data.length}");

        return data;
      }
    case 'deleteData':
      {
        print("in delete Utils Handler [BirthdayReminder] ");

        await dataBase.initDatabase();
        print("init database complete");

        var result = await dataBase.deleteBirthDay(methodCall.arguments);
        print("deletion complete $result");
        return null;
      }
    default:
      throw MissingPluginException('notImplemented');
  }
}
