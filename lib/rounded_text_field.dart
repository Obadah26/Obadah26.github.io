import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    super.key,
    required this.textHint,
    required this.icon,
  });

  final String textHint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xff00949f), Color(0xff00aeab)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: TextField(
          decoration: InputDecoration(
            icon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(icon, color: Color(0xFF11F7A3)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintText: textHint,
            hintTextDirection: TextDirection.ltr,
            hintStyle: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
          ),
        ),
      ),
    );
  }
}
