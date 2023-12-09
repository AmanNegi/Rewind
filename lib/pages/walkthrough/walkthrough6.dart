import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WalkThrough6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Now we are",
                style: GoogleFonts.ubuntu(
                    color: Colors.deepPurple,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "Good to GO!",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    color: Colors.deepPurple,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Spacer(),
        Container(
          height: 0.5 * height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/happy.svg'),
          ),
        ),
        Spacer()
      ],
    );
  }
}
