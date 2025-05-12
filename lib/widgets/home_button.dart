import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });
  final IconData icon;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 50, color: kLightPrimaryColor),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: GoogleFonts.cairo(
                textStyle: kBodySmallText.copyWith(
                  color: kLightPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
