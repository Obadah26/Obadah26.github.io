import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuButtons extends StatelessWidget {
  const MenuButtons({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.iconColor,
  });
  final IconData icon;
  final String text;
  final Function() onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF81C784), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            color: Colors.white,
            icon: Icon(icon, size: 50, color: iconColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  text,
                  style: GoogleFonts.cairo(
                    textStyle: kBodySmallText.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
