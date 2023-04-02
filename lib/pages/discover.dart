import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Quest {
  final String name;
  final String details;
  final DateTime date;

  const Quest(this.name, this.details, this.date);
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
          .collection("/guilds/TrFm0hrtDXiP9VwfYltu/quests")
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
            Quest q = Quest(quests[index]["name"], quests[index]["details"],
                quests[index]["date"].toDate());
            String formattedDate = DateFormat.yMMMMd()
                .add_jm()
                .format(quests[index]["date"].toDate());
            return Card(
              child: ListTile(
                title: Text(quests[index]["name"]),
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
        title: Text(
          quest.name,
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  quest.details,
                  textScaleFactor: 1.5,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Take the Quest!'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Date: ${formattedDate}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
