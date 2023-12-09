import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WalkThrough4 extends StatelessWidget {
  final Function onTap;
  WalkThrough4(this.onTap);
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
            "Grant DnD permission to continue",
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
                color: Colors.deepPurple,
                fontSize: 25.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        // Spacer(),
        Container(
          height: 0.5 * height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/sleep.svg'),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "This permission is required so we can notify you even when Do not disturb is enabled.",
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
            color: Colors.deepPurpleAccent[400],
            //    color: Colors.red,
            child: Text(
              "Give permission",
              style: GoogleFonts.openSans(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            onPressed: onTap,
          ),
        ),
      ],
    );
  }
}
