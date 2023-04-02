import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QR extends StatelessWidget {
  const QR({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return GestureDetector(
      onTap: tempQRScan,
      child: Center(
        child: Stack(
          alignment: const Alignment(0, -0.17),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
              'assets/images/shield.png',
            )),
            QrImage(
              data: user.uid,
              size: 225,
            )
          ],
        ),
    ));
  }

  Future tempQRScan() async {
    var db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    var quest = await db.collection("/user-profiles/${user.uid}/quests/").limit(1).get();
    if (quest.docs.isEmpty) {
      return;
    }

    await confirmAttrendance(quest.docs[0].id);
  }

  Future confirmAttrendance(questId) async {
    var db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;

    var attendingRef = db.doc("/user-profiles/${user.uid}/quests/$questId");
    var attendeeRef = db.doc("/quests/$questId/participants/${user.uid}");

    var batch = db.batch();
    batch.set(attendingRef, {"confirmed": true});
    batch.set(attendeeRef, {"confirmed": true});
    await batch.commit();

    var questXp = (await db.collection("/quests").doc(questId).get())["xp"];
    var xpOld = (await FirebaseFirestore.instance.collection("/user-profiles").doc(user.uid).get())["xp"];
    await FirebaseFirestore.instance.collection("/user-profiles").doc(user.uid).update({
      "xp": xpOld + questXp
    });
  }
}
