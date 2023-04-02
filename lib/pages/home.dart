import 'package:flutter/material.dart';
import 'package:green_quest/utilities/userCard.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Card(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Player: ',
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                    GetUserName(),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Rank: ',
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                    GetUserName(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Active Quests:',
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text(
                      'Something',
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
