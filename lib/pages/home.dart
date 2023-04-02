import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_quest/pages/discover.dart';
import 'package:green_quest/utilities/quest_listing.dart';
import 'package:green_quest/utilities/userCard.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser!;

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
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                        .collection("/user-profiles")
                        .doc(user.uid)
                        .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("");
                        }

                        int xp = snapshot.data?["xp"];
                        String rank = "Unranked";
                        if (xp > 25) {
                          rank = "Silver";
                        }

                        if (xp > 50) {
                          rank = "Gold";
                        }

                        return Text(
                          "Rank: $rank", 
                          textScaleFactor: 1.5,
                          style: const TextStyle(color: Colors.white)
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text("Active Quests", style: Theme.of(context).textTheme.headlineSmall),
        Row(children: [
          StreamBuilder<List<Quest>>(
            stream: fetchUserActiveQuests(user.uid),
            builder: questListing
          )
        ]),
        const SizedBox(height: 20),
        Text("Completed Quests", style: Theme.of(context).textTheme.headlineSmall),
        Row(children: [
          StreamBuilder<List<Quest>>(
            stream: fetchUserCompletedQuests(user.uid),
            builder: questListing
          )
        ])
      ],
    );
  }

  Stream<List<Quest>> fetchUserActiveQuests(String userId) {
    return FirebaseFirestore.instance
      .collection("/user-profiles/$userId/quests")
      .snapshots()
      .asyncMap((snapshot) {
        return Future.wait(snapshot.docs.map((doc) {
          return FirebaseFirestore.instance.doc("/quests/${doc.id}").get();
        }).toList());
      })
      .map((event) => event.map((questDoc) => Quest(
        questDoc.id,
        questDoc["name"],
        questDoc["details"],
        questDoc["date"].toDate()
      )).toList())
      .map((event) {
        event = event.where((quest) => quest.date.isAfter(DateTime.now())).toList();
        event.sort((a, b) => a.date.compareTo(b.date));
        return event;
      });
  }

  Stream<List<Quest>> fetchUserCompletedQuests(String userId) {
    return FirebaseFirestore.instance
      .collection("/user-profiles/$userId/quests")
      .snapshots()
      .asyncMap((snapshot) {
        final docs = snapshot.docs.where((element) => element["confirmed"] == true);
        return Future.wait(docs.map((doc) {
          return FirebaseFirestore.instance.doc("/quests/${doc.id}").get();
        }).toList());
      })
      .map((event) => event.map((questDoc) => Quest(
        questDoc.id,
        questDoc["name"],
        questDoc["details"],
        questDoc["date"].toDate()
      )).toList())
      .map((event) {
        event = event.where((quest) => quest.date.isBefore(DateTime.now())).toList();
        event.sort((a, b) => b.date.compareTo(a.date));
        return event;
      });
  }
}
