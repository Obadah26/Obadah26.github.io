import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, this.auth, required this.selectedIndex});

  final FirebaseAuth? auth;
  final int selectedIndex;

  void _navigateToRoute(BuildContext context, String route) {
    if (route == MenuScreen.id) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen(auth: auth)),
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BottomBarIcons(
          icon: Icons.group,
          route: DailyRecitationScreen.id,
          isSelected: selectedIndex == 0,
          onPressed: () => _navigateToRoute(context, DailyRecitationScreen.id),
        ),
        BottomBarIcons(
          icon: Icons.home,
          route: HomeScreen.id,
          isSelected: selectedIndex == 1,
          onPressed: () => _navigateToRoute(context, HomeScreen.id),
        ),
        BottomBarIcons(
          icon: Icons.menu,
          route: MenuScreen.id,
          isSelected: selectedIndex == 2,
          onPressed: () => _navigateToRoute(context, MenuScreen.id),
        ),
        BottomBarIcons(
          icon: Icons.notifications,
          route: HomeScreen.id,
          isSelected: selectedIndex == 3,
          onPressed: () => _navigateToRoute(context, HomeScreen.id),
        ),
      ],
    );
  }
}

class BottomBarIcons extends StatelessWidget {
  const BottomBarIcons({
    super.key,
    required this.icon,
    required this.route,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final String route;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isSelected ? icon : _getOutlinedVariant(icon),
        color: isSelected ? kSecondaryColor : Colors.black,
      ),
    );
  }

  IconData _getOutlinedVariant(IconData icon) {
    final outlinedIcons = {
      Icons.group: Icons.group_outlined,
      Icons.home: Icons.home_outlined,
      Icons.menu: Icons.menu_outlined,
      Icons.notifications: Icons.notifications_outlined,
    };
    return outlinedIcons[icon] ?? icon;
  }
}
