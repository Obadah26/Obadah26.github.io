import 'package:flutter/material.dart';

class CircleIntersectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Color(0xffd4f3e8);
    final paint2 = Paint()..color = Color(0xffd4f3e8);
    final intersectionPaint = Paint()..color = Color(0xffa8e6d1);

    // Define circle paths
    final circle1 =
        Path()..addOval(Rect.fromCircle(center: Offset(190, -10), radius: 240));

    final circle2 =
        Path()..addOval(Rect.fromCircle(center: Offset(350, 75), radius: 150));

    // Draw original circles
    canvas.drawPath(circle1, paint1);
    canvas.drawPath(circle2, paint2);

    // Draw intersection
    final intersection = Path.combine(
      PathOperation.intersect,
      circle1,
      circle2,
    );
    canvas.drawPath(intersection, intersectionPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
