import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';

class MenuButtons extends StatelessWidget {
  const MenuButtons({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.size,
  });
  final IconData icon;
  final String text;
  final Function() onPressed;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xFFe6f2f6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kDarkPrimaryColor, width: 2),
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: onPressed,
            color: Colors.white,
            icon: Icon(icon, size: 50, color: kDarkPrimaryColor),
          ),
          Text(
            text,
            style: kBodySmallText.copyWith(
              fontSize: size,
              color: kDarkPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
