import 'package:birthday_reminder/custom/hex_Color.dart';
import 'package:birthday_reminder/data/sql_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';

class DialogBuilder extends StatelessWidget {
  final String name;
  final String description;
  final DateTime dateTime;
  final String color;
  final int uniqueId;
  DialogBuilder({
    this.dateTime,
    this.description,
    this.name,
    this.color,
    this.uniqueId,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SimpleDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: 0.8 * width,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: HexColor(color),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                    ),
                    height: 0.3 * height,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Hero(
                            tag: name + uniqueId.toString(),
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: GoogleFonts.alata().fontFamily,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Spacer(),
                          Text(
                            description,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: GoogleFonts.alata().fontFamily,
                                fontWeight: FontWeight.w800),
                          ),
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
                        color: HexColor(color),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.0,
                              color: Colors.black12,
                              offset: Offset(0.0, -2.0),
                              spreadRadius: 2.0)
                        ]),
                    child: _buildDateTimeText(dateTime, context),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5.0,
              right: 5.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _buildDateTimeText(DateTime dateTime, BuildContext context) {
    DateFormat dateFormat = DateFormat("MMMM dd y");
    DateFormat timeFormat = DateFormat("jm");

    var time = timeFormat.format(dateTime);
    var date = dateFormat.format(dateTime);
    return Row(
      children: <Widget>[
        Padding(
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
        ),
        Spacer(),
        GestureDetector(
          onTap: () async {
            await dataBase.initDatabase();
            dataBase.deletePermanently(uniqueId);
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
