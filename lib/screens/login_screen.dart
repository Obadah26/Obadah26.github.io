import 'package:alhadiqa/circle_painter.dart';
import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final box = GetStorage();
  String email = '';
  String password = '';
  bool _rememberMe = false;
  bool showSpinner = false;
  bool _passwordHasError = false;

  @override
  void initState() {
    super.initState();
    // Load saved email and remember me state
    _rememberMe = box.read('rememberMe') ?? false;
    if (_rememberMe) {
      email = box.read('email') ?? '';
      emailController.text = email;
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWeb = constraints.maxWidth > 600;

            return Stack(
              children: [
                Visibility(
                  visible: isWeb ? false : true,
                  child: CustomPaint(
                    painter: CircleIntersectionPainter(),
                    size: Size(400, 400),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppBar(
                          toolbarHeight: isWeb ? 120 : 100,
                          title: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: isWeb ? 42 : 35,
                                    ),
                                    SizedBox(width: isWeb ? 12 : 10),
                                    Text(
                                      'تسجيل دخول',
                                      style: GoogleFonts.cairo(
                                        textStyle: kHeading1Text.copyWith(
                                          fontSize: isWeb ? 35 : 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '! مرحبا بك من جديد',
                                  style: GoogleFonts.cairo(
                                    textStyle: kBodyRegularText.copyWith(
                                      fontSize: isWeb ? 19 : 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(height: isWeb ? 0 : 70),
                        Center(
                          child: Text(
                            'الحديقة',
                            style: GoogleFonts.elMessiri(
                              textStyle: kHeading1Text.copyWith(
                                color: kLightPrimaryColor,
                                fontSize: isWeb ? 50 : 40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        RoundedTextField(
                          obscure: false,
                          textColor: kPrimaryTextLight,
                          controller: emailController,
                          icon: Icons.email,
                          textHint: 'الايميل',
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
                          textHint: 'كلمة المرور',
                          icon: Icons.lock,
                          keyboardType: TextInputType.visiblePassword,
                          hintColor: kPrimaryTextLight.withValues(
                            alpha: (0.199 * 255),
                          ),
                          onChanged: (value) {
                            password = value;
                            if (_passwordHasError) {
                              setState(() {
                                _passwordHasError = false;
                              });
                            }
                          },
                          hasError: _passwordHasError,
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'تذكرني',
                              style: GoogleFonts.cairo(
                                textStyle: kBodySmallText.copyWith(),
                              ),
                            ),
                            Checkbox(
                              value: _rememberMe,
                              activeColor: kLightPrimaryColor,
                              checkColor: Colors.white,
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return kLightPrimaryColor;
                                  }
                                  return Colors.transparent;
                                },
                              ),
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
                            SizedBox(width: isWeb ? 585 : 15),
                          ],
                        ),
                        SizedBox(height: isWeb ? 20 : 10),
                        RoundedButton(
                          onPressed: () async {
                            setState(() => showSpinner = true);
                            try {
                              final user = await _auth
                                  .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                              setState(() {
                                _passwordHasError = false;
                              });

                              if (user.user != null) {
                                if (!user.user!.emailVerified) {
                                  await user.user!.sendEmailVerification();
                                  throw FirebaseAuthException(
                                    code: 'email-not-verified',
                                    message:
                                        'يرجى التحقق من بريدك الإلكتروني من أجل تفعيل حسابك',
                                  );
                                }
                                if (_rememberMe) {
                                  box.write('rememberMe', true);
                                  box.write('email', email);
                                } else {
                                  box.remove('rememberMe');
                                  box.remove('email');
                                }
                                if (user.user!.displayName == null ||
                                    user.user!.displayName!.isEmpty) {
                                  final userDoc =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.user!.uid)
                                          .get();
                                  if (userDoc.exists) {
                                    await user.user!.updateProfile(
                                      displayName: userDoc.data()!['username'],
                                    );
                                    await user.user!.reload();
                                  }
                                }
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeScreen.id,
                                  (route) => false,
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              String message = '';
                              if (e.code == 'user-not-found') {
                                message = 'البريد الإلكتروني غير مسجل';
                                setState(() {
                                  _passwordHasError = false;
                                });
                              } else if (e.code == 'wrong-password' ||
                                  e.code == 'invalid-credential') {
                                message = 'كلمة المرور خاطئة';
                                setState(() {
                                  _passwordHasError = true;
                                });
                              } else if (e.code == 'email-not-verified') {
                                message =
                                    'يرجى التحقق من بريدك الإلكتروني أولاً من أجل تفعيل حسابك';
                                _passwordHasError = false;
                              } else {
                                message = 'حدث خطأ ما، يرجى المحاولة لاحقاً';
                                setState(() {
                                  _passwordHasError = false;
                                });
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    message,
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } finally {
                              setState(() => showSpinner = false);
                            }
                          },
                          buttonText: 'تسجيل دخول',
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لم تسجل بعد ؟',
                              style: GoogleFonts.cairo(
                                textStyle: kBodySmallText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        RoundedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterScreen.id);
                            emailController.clear();
                            passwordController.clear();
                          },
                          buttonText: 'إنشاء حساب جديد',
                          isPrimary: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
