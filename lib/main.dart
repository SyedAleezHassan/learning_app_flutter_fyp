import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/provider/caterory_provider.dart';
import 'package:flutter_application_1/screens/account.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'navBar/navBar.dart';
import 'screens/chatbot/chatbotApi.dart';

// void main() => runApp(Myapp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =Constants.stripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );

  runApp(Myapp());
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyText1: TextStyle(
            color: Colors.black), // Default black text for light theme
        bodyText2: TextStyle(color: Colors.black),
      ),
    );
  }

  ThemeData get darkTheme {
    //darak thiem
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
      ),
    );
  }
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    // ChangeNotifierProvider(
    //   create: (context) => ThemeProvider(),
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        // Add more providers here if needed
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
         return MaterialApp(
          themeMode: themeProvider.themeMode,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          // theme: ThemeData(
          //   scaffoldBackgroundColor: Colors.white,
          // ),
          debugShowCheckedModeBanner: false,

          home: WelcomeScreen(),
        );
      },
    );
  }
}
