import 'package:flutter/material.dart';

class CallerInfo extends StatelessWidget {
  final String callerId;

  const CallerInfo({super.key, required this.callerId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Your info",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                Text(
                  callerId,
                  style: const TextStyle(fontSize: 36),
                  textAlign: TextAlign.center,
                )
              ])),
    );
  }
}
