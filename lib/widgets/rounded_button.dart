import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isPrimary = true,
    this.isDisabled = false,
  });

  final Function()? onPressed;
  final String buttonText;
  final bool isPrimary;
  final bool isDisabled;

  static const primaryColor = Color(0xFF00a674);
  static const accentColor = Color(0xFF009995);
  static const disabledColor = Color(0xFFB3E5FC);
  static const whiteColor = Color(0xFFFFFFFF);
  static const grayTextColor = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:
              isDisabled
                  ? disabledColor
                  : isPrimary
                  ? primaryColor
                  : Colors.transparent,
          border:
              isPrimary || isDisabled
                  ? null
                  : Border.all(color: primaryColor, width: 2),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.cairo(
              textStyle: TextStyle(
                color:
                    isDisabled
                        ? grayTextColor
                        : isPrimary
                        ? whiteColor
                        : primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
