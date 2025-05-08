import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';

class IjazahRecitationScreen extends StatefulWidget {
  const IjazahRecitationScreen({super.key});
  static String id = 'ijazah_recitation_screen';

  @override
  State<IjazahRecitationScreen> createState() => _IjazahRecitationScreenState();
}

class _IjazahRecitationScreenState extends State<IjazahRecitationScreen> {
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
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
              color: Color(0xFFa1aab6),
              size: 35,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 2),
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
                color: Color(0xFF087ea2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text('تسميع الاجازة', style: kHeading2Text),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ':',
                        style: kBodyRegularText.copyWith(fontSize: 20),
                        textAlign: TextAlign.right,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'اضافة تسميع',
                          style: kBodyRegularText.copyWith(fontSize: 20),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundedTextField(
                        obscure: false,
                        textColor: kPrimaryTextLight,
                        textHint: '312',
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        width: 150,
                        height: 50,
                        hintColor: kSecondaryTextLight.withValues(
                          alpha: (0.199 * 255),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'من صفحة',
                          style: kBodyRegularText.copyWith(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundedTextField(
                        obscure: false,
                        textColor: kPrimaryTextLight,
                        textHint: '330',
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        width: 150,
                        height: 50,
                        hintColor: kSecondaryTextLight.withValues(
                          alpha: (0.199 * 255),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'الى صفحة',
                          style: kBodyRegularText.copyWith(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text('حفظ', style: kBodyLargeTextDark),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
