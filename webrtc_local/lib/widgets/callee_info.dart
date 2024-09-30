import 'package:flutter/material.dart';
import 'package:webrtc_demo/widgets/widgets.dart';

class CalleeInfo extends StatelessWidget {
  final StringCallback onCall;

  const CalleeInfo({super.key, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Callee info",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
              CallDialer(onCall: onCall),
            ],
          )),
    );
  }
}
