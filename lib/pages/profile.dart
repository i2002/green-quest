import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Container(
      child: Column(children: [
        Text(user.email!),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: Text('Sign Out'))
      ]),
    );
  }
}