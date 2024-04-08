import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_options.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyclops',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
        fontFamily: 'Lato',
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(), // Add this route
      },
    );
  }
}
