import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WalkThrough3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Grant permissions to continue",
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
                color: Colors.red,
                fontSize: 25.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        Spacer(),
        Container(
          height: 0.5 * height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/permission.svg'),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "These permissions are required so that you don't miss anyone's birthday.",
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
