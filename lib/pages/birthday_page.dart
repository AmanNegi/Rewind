import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:birthday_reminder/custom/hex_Color.dart';
import 'package:birthday_reminder/data/sql_database.dart';
import 'package:birthday_reminder/model/birthday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthDayPage extends StatefulWidget {
  @override
  _BirthDayPageState createState() => _BirthDayPageState();
}

// ! Event channels needed in this page
class _BirthDayPageState extends State<BirthDayPage>
    with WidgetsBindingObserver {
  static const stream = const EventChannel('eventChannel/birthday');
  var width, height;
  StreamSubscription _timerSubscription;
  String name = " ", description = "Default description";
  int uniqueId = 0, timeInMillis = 0;
  bool hasVisitedResume = false;
  bool showSetReminderButton = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          showSetReminderButton = false;

          print("birthday-page in resumed");
          break;
        }
      case AppLifecycleState.inactive:
        print("birthday-page in inactive");
        break;
      case AppLifecycleState.paused:
        print("birthday-page in paused");
        break;
      case AppLifecycleState.detached:
        print("birthday-page in detached");
        break;
    }
  }

  void startListeningForChanges() {
    if (_timerSubscription == null) {
      _timerSubscription = stream.receiveBroadcastStream().listen(updateValues);
    }
  }

  void stopListeningToChanges() {
    print("\n----Stopping listeners----\n");
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void updateValues(dynamic map) {
    Map finalMap = LinkedHashMap.from(map);
    if (mounted) {
      setState(() {
        name = finalMap['name'];
        description = finalMap['description'];
        uniqueId = int.parse(finalMap['uniqueId']);
        timeInMillis = int.parse(finalMap['timeInMillis']);
      });
    } else {
      name = finalMap['name'];
      description = finalMap['description'];
      uniqueId = int.parse(finalMap['uniqueId']);
      timeInMillis = int.parse(finalMap['timeInMillis']);
    }
    print("values received");
    print(finalMap.toString());
    //! Stopping as it consumes a lot of resource
    stopListeningToChanges();
  }

  @override
  void initState() {
    print("In init state adding observer [birthday_page.dart]");
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("\n------- Add Post Frame CallBack ------------\n");
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
            height: 0.6 * height,
            width: width,
            child: Center(child: SvgPicture.asset("assets/birthday.svg")),
          ),
          _buildRichText(),
          Spacer(),
          Container(
            height: 0.32 * height,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [HexColor("#8E2DE2"), HexColor("#4A00E0")],
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, top: 10.0),
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                                  fontSize: 45),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, top: 10.0),
                            child: Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                                  fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: showSetReminderButton ? 0.0 : 1.0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        //  color: Colors.grey,
                        gradient: LinearGradient(
                          colors: [
                            HexColor("#8E2DE2"),
                            HexColor("#4A00E0"),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(
                        child: Text(
                          "Check out whose!!",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: GoogleFonts.ubuntu().fontFamily,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  showSetReminderButton
                      ? Container()
                      : Positioned.fill(
                          child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30.0),
                            onTap: () async {
                              startListeningForChanges();
                              setState(() {
                                showSetReminderButton = true;
                              });
                            },
                          ),
                        )),
                  showSetReminderButton
                      ? Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: _buildGradientButton(),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          // Spacer(),
        ],
      ),
    );
  }

  _buildGradientButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: _onTapRaisedButton,
        child: Container(
          width: 0.7 * width,
          height: 0.07 * height,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  blurRadius: 1.0,
                  offset: Offset(0.0, 0.0),
                  spreadRadius: 1.0)
            ],
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: [HexColor("#8E2DE2"), HexColor("#4A00E0")],
            ),
          ),
          child: Center(
            child: Text(
              "Set reminder for next year",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.ubuntu().fontFamily),
            ),
          ),
        ),
      ),
    );
  }

  _onTapRaisedButton() async {
    if (timeInMillis <= 0) {
      Navigator.pop(context);

      return;
    }
    print(DateTime.fromMillisecondsSinceEpoch(timeInMillis));
    BirthDay birthDay = new BirthDay(
        aMessageForPerson: description,
        dateOfBirthday: _getDateOfBirthdayAfterOneYear(
            DateTime.fromMillisecondsSinceEpoch(timeInMillis)),
        nameOfPerson: name,
        uniqueId: uniqueId);
    MethodChannel methodChannel =
        new MethodChannel("birthdayReminder/birthday.MethodChannel");
    methodChannel
        .invokeMethod("remindNextYear", {'map': json.encode(birthDay.toMap())});
    await dataBase.initDatabase();
    await dataBase.addBirthdayFromIndex(birthDay);

    SystemNavigator.pop();
  }

  _getDateOfBirthdayAfterOneYear(DateTime oldDate) {
    DateTime now = DateTime.now();
    //TODO: Make Changes here
    return DateTime(now.year + 1, oldDate.month, oldDate.day, oldDate.hour,
        oldDate.minute, 0, 0, 0);
  }

  _buildRichText() {
    return Container(
      width: 0.85 * width,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                color: Theme.of(context).iconTheme.color,
                fontSize: 22),
            children: [
              TextSpan(text: "Hey today's someone's birthday "),
            ]),
      ),
    );
  }
}
