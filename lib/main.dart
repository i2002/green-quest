import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_quest/pages/home.dart';
import 'package:green_quest/pages/qr.dart';
import 'package:green_quest/pages/profile.dart';
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
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: const Text(
              'Green Quest',
              style: TextStyle(color: Colors.black),
            ),
          ),
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(seconds: 1),
            backgroundColor: Colors.greenAccent,
            destinations: const [
              NavigationDestination(
                label: 'Home',
                icon: Icon(Icons.home_outlined),
              ),
              NavigationDestination(
                //!Good name for QR
                label: 'QR',
                icon: Icon(Icons.qr_code_rounded),
              ),
              NavigationDestination(
                label: 'Profile',
                icon: Icon(Icons.account_circle_outlined),
              ),
            ],
            selectedIndex: currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          body: const [Home(), QR(), Profile()][currentIndex]),
    );
  }
}
