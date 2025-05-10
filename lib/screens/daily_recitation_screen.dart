import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
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
  int? selectedButtonIndex;
  List<String> buttonTexts = ['مع نفسي', 'مع شخص اخر', 'لشخص اخر'];
  bool withVisible = false;
  bool toVisible = false;
  bool inputVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.group_outlined, size: 50, color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
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
              color: kLightPrimaryColor,
              size: 50,
            ),
          ),
        ),
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
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 60),
                  Center(child: Text('التسميع اليومي', style: kHeading2Text)),
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
                  Row(
                    children: List.generate(buttonTexts.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (selectedButtonIndex != index) {
                                selectedButtonIndex = index;
                                withVisible = (index == 1);
                                toVisible = (index == 2);
                                inputVisible = true;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color:
                                  selectedButtonIndex == index
                                      ? kSecondaryColor
                                      : Colors.transparent,
                              border: Border.all(
                                color: kSecondaryColor,
                                width: 2,
                              ),
                            ),
                            height: 35,
                            width: 105,
                            child: Text(
                              buttonTexts[index],
                              style: kBodySmallTextDark.copyWith(
                                color:
                                    selectedButtonIndex == index
                                        ? Colors.white
                                        : kSecondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: withVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 250,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: kLightPrimaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedName,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: kLightPrimaryColor,
                            ),
                            iconSize: 24,
                            elevation: 4,
                            style: kBodyRegularText.copyWith(fontSize: 20),
                            underline: Container(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedName = newValue!;
                              });
                            },
                            dropdownColor: Colors.white,
                            items:
                                names.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(value),
                                    ),
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
                  ),
                  Visibility(
                    visible: toVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 250,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: kLightPrimaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedName,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: kLightPrimaryColor,
                            ),
                            iconSize: 24,
                            elevation: 4,
                            style: kBodyRegularText.copyWith(fontSize: 20),
                            underline: Container(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedName = newValue!;
                              });
                            },
                            dropdownColor: Colors.white,
                            items:
                                names.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'سمعت ل',
                            style: kBodyRegularText.copyWith(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: inputVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundedTextField(
                          obscure: false,
                          textColor: kPrimaryTextLight,
                          textHint: '312',
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
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: inputVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RoundedTextField(
                          obscure: false,
                          textColor: kPrimaryTextLight,
                          textHint: '330',
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
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: RoundedButton(
                      buttonText: 'حفظ',
                      isPrimary: false,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: 450),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
