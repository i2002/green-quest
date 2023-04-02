import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Quest {
  final String id;
  final String name;
  final String details;
  final DateTime date;

  const Quest(this.id, this.name, this.details, this.date);
}

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("/quests")
          .orderBy("date")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final quests = snapshot.data?.docs;

        if (quests!.isEmpty) {
          return const Text("No data.");
        }

        return ListView.builder(
          itemCount: quests.length,
          itemBuilder: (context, index) {
            var questData = quests[index];
            Quest q = Quest(
              questData.id, 
              questData["name"], 
              questData["details"],
              questData["date"].toDate()
            );

            String formattedDate = DateFormat.yMMMMd()
                .add_jm()
                .format(questData["date"].toDate());

            return Card(
              child: ListTile(
                title: Text(questData["name"]),
                subtitle: Text("Date: $formattedDate"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestScreen(quest: q),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class QuestScreen extends StatelessWidget {
  const QuestScreen({super.key, required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd().add_jm().format(quest.date);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quest details"),
        backgroundColor: Colors.greenAccent,
      ),
      body: StreamBuilder<bool>(
        stream: FirebaseFirestore.instance
          .collection("/quests/${quest.id}/participants")
          .snapshots()
          .asyncMap((snapshot) {
            final user = FirebaseAuth.instance.currentUser!;
            final attending = snapshot.docs.where((element) => element.id == user.uid).isNotEmpty;
            return attending;
          }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final attending = snapshot.data;

          if(attending == null) {
            return const Text("Data error");
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(child:
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(quest.name, style: Theme.of(context).textTheme.displaySmall)
                      )
                    )
                ]),
                Row(
                  children: [
                    Flexible(child: Text(
                      quest.details,
                      textScaleFactor: 1.5,
                    ))
                  ],
                ),
                Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => attending ? abortQuest(quest.id) : attendQuest(quest.id),
                          child: Text((() => attending ? 'Abort quest' : 'Take the Quest!')()),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text('Date: $formattedDate')
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      )
    );
  }

  Future attendQuest(questId) async {
    var db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    var attendingRef = db.doc("/user-profiles/${user.uid}/quests/$questId");
    var attendeeRef = db.doc("/quests/$questId/participants/${user.uid}");

    var batch = db.batch();
    batch.set(attendingRef, {"confirmed": false});
    batch.set(attendeeRef, {"confirmed": false});
    await batch.commit();
  }

  Future abortQuest(questId) async {
    var db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    var attendingRef = db.doc("/user-profiles/${user.uid}/quests/$questId");
    var attendeeRef = db.doc("/quests/$questId/participants/${user.uid}");

    var batch = db.batch();
    batch.delete(attendingRef);
    batch.delete(attendeeRef);
    await batch.commit();
  }
}
