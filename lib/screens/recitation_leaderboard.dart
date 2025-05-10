import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:flutter/material.dart';

class RecitationLeaderboardScreen extends StatefulWidget {
  const RecitationLeaderboardScreen({super.key});
  static String id = 'recitation_leaderboard_screen';

  @override
  State<RecitationLeaderboardScreen> createState() =>
      _RecitationLeaderboardScreenState();
}

class _RecitationLeaderboardScreenState
    extends State<RecitationLeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.person_outline, size: 50, color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -35,
            right: -75,
            child: Container(
              width: 225,
              height: 200,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -35,
            left: -75,
            child: Container(
              width: 225,
              height: 200,
              decoration: BoxDecoration(
                color: kLightPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      HomeScreen.id,
                      (route) => false,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF87d5bd),
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
