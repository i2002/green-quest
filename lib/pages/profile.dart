import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_quest/utilities/userCard.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;
    final docRef = db.collection('user-profiles').doc(user.uid);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data();
      print(data);
    });

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Email: ${user.email!}',
                textScaleFactor: 1.5,
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Username: ',
                textScaleFactor: 1.5,
              ),
              GetUserName()
            ],
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('Sign Out'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}