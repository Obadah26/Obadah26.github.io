import 'package:flutter/material.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _storage = GetStorage();
  String email = '';
  String password = '';
  bool _rememberMe = false;
  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRememberedUser();
  }

  // Load saved credentials from GetStorage
  void _loadRememberedUser() {
    String? storedEmail = _storage.read('email');
    String? storedPassword = _storage.read('password');
    setState(() {
      email = storedEmail ?? '';
      password = storedPassword ?? '';
      _rememberMe = email.isNotEmpty && password.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.person_outlined, size: 35),
                  SizedBox(width: 10),
                  Text(
                    'إنشاء حساب جديد',
                    style: kHeading1Text.copyWith(fontSize: 25),
                  ),
                ],
              ),
              Text('! مرحبا بك في تطبيق الحديقة', style: kBodyRegularText),
            ],
          ),
        ),
        leading: null,
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
          children: [
            //BackgroundColor(),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Text(
                        'الحديقة',
                        style: kHeading1Text.copyWith(
                          fontWeight: FontWeight.w900,
                          color: kDarkPrimaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    RoundedTextField(
                      obscure: false,
                      textColor: kPrimaryTextLight,
                      controller: emailController,
                      icon: Icons.person,
                      textHint: 'name@email.com',
                      keyboardType: TextInputType.emailAddress,
                      hintColor: kPrimaryTextLight.withValues(
                        alpha: (0.199 * 255),
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(height: 50),
                    RoundedTextField(
                      obscure: true,
                      textColor: kPrimaryTextLight,
                      controller: passwordController,
                      textHint: 'password',
                      icon: Icons.lock,
                      keyboardType: TextInputType.visiblePassword,
                      hintColor: kPrimaryTextLight.withValues(
                        alpha: (0.199 * 255),
                      ),
                      onChanged: (value) {
                        password = value;
                      },
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
                            activeColor: kLightPrimaryColor,
                            checkColor: Colors.white,
                            fillColor: WidgetStateProperty.resolveWith<Color>((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return kLightPrimaryColor;
                              }
                              return Colors.transparent;
                            }),
                            side: BorderSide(
                              color:
                                  _rememberMe
                                      ? kPrimaryColor
                                      : kLightPrimaryColor,
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
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          if (user != null) {
                            if (_rememberMe) {
                              _storage.write('email', email);
                              _storage.write('password', password);
                              _storage.write('remember_me', true);
                            } else {
                              _storage.remove('email');
                              _storage.remove('password');
                              _storage.remove('remember_me');
                            }
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreen.id,
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          print(e);
                          String errorMessage = 'حدث خطأ ما. حاول مرة اخرى';

                          if (e is FirebaseAuthException) {
                            if (e.code == 'weak-password') {
                              errorMessage = 'كلمة المرور ضعيفة';
                            } else if (e.code == 'email-already-in-use') {
                              errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
                            }
                          }
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(errorMessage)));
                        }
                        setState(() {
                          showSpinner = false;
                        });
                        emailController.clear();
                        passwordController.clear();
                      },
                      buttonText: 'إنشاء حساب',
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        'هل لديك حساب من قبل ؟',
                        style: kBodyLargeText,
                      ),
                    ),
                    SizedBox(height: 40),
                    RoundedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                        emailController.clear();
                        passwordController.clear();
                      },
                      buttonText: 'تسجيل دخول',
                      isPrimary: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
