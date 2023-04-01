import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.green,
        child:Row(
        children: const [Text('Nature protector'), Icon(Icons.shield, color: Colors.brown,)]
      )
    );
  }
}