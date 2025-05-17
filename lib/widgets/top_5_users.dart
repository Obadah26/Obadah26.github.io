import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/green_contatiner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Top5Users extends StatelessWidget {
  const Top5Users({super.key, required this.topUsers});

  final List<MapEntry<String, int>> topUsers;

  @override
  Widget build(BuildContext context) {
    return GreenContatiner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'أفضل 5 مسمعين خلال هذا الشهر',
            style: GoogleFonts.elMessiri(
              textStyle: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: kDarkPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: 12),
          ...topUsers
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    entry.key,
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: kLightPrimaryColor,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
