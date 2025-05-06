import 'package:alhadiqa/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  static String id = 'menu_screen';

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'القائمة',
            style: kHeading1Text.copyWith(color: Color(0xffc0fcf9)),
          ),
        ),
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF13505B),
        toolbarHeight: 50,
      ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: Color(0x6613505B),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomeScreen.id);
                  },
                  color: Color(0xffc0fcf9),
                  icon: Icon(Icons.home),
                ),
                Text('الرئيسية', style: kHeading2Text),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, routname?);
                  },
                  color: Color(0xffc0fcf9),
                  icon: Icon(Icons.menu_book),
                ),
                Text('التسميع اليومي', style: kHeading2Text),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, routname?);
                  },
                  color: Color(0xffc0fcf9),
                  icon: Icon(Icons.menu_book),
                ),
                Text('تسميع الاجازة', style: kHeading2Text),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, routname?);
                  },
                  color: Color(0xffc0fcf9),
                  icon: Icon(Icons.menu_book),
                ),
                Text('رمضان', style: kHeading2Text),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
