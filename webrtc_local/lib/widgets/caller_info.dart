import 'package:flutter/material.dart';

class CallerInfo extends StatelessWidget {
  final String callerId;

  const CallerInfo({super.key, required this.callerId});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Share the number below to let others reach you!",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Text(
                callerId,
                style: const TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              )
            ]));
  }
}
