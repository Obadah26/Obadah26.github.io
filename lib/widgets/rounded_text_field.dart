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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: TextField(
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0x1AFFFFFF),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0C7489), width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF119DA4), width: 1.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(icon, color: Color(0xFF11F7A3)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          hintText: textHint,
          hintStyle: TextStyle(color: Colors.white54),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
    );
  }
}
