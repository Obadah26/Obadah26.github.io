import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/background_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundColor(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Center(child: Text('تسجيل دخول', style: kHeading1Text)),
                  SizedBox(height: 50),
                  RoundedTextField(
                    icon: Icons.person,
                    textHint: 'name@email.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 50),
                  RoundedTextField(
                    textHint: 'password',
                    icon: Icons.lock,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'تذكرني',
                        style: kBodySmallText.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: Color(0xFF119DA4),
                          checkColor: Color(0xFFD7D9CE),
                          fillColor: WidgetStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return Color(0xFF119DA4);
                            }
                            return Colors.transparent;
                          }),
                          side: BorderSide(
                            color:
                                _rememberMe
                                    ? Color(0xFF119DA4)
                                    : Color(0xFF0C7489),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  RoundedButton(
                    route: HomeScreen.id,
                    buttonText: 'تسجيل دخول',
                    isPrimary: true,
                  ),
                  SizedBox(height: 40),
                  Center(child: Text('او', style: kHeading2Text)),
                  SizedBox(height: 40),
                  RoundedButton(
                    route: RegisterScreen.id,
                    buttonText: 'إنشاء حساب جديد',
                    isPrimary: false,
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
