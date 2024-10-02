import 'package:flutter/material.dart';
import 'package:webrtc_demo/widgets/widgets.dart';

class CalleeInfo extends StatelessWidget {
  final bool descriptiveTitle;
  final StringCallback onCall;

  const CalleeInfo(
      {super.key, required this.onCall, required this.descriptiveTitle});

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
              Text(
                '${descriptiveTitle ? "Or " : ""}Dial the number shared with you!',
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              CallDialer(onCall: onCall),
            ],
          )),
    );
  }
}
