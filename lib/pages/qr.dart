import 'package:flutter/material.dart';

class QR extends StatelessWidget {
  const QR({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Image.asset(
        'assets/images/QR_code.png',
      ),
    );
  }
}
