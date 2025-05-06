import 'package:flutter/material.dart';

class BackgroundColor extends StatelessWidget {
  const BackgroundColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF13505B), Color(0xFF040404)],
        ),
      ),
    );
  }
}
