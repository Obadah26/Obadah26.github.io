import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.route,
    required this.buttonText,
    this.isPrimary = true,
    this.isDisabled = false,
  });

  final String route;
  final String buttonText;
  final bool isPrimary;
  final bool isDisabled;

  static const primaryColor = Color(0xFF03A9F4);
  static const accentColor = Color(0xFFFFEB3B);
  static const disabledColor = Color(0xFFB3E5FC);
  static const whiteColor = Color(0xFFFFFFFF);
  static const grayTextColor = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:
          isDisabled
              ? null
              : () => Navigator.pushNamedAndRemoveUntil(
                context,
                route,
                (Route<dynamic> route) =>
                    route.settings.name == WelcomeScreen.id,
              ),
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
                  : accentColor,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: isDisabled ? grayTextColor : whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
