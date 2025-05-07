import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/names.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';

class DailyRecitationScreen extends StatefulWidget {
  const DailyRecitationScreen({super.key});
  static String id = 'daily_recitation_screen';

  @override
  State<DailyRecitationScreen> createState() => _DailyRecitationScreenState();
}

class _DailyRecitationScreenState extends State<DailyRecitationScreen> {
  String selectedName = 'أحمد';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('التسميع اليومي', style: kHeading1Text)),
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
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kDarkPrimaryColor, width: 1.5),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedName,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 4,
                      style: kBodyRegularText.copyWith(fontSize: 20),
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedName = newValue!;
                        });
                      },
                      items:
                          names.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'سمعت مع',
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
                    textHint: '312',
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                    width: 150,
                    height: 50,
                    hintColor: kSecondaryTextLight,
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
                    textHint: '330',
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                    width: 150,
                    height: 50,
                    hintColor: kSecondaryTextLight,
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
