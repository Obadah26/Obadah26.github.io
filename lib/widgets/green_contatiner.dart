import 'package:alhadiqa/const.dart';
import 'package:flutter/material.dart';

class GreenContatiner extends StatelessWidget {
  const GreenContatiner({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.color = Colors.white,
    this.borderColor = kLightPrimaryColor,
  });

  final Widget child;
  final double? width;
  final Color? color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(128, 128, 128, 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: child,
    );
  }
}
