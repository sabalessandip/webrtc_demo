import 'package:flutter/material.dart';
import 'package:webrtc_demo/common/double_extension.dart';
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

  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();
  final double minOverlaySize = 0.18;
  final double maxOverlaySize = 0.9;
  bool expanded = false;

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
            'Want to see someone?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Stack(
          children: [
            expanded
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                    child: CallerInfo(callerId: widget.callerId),
                  ),
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                var precisedNotificationExtent =
                    notification.extent.toPrecision(2);
                if (!expanded && precisedNotificationExtent >= maxOverlaySize) {
                  setState(() {
                    expanded = true;
                  });
                } else if (expanded &&
                    precisedNotificationExtent <= minOverlaySize) {
                  setState(() {
                    expanded = false;
                  });
                }
                return true;
              },
              child: DraggableScrollableSheet(
                controller: _scrollableController,
                initialChildSize: minOverlaySize,
                minChildSize: minOverlaySize,
                maxChildSize: maxOverlaySize,
                snap: true,
                builder: (context, scrollController) => Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        const DragIndicator(),
                        CalleeInfo(
                          onCall: _initiateCall,
                          descriptiveTitle: !expanded,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
