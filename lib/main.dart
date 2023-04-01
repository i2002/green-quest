import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_quest/pages/home.dart';
import 'package:green_quest/pages/qr.dart';
import 'package:green_quest/pages/profile.dart';
import 'package:green_quest/screens/AppMain.dart';
import 'package:green_quest/screens/LoginScreen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // initialize widgets
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // run application
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///debug banner off
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot) {
          if (snapshot.hasData) {
            return AppMain();
          } else {
            return LoginScreen();
          }
        },
      )
    );
  }
}
