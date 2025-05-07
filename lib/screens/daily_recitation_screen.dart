import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class DailyRecitationScreen extends StatefulWidget {
  const DailyRecitationScreen({super.key});
  static String id = 'daily_recitation_screen';

  @override
  State<DailyRecitationScreen> createState() => _DailyRecitationScreenState();
}

class _DailyRecitationScreenState extends State<DailyRecitationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('التسميع اليومي', style: kHeading1Text)),
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF13505B),
        toolbarHeight: 50,
      ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: Color(0x6613505B),
    );
  }
}
