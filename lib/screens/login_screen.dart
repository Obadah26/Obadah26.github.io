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
                  Center(child: Text('تسجيل دخول', style: kHeading1TextDark)),
                  SizedBox(height: 50),
                  RoundedTextField(
                    icon: Icons.person,
                    textHint: 'name@email.com',
                    keyboardType: TextInputType.emailAddress,
                    hintColor: kPrimaryTextDark.withValues(
                      alpha: (0.199 * 255),
                    ),
                  ),
                  SizedBox(height: 50),
                  RoundedTextField(
                    textHint: 'password',
                    icon: Icons.lock,
                    keyboardType: TextInputType.visiblePassword,
                    hintColor: kPrimaryTextDark.withValues(
                      alpha: (0.199 * 255),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'تذكرني',
                        style: kBodySmallTextDark.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: Color(0xFFB3E5FC),
                          checkColor: Color(0xFF03A9F4),
                          fillColor: WidgetStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return Color(0xFFB3E5FC);
                            }
                            return Colors.transparent;
                          }),
                          side: BorderSide(
                            color:
                                _rememberMe
                                    ? Color(0xFF03A9F4)
                                    : Color(0xFFB3E5FC),
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
                  RoundedButton(route: HomeScreen.id, buttonText: 'تسجيل دخول'),
                  SizedBox(height: 40),
                  Center(child: Text('او', style: kHeading2TextDark)),
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
