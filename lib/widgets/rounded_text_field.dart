import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    super.key,
    required this.textHint,
    required this.icon,
    required this.keyboardType,
  });

  final String textHint;
  final IconData icon;
  final TextInputType keyboardType;

  static const primaryColor = Color(0xFF03A9F4);
  static const lightPrimaryColor = Color(0xFFB3E5FC);
  static const secondaryTextColor = Color(0xFF757575);
  static const whiteColor = Colors.white;
  static const white54 = Colors.white54;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: TextField(
        keyboardType: keyboardType,
        style: TextStyle(color: whiteColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0x0D03A9F4),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(icon, color: primaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          hintText: textHint,
          hintStyle: TextStyle(color: white54),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
