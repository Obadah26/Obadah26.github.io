import 'package:alhadiqa/const.dart';
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
      appBar: AppBar(
        title: Center(
          child: Text(
            'تسميع الاجازة',
            style: kHeading1Text.copyWith(fontSize: 25),
          ),
        ),
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                    backgroundWhite: true,
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
                    backgroundWhite: true,
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
                    child: Center(child: Text('حفظ', style: kBodyLargeText)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
