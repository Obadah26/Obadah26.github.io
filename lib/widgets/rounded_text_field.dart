import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    super.key,
    required this.textHint,
    this.icon,
    required this.keyboardType,
    this.width,
    this.height,
    required this.hintColor,
  });

  final String textHint;
  final IconData? icon;
  final TextInputType keyboardType;
  final double? width;
  final double? height;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: keyboardType,
          style: TextStyle(color: Color(0xFF212121)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0x0D03A9F4),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF03A9F4), width: 1.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF03A9F4), width: 2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(icon, color: Colors.white),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: textHint,
            hintStyle: TextStyle(color: hintColor),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
        ),
      ),
    );
  }
}
