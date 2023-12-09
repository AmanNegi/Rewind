import 'package:birthday_reminder/app_theme.dart';
import 'package:birthday_reminder/custom/curve_painter.dart';
import 'package:birthday_reminder/custom/drawer_builder.dart';
import 'package:birthday_reminder/custom/foreground_painter.dart';
import 'package:birthday_reminder/custom/hex_Color.dart';
import 'package:birthday_reminder/data/shared_prefs.dart';
import 'package:birthday_reminder/main.dart';
import 'package:birthday_reminder/model/birthday_model.dart';
import 'package:birthday_reminder/pages/add_reminder.dart';
import 'package:birthday_reminder/repository/birthday_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';
import '../custom/dialog_builder.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool showDemo = true;
  bool showTopText = true;
  ScrollController scrollController;
  double offset = 0.0;

  var height, width;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          print("home_page in resumed");
          localAppState.initList();
          break;
        }
      case AppLifecycleState.inactive:
        print("home_page in inactive");
        break;
      case AppLifecycleState.paused:
        print("home_page in paused");
        break;
      case AppLifecycleState.detached:
        print("home_page in detached");
        break;
    }
  }

  @override
  void dispose() {
    print("In dispose()");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  checkIfShowDemo() async {
    await sharedPrefsObject.initDataBase();
    if (mounted) {
      setState(() {
        showDemo = !sharedPrefsObject.checkIfExists("showDemo");
      });
    } else {
      showDemo = !sharedPrefsObject.checkIfExists("showDemo");
    }
  }

  @override
  void initState() {
    checkIfShowDemo();
    scrollController = ScrollController();

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.initialScrollOffset) {
        setState(() {
          offset = scrollController.offset;
          showTopText = true;
        });
        return;
      }
      if (offset <= 10) {
        setState(() {
          showTopText = true;
          offset = scrollController.offset;
        });
      } else {
        if (showTopText == false && offset == scrollController.offset) {
          //*  DO NOTHING
        } else {
          setState(() {
            showTopText = false;
            offset = scrollController.offset;
          });
        }
      }
    });
    //TODO: Check is DnD applied
    sharedPrefsObject.initDataBase().then((value) {
      if (!sharedPrefsObject.checkIfExists("isDnDApplied")) {
        mainPlatform.invokeMethod("requestDnD");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: HexColor("#232526"),
        statusBarColor: HexColor("#434343")));

    return Scaffold(
      endDrawer: DrawerBuilder(),
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/AddReminder");
        },
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: height,
            child: ValueListenableBuilder(
              valueListenable: appTheme,
              builder: (context, value, child) {
                return CustomPaint(
                  painter: CurvePainter(offset, value),
                  foregroundPainter: ForegroundPainter(),
                  child: child,
                );
              },
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 2),
                    height: 0.10 * height,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: AnimatedOpacity(
                          opacity: showTopText ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 100),
                          child: Text(
                            "All Reminders",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              fontFamily: GoogleFonts.openSans().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildList(),
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: kToolbarHeight - 20,
            child: IconButton(
              icon: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Icon(
                  Mdi.sortVariant,
                  color: Colors.white,
                ),
              ),
              onPressed: () => scaffoldKey.currentState.openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }

  _buildList() {
    return ValueListenableBuilder(
      valueListenable: localAppState.mainList,
      builder: (context, List<BirthDay> value, child) {
        checkIfShowDemo();
        List<Widget> widgetList = List();
        for (int i = 0; i < value.length; i++) {
          widgetList.add(_buildColumnItem(
              index: i,
              dateTime: value[i].dateOfBirthday,
              description: value[i].aMessageForPerson,
              name: value[i].nameOfPerson,
              uniqueId: value[i].uniqueId));
        }
        return Container(
          margin: EdgeInsets.only(bottom: 0.2 * height),
          child: widgetList.length <= 0 && showDemo
              ? _buildFakeColumn()
              : Column(
                  children: widgetList,
                ),
        );
      },
    );
  }

  _buildFakeColumn() {
    return Column(
      children: <Widget>[
        _buildFakeItem(),
        _buildFakeItem(),
        _buildFakeItem(),
        _buildFakeItem(),
        _buildFakeItem(),
        _buildFakeItem(),
      ],
    );
  }

  _buildFakeItem() {
    String color = "#bdc3c7";
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReminder(),
            )),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor(color),
                ),
                //     height: 35,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
                      child: Text(
                        "DEMO ITEM",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: GoogleFonts.ubuntu().fontFamily,
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
              child: Container(
                color: HexColor(color),
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26.withOpacity(0.1),
                          Colors.transparent,
                          Colors.transparent
                        ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "XXXXXXXXXXXXXX",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: GoogleFonts.raleway().fontFamily,
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Container(
                          width: 1,
                          height: 0.05 * height,
                          color: Colors.white54,
                        ),
                      ),
                      Expanded(
                        //  width: 0.3 * width,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "XX-XX-XX",
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.openSans().fontFamily,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "XXXX",
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.openSans().fontFamily,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildColumnItem(
      {String name,
      String description,
      DateTime dateTime,
      int index,
      int uniqueId}) {
    String color = index % 2 == 0 ? "#26D0CE" : "#FF4E50";
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DialogBuilder(
              color: color,
              dateTime: dateTime,
              description: description,
              name: name,
              uniqueId: uniqueId,
            ),
          );
        },
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor(color),
                ),
                //     height: 35,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
                      child: Hero(
                        tag: name + uniqueId.toString(),
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: GoogleFonts.ubuntu().fontFamily,
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
              child: Container(
                color: HexColor(color),
                //     height: 65,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26.withOpacity(0.1),
                          Colors.transparent,
                          Colors.transparent
                        ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        //    width: 0.5 * width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: GoogleFonts.raleway().fontFamily,
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Container(
                          width: 1,
                          height: 0.06 * height,
                          color: Colors.white54,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        //    width: 0.3 * width,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  DateFormat("jm").format(
                                    dateTime,
                                  ),
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.ubuntu().fontFamily,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  DateFormat("d MMM yy").format(
                                    dateTime,
                                  ),
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.ubuntu().fontFamily,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
