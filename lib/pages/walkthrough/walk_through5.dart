import 'package:birthday_reminder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WalkThrough5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Grant AutoStartUp to continue",
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
                color: Colors.red, fontSize: 25.0, fontWeight: FontWeight.w700),
          ),
        ),
        Spacer(),
        Container(
          height: 0.5 * height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/autostart.svg'),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "This permission is required to reschedule the alarms when device is restarted.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.black45,
                fontSize: 20.0,
                fontWeight: FontWeight.w400),
          ),
        ),
        Spacer(),
        ButtonTheme(
          minWidth: 0.7 * width,
          height: 0.065 * height,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            //color: Colors.deepPurpleAccent[400],
            color: Colors.red,
            child: Text(
              "Give permission",
              style: GoogleFonts.ubuntu(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              mainPlatform.invokeMethod("requestAutoStartUp");
            },
          ),
        ),
      ],
    );
  }
}
