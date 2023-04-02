import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_quest/pages/discover.dart';
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
                  children: [
                    StreamBuilder<List<DocumentSnapshot>>(
                      stream: FirebaseFirestore.instance
                        .collection("/user-profiles/${user.uid}/quests")
                        .snapshots()
                        .asyncMap((snapshot) {
                          return Future.wait(snapshot.docs.map((doc) {
                            return FirebaseFirestore.instance.doc("quests/${doc.id}").get();
                          }).toList());
                        }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final quests = snapshot.data;
                        if (quests!.isEmpty) {
                          return const Text("No data.");
                        }

                        return Expanded(child: ListView.builder(
                          itemCount: quests.length,
                          itemBuilder: (context, index) {
                            Quest q = Quest(
                              quests[index].id, 
                              quests[index]["name"], 
                              quests[index]["details"],
                              quests[index]["date"].toDate()
                            );

                            return Text(q.name);
                          },
                          shrinkWrap: true,
                        ));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future fetchActiveQuests() async {
    var db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;

    var questIds = await db.collection("user-details/${user.uid}/quests").get();
    var questDocs = await Future.wait(questIds.docs.map((doc) => db.doc("quests/${doc.id}").get()));

    return questDocs
      .where((element) => element.exists)
      .map((doc) => Quest(doc.id, doc["name"], doc["details"], doc["date"].toDate()))
      .where((quest) => quest.date.isAfter(DateTime.now()))
      .toList()
      .sort((a, b) => a.date.compareTo(b.date));
  }
}
