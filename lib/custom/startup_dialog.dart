import 'package:birthday_reminder/custom/hex_Color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartUpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SimpleDialog(
      backgroundColor: Colors.transparent,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: <Widget>[
                Container(
                  height: 0.05 * height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [HexColor("#f12711"), HexColor("#f5af19")],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Note",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.ubuntu().fontFamily,
                          fontSize: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Text(
                      "The autoStart-Up is an important permission for the proper functioning of the reminders. Make sure you grant it before proceeding.",
                      style: GoogleFonts.poppins(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
