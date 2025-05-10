import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';

class MenuButtons extends StatelessWidget {
  const MenuButtons({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });
  final IconData icon;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xFFe5f6f1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kLightPrimaryColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            color: Colors.white,
            icon: Icon(icon, size: 50, color: kSecondaryColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: kBodySmallText.copyWith(color: kSecondaryColor),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
