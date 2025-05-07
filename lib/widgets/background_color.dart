import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';

class BackgroundColor extends StatelessWidget {
  const BackgroundColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kPrimaryColor, kDarkPrimaryColor, kLightPrimaryColor],
        ),
      ),
    );
  }
}
