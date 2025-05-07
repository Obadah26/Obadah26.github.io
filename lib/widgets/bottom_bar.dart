import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';
import 'package:alhadiqa/const.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BottomBarIcons(icon: Icons.group, route: HomeScreen.id),
        BottomBarIcons(icon: Icons.home, route: HomeScreen.id),
        BottomBarIcons(icon: Icons.menu, route: MenuScreen.id),
        BottomBarIcons(icon: Icons.notifications, route: HomeScreen.id),
      ],
    );
  }
}

class BottomBarIcons extends StatelessWidget {
  const BottomBarIcons({super.key, required this.icon, required this.route});

  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon),
      color: kDarkPrimaryColor,
    );
  }
}
