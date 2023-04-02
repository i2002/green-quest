import 'package:green_quest/pages/home.dart';
import 'package:green_quest/pages/leaderboard.dart';
import 'package:green_quest/pages/qr.dart';
import 'package:green_quest/pages/profile.dart';
import 'package:green_quest/pages/discover.dart';
import 'package:flutter/material.dart';

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: 'Discover',
            icon: Icon(Icons.search),
          ),
          NavigationDestination(
            //!Good name for QR
            label: 'QR',
            icon: Icon(Icons.qr_code_rounded),
          ),
          NavigationDestination(
            label: 'LeaderBoard',
            icon: Icon(Icons.leaderboard_outlined),
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
      body: const [
        Home(),
        Discover(),
        QR(),
        Leaderboard(),
        Profile()
      ][currentIndex],
    );
  }
}
