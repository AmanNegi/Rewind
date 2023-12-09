import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WalkThrough2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Get notified of your friend's birthday",
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
                color: Colors.deepPurple,
                fontSize: 25.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        Spacer(),
        Container(
          height: 0.5 * height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/notification.svg'),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Set a reminder and get notified.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.black45,
                fontSize: 20.0,
                fontWeight: FontWeight.w400),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
