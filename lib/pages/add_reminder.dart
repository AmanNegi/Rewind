import 'package:birthday_reminder/custom/curve_painter.dart';
import 'package:birthday_reminder/custom/hex_Color.dart';
import 'package:birthday_reminder/data/sql_database.dart';
import 'package:birthday_reminder/helper/add_helper.dart';
import 'package:birthday_reminder/model/birthday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';

class AddReminder extends StatefulWidget {
  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime dateTime = DateTime.now().add(Duration(days: 1));
  String name = "";
  String description = "";
  String date = "", time = "";
  var height, width;
  TextEditingController nameController, noteController;

  @override
  void initState() {
    nameController = TextEditingController();
    noteController = TextEditingController();

    _formatAndFillVars();

    super.initState();
  }

  DateTime getFinalYearDate() {
    DateTime currentDate = DateTime.now();
    DateTime finalYearDate =
        DateTime(currentDate.year + 1, 12, 30, 24, 0, 0, 0, 0);

    return finalYearDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "abc",
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: Colors.red,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            FloatingActionButton(
              heroTag: 'def',
              backgroundColor: Theme.of(context).cardColor,
              onPressed: () {
                _onSetReminderPress();
              },
              child: Icon(
                Mdi.check,
                color: HexColor("#ff5e62"),
              ),
            ),
          ],
        ),
        //  resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        body: Container(
          height: height,
          child: CustomPaint(
            painter: CurvePainter(20, false),
            child: _buildListView(),
          ),
        ),
      ),
    );
  }

  _buildListView() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 0.005 * height),
          height: 0.1 * height,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Set a reminder",
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
        _buildTopCard(),
        _buildSelectors(),
      ],
    );
  }

  _buildSelectors() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10.0,
                    color: Colors.black12.withOpacity(0.05),
                    offset: Offset(0.0, 2.0),
                    spreadRadius: 10.0)
              ],
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Date",
                            style: GoogleFonts.openSans(),
                          ),
                          IconButton(
                            onPressed: () async {},
                            icon: Icon(Mdi.calendarEdit),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                        child: Material(
                      color: Colors.transparent,
                      child: Builder(
                        builder: (context) {
                          return InkWell(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0)),
                            onTap: () async {
                              DateTime date = await showDatePicker(
                                context: context,
                                initialDate: dateTime,
                                firstDate:
                                    DateTime.now().add(Duration(days: 1)),
                                lastDate: getFinalYearDate(),
                              );
                              if (date != null) {
                                _onPressedConfirmDate(date);
                              }
                            },
                          );
                        },
                      ),
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: Container(
                    height: 1,
                    color: Colors.grey[400],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5.0, left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Time",
                            style: GoogleFonts.openSans(),
                          ),
                          IconButton(
                            onPressed: () async {},
                            icon: Icon(Mdi.circleEditOutline),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                        child: Material(
                      color: Colors.transparent,
                      child: Builder(
                        builder: (context) {
                          return InkWell(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0)),
                            onTap: () async {
                              TimeOfDay day = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(dateTime),
                              );
                              if (day != null) {
                                _onPressedConfirmTime(
                                    convertTimeOfDayToDateTime(day, dateTime));
                              }
                            },
                          );
                        },
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTopCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: HexColor("#ff5e62"),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))),
            height: 0.3 * height,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 20.0, right: 15.0),
              child: Column(
                children: <Widget>[
                  _buildNameTextField(),
                  Spacer(),
                  _buildDescriptionTextField(),
                  Spacer(),
                ],
              ),
            ),
          ),
          Container(
            height: 0.1 * height,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
                color: HexColor("#ff5e62"),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black12,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 10.0)
                ]),
            child: _buildDateTimeText(),
          ),
        ],
      ),
    );
  }

  _buildDateTimeText() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            time,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: GoogleFonts.alata().fontFamily,
                fontWeight: FontWeight.w800),
          ),
          Text(
            date,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: GoogleFonts.alata().fontFamily,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  _buildDescriptionTextField() {
    return TextField(
      controller: noteController,
      maxLines: 4,
      style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: GoogleFonts.alata().fontFamily,
          fontWeight: FontWeight.w800),
      decoration: InputDecoration(
          hintText: "Enter short message here",
          hintStyle: TextStyle(
              color: Colors.white54,
              fontSize: 20,
              fontFamily: GoogleFonts.alata().fontFamily,
              fontWeight: FontWeight.w800),
          border: InputBorder.none),
    );
  }

  _buildNameTextField() {
    return TextField(
      controller: nameController,
      style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily: GoogleFonts.alata().fontFamily,
          fontWeight: FontWeight.w800),
      decoration: InputDecoration(
          hintText: "Enter name here",
          hintStyle: TextStyle(
              color: Colors.white54,
              fontSize: 25,
              fontFamily: GoogleFonts.alata().fontFamily,
              fontWeight: FontWeight.w800),
          border: InputBorder.none),
    );
  }

  _onSetReminderPress() async {
    if (nameController.text.length <= 0 || noteController.text.length <= 0) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Fill the fields to continue"),
          duration: Duration(milliseconds: 500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
        ),
      );
      return;
    } else if (nameController.text.length > 15 &&
        noteController.text.length > 25) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Enter a short name and description"),
          duration: Duration(milliseconds: 500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
        ),
      );
      return;
    } else if (nameController.text.length > 15) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Enter a name within 15 characters to proceed"),
          duration: Duration(milliseconds: 500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
        ),
      );
      return;
    } else if (noteController.text.length > 25) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Enter a description within 25 characters to proceed"),
          duration: Duration(milliseconds: 500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
        ),
      );
      return;
    }
    dataBase.insertBirthDay(BirthDay(
      aMessageForPerson: noteController.text,
      dateOfBirthday: dateTime,
      nameOfPerson: nameController.text,
      uniqueId: 123,
    ));

    Navigator.pop(context);
  }

  _onPressedConfirmTime(DateTime time) {
    setState(() {
      dateTime = DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
    });
    _formatAndFillVars();
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Updated Time"),
      duration: Duration(milliseconds: 500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
    ));
  }

  _onPressedConfirmDate(DateTime date) {
    setState(() {
      dateTime = DateTime(
          date.year, date.month, date.day, dateTime.hour, dateTime.minute);
    });
    _formatAndFillVars();
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Updated Date"),
      duration: Duration(milliseconds: 500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
    ));
  }

  _formatAndFillVars() {
    DateFormat dateFormat = DateFormat("MMMM dd y");
    DateFormat timeFormat = DateFormat("jm");

    if (mounted) {
      setState(() {
        date = dateFormat.format(dateTime);
        time = timeFormat.format(dateTime);
      });
    } else {
      date = dateFormat.format(dateTime);
      time = timeFormat.format(dateTime);
    }
  }
}
