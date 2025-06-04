import 'package:alhadiqa/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildTimePickerTile extends StatelessWidget {
  const BuildTimePickerTile({
    super.key,
    required this.title,
    required this.time,
    required this.onTap,
  });
  final String title;
  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formattedTime = time.format(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Text(
              formattedTime,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: kLightPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: kPrimaryTextLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
