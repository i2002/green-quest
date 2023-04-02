import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/discover.dart';

Widget questListing (context, AsyncSnapshot<List<Quest>> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const CircularProgressIndicator();
  }

  final quests = snapshot.data;

  if (quests!.isEmpty) {
    return const Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("No quests to show.")
        )
      )
    );
  }

  return Expanded(child: ListView.builder(
    shrinkWrap: true,
    itemCount: quests.length,
    itemBuilder: (context, index) {
      Quest q = quests[index];

      String formattedDate = DateFormat.yMMMMd()
          .add_jm()
          .format(q.date);

      return Card(
        child: ListTile(
          title: Text(q.name),
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
  ));
}
