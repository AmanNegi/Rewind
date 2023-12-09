import 'package:birthday_reminder/custom/hex_Color.dart';
import "package:flutter/material.dart";

class ForegroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var x = size.width;
    var y = size.height;

    Paint paint = new Paint()..color = HexColor("#232526");
    Paint paint2 = new Paint()
      ..color =  HexColor("#434343");

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, y)
      ..quadraticBezierTo(x * 0.5, y, x, y * 0.85)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..close();

    Path path2 = Path()
      ..moveTo(0, 0)
      /* ..moveTo(x * 0.925, 0)
      ..quadraticBezierTo(x * 0.8, y * 0.05, x, y * 0.075) */
      ..moveTo(x, y * 0)
      ..quadraticBezierTo(x * 0.725, y * 0.05, x, y * 0.15)
      ..lineTo(x, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
