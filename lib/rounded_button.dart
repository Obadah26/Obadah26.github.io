import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.route,
    required this.buttonText,
    required this.baseColor,
    required this.reflectionColor,
  });

  final String route;
  final String buttonText;
  final Color reflectionColor;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              reflectionColor, // Light reflection (top)
              baseColor, // Your base teal color
            ],
            stops: [0.0, 0.7],
          ),
        ),
        child: Center(child: Text(buttonText, style: kText)),
      ),
    );
  }
}
