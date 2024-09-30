import 'package:flutter/material.dart';
import 'package:webrtc_demo/signaling/signaling.dart';
import 'package:webrtc_demo/webrtc/webrtc.dart';
import 'package:webrtc_demo/widgets/widgets.dart';
import 'package:webrtc_demo/pages/pages.dart';

class JoinCallPage extends StatefulWidget {
  final String callerId;
  final SignalingClient signaling;

  const JoinCallPage(
      {super.key, required this.callerId, required this.signaling});

  @override
  State<JoinCallPage> createState() => _JoinCallPageState();
}

class _JoinCallPageState extends State<JoinCallPage> {
  late final WebRTCSession _webrtcSession = WebRTCSession(
    callerId: widget.callerId,
    signalingChannel: widget.signaling,
  );

  @override
  void initState() {
    super.initState();
    _webrtcSession.onConnectedCall = () {
      _navigateToVideoCallPage();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'WebRTC Demo',
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: CallerInfo(callerId: widget.callerId),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(child: CalleeInfo(onCall: _initiateCall))
          ],
        ));
  }

  void _navigateToVideoCallPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          webRTCSession: _webrtcSession,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _initiateCall(String calleeId) {
    _webrtcSession.initiateCall(calleeId);
  }
}
