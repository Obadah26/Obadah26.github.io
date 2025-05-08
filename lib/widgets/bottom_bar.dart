import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, this.auth});

  final FirebaseAuth? auth;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BottomBarIcons(icon: Icons.group, route: DailyRecitationScreen.id),
        BottomBarIcons(icon: Icons.home, route: HomeScreen.id),
        BottomBarIcons(icon: Icons.menu, route: MenuScreen.id, auth: auth),
        BottomBarIcons(icon: Icons.notifications, route: HomeScreen.id),
      ],
    );
  }
}

class BottomBarIcons extends StatelessWidget {
  const BottomBarIcons({
    super.key,
    required this.icon,
    required this.route,
    this.auth,
  });

  final IconData icon;
  final String route;
  final FirebaseAuth? auth;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (route == MenuScreen.id) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuScreen(auth: auth)),
          );
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      icon: Icon(icon),
      color: kDarkPrimaryColor,
    );
  }
}
