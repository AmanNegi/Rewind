import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WalkThrough1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Welcome in your app",
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
                color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.w600),
          ),
        ),
        Spacer(),
        Container(
          height: 0.5 * height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/friends.svg'),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "For those, who never forget people who are close to them.",
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
