import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.group),
          color: Color(0xffc0fcf9),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.id);
          },
          icon: Icon(Icons.home),
          color: Color(0xffc0fcf9),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, MenuScreen.id);
          },
          icon: Icon(Icons.menu),
          color: Color(0xffc0fcf9),
        ),
      ],
    );
  }
}
