import 'package:flutter/material.dart';
import 'package:webrtc_demo/common/common.dart';
import 'package:webrtc_demo/pages/pages.dart';
import 'package:webrtc_demo/signaling/signaling.dart';

class WebRTCApp extends StatelessWidget with CallerIdGenerator {
  const WebRTCApp({super.key});

  @override
  Widget build(BuildContext context) {
    var callerId = generateCallerId();
    var client = SignalingClient(selfCallerId: callerId);
    client.connect(socketURL: Constants.kSocketServerURL);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WebRTC Demo",
      home: JoinCallPage(
        callerId: callerId,
        signaling: client,
      ),
    );
  }
}
