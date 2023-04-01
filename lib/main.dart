import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // initialize widgets
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // run application
  runApp(const MyApp()); 
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
          backgroundColor: Colors.green,
          title: const Text('Green Quest'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              print('Ana are mere!');
            },
            child: const Text('Click'),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              //!Good name for QR
              label: 'QR',
              icon: Icon(Icons.qr_code_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}
