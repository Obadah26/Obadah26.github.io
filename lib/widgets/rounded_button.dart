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

  static const primaryBase = Color(0xFF119DA4);
  static const primaryReflection = Color(0xFF11F7A3);
  static const secondaryBase = Color(0xFF0C7489);
  static const disabledColor = Color(0x6613505B);

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
          gradient:
              isDisabled
                  ? null
                  : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isPrimary ? primaryReflection : Color(0x33FFFFFF),
                      isPrimary ? primaryBase : secondaryBase,
                    ],
                    stops: const [0.0, 0.7],
                  ),
          color: isDisabled ? disabledColor : null,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
