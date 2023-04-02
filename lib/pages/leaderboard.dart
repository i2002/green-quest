import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection("/user-profiles")
          .orderBy("xp", descending: true)
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final users = snapshot.data?.docs;

          if (users!.isEmpty) {
            return const Expanded(child:
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("No quests to show.")
                )
              )
            );
          }

          return Expanded(child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(users[index]["name"]),
                  subtitle: Text("XP: ${users[index]["xp"]}")
                ),
              );
            },
          ));
        }
      )
    ],);
  }
}