import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QR extends StatelessWidget {
  const QR({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Center(
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
    );
  }
}
