import 'package:alhadiqa/screens/azkar_screen.dart';
import 'package:alhadiqa/screens/user_detials_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:alhadiqa/screens/ijazah_leaderboard.dart';
import 'package:alhadiqa/screens/recitation_leaderboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await initializeDateFormatting('ar', null);

  final box = GetStorage();
  final bool rememberMe = box.read('rememberMe') ?? false;
  final User? user = FirebaseAuth.instance.currentUser;

  runApp(
    MyApp(
      initialRoute:
          (rememberMe && user != null) ? HomeScreen.id : WelcomeScreen.id,
      // initialRoute: WelcomeScreen.id,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        MenuScreen.id: (context) => MenuScreen(),
        DailyRecitationScreen.id: (context) => DailyRecitationScreen(),
        IjazahRecitationScreen.id: (context) => IjazahRecitationScreen(),
        RecitationLeaderboardScreen.id:
            (context) => RecitationLeaderboardScreen(),
        IjazahLeaderboardScreen.id: (context) => IjazahLeaderboardScreen(),
        UserDetailsScreen.id: (context) => UserDetailsScreen(),
        AzkarScreen.id: (context) => AzkarScreen(),
      },
    );
  }
}
