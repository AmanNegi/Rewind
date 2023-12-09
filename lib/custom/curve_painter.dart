import 'package:birthday_reminder/custom/hex_Color.dart';
import "package:flutter/material.dart";
import 'dart:ui' as ui;

class CurvePainter extends CustomPainter {
  double value;
  bool darkMode;
  CurvePainter(this.value, this.darkMode);

  @override
  void paint(Canvas canvas, Size size) {
    var x = size.width;
    var y = size.height + (value * 6.4);

    Paint paint = new Paint()
      ..color = /* darkMode ? HexColor("#485563") : */ HexColor("#434343")
      //   ..color = Colors.white
      //   ..maskFilter = MaskFilter.blur(BlurStyle.outer, value);

      ..maskFilter = darkMode
          ? MaskFilter.blur(BlurStyle.inner, value)
          : MaskFilter.blur(BlurStyle.solid, value);

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, y * 0.225)
      ..quadraticBezierTo(0.5 * x, 0.135 * y, x, 0.145 * y)
      ..lineTo(x, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
