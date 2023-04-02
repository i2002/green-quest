import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('/user-profiles');
    final user = FirebaseAuth.instance.currentUser!;

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("??");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("not found");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Text(
              data["name"],
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.white),
            );
          }
          
          return const Icon(
            Icons.download,
            color: Colors.white,
          );
        });
  }
}
