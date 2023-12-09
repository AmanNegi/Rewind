import 'dart:async';

import 'package:birthday_reminder/custom/startup_dialog.dart';
import 'package:birthday_reminder/data/shared_prefs.dart';
import 'package:birthday_reminder/main.dart';
import 'package:birthday_reminder/pages/walkthrough/walk_though1.dart';
import 'package:birthday_reminder/pages/walkthrough/walk_through2.dart';
import 'package:birthday_reminder/pages/walkthrough/walk_through3.dart';
import 'package:birthday_reminder/pages/walkthrough/walk_through4.dart';
import 'package:birthday_reminder/pages/walkthrough/walk_through5.dart';
import 'package:birthday_reminder/pages/walkthrough/walkthrough6.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

class WalkThrough extends StatefulWidget {
  @override
  _WalkThroughState createState() => _WalkThroughState();
}

EventChannel stream = EventChannel("birthdayReminder/permit/event.channel");

class _WalkThroughState extends State<WalkThrough> {
  var width, height;
  List<bool> boolList = [true, false, false, false, false, false];
  PageController controller = PageController(initialPage: 0);
  int currentPage = 0;
  StreamSubscription _timerSubscription;
  GlobalKey<ScaffoldState> globalKey = GlobalKey();

  bool isDndApplied = false;

  ScrollPhysics scrollPhysics;

  @override
  void initState() {
    scrollPhysics = BouncingScrollPhysics();
    super.initState();
    controller.addListener(() {
      if (controller.page == 3) {
        if (isDndApplied) {
          setState(() {
            scrollPhysics = BouncingScrollPhysics();
          });
        } else {
          setState(() {
            scrollPhysics = NeverScrollableScrollPhysics();
          });
        }
      } else {
        setState(() {
          scrollPhysics = BouncingScrollPhysics();
        });
      }
    });
    initiateStream();
  }

  @override
  void dispose() {
    cancelStream();
    super.dispose();
  }

  void initiateStream() {
    if (_timerSubscription == null) {
      if (!isDndApplied) {
        _timerSubscription =
            stream.receiveBroadcastStream().listen(receiveFromStream);
      }
    }
  }

  void receiveFromStream(dynamic value) async {
    Map<String, bool> a = value.cast<String, bool>();
    print("value received from stream from stream ; \n " + a.toString());

    isDndApplied = a['dnd'];

    if (isDndApplied) {
      setState(() {
        isDndApplied = true;
        scrollPhysics = BouncingScrollPhysics();
      });
      cancelStream();
      await sharedPrefsObject.initDataBase();
      sharedPrefsObject.setBoolFromSharedPrefs("isDnDApplied", isDndApplied);
    }
  }

  void cancelStream() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: globalKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.custom(
              physics: scrollPhysics,
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                  if (value == 0) {
                    boolList = [true, false, false, false, false, false];
                  } else if (value == 1) {
                    boolList = [true, true, false, false, false, false];
                  } else if (value == 2) {
                    boolList = [true, true, true, false, false, false];
                  } else if (value == 3) {
                    boolList = [true, true, true, true, false, false];
                  } else if (value == 4) {
                    boolList = [true, true, true, true, true, false];
                  } else if (value == 5) {
                    boolList = [true, true, true, true, true, true];
                  }
                });
              },
              scrollDirection: Axis.horizontal,
              childrenDelegate: SliverChildListDelegate(
                [
                  WalkThrough1(),
                  WalkThrough2(),
                  WalkThrough3(),
                  WalkThrough4(() {
                    if (isDndApplied) {
                      controller.animateToPage(currentPage + 1,
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeIn);
                    } else {
                      mainPlatform.invokeMethod("requestDnD");
                    }
                  }),
                  WalkThrough5(),
                  WalkThrough6()
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text(
                  currentPage > 1 ? "" : "Skip",
                  style: GoogleFonts.ubuntu(
                    color: Colors.red.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: currentPage != 3
                    ? () {
                        controller.animateToPage(3,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn);
                      }
                    : null,
              ),
              Spacer(),
              _buildDots(boolList[0]),
              _buildDots(boolList[1]),
              _buildDots(boolList[2]),
              _buildDots(boolList[3]),
              _buildDots(boolList[4]),
              _buildDots(boolList[5]),
              Spacer(),
              FlatButton(
                child: Text(
                  currentPage > 2 ? "Proceed" : "Next",
                  style: GoogleFonts.ubuntu(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  if (currentPage <= 2) {
                    controller.animateToPage(currentPage + 1,
                        duration: Duration(milliseconds: 150),
                        curve: Curves.easeIn);
                  }
                  if (currentPage == 3) {
                    if (isDndApplied) {
                      controller.animateToPage(currentPage + 1,
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeIn);
                    } else {
                      globalKey.currentState.showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text("Grant the permission to continue"),
                      ));
                    }
                  }
                  if (currentPage == 4) {
                    showDialog(
                        context: context,
                        builder: (context) => StartUpDialog()).then((value) {
                      controller.animateToPage(currentPage + 1,
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeIn);
                    });
                  }
                  if (currentPage == 5) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/MainPage", ModalRoute.withName("/"));
                    sharedPrefsObject.setBoolFromSharedPrefs(
                        "isFirstTime", false);
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildDots(bool value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? _getMainColor() : Colors.grey[300],
        ),
      ),
    );
  }

  Color _getMainColor() {
    return currentPage % 2 != 0 ? Colors.deepPurple : Colors.red;
  }
}
