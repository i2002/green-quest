import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 150,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 150,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 150,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
