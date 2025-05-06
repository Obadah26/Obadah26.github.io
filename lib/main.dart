import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        MenuScreen.id: (context) => MenuScreen(),
      },
    );
  }
}
