import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:webrtc_demo/webrtc/webrtc.dart';
import '../widgets/video_view.dart';

class VideoCallScreen extends StatefulWidget {
  final WebRTCSession webRTCSession;
  const VideoCallScreen({super.key, required this.webRTCSession});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    widget.webRTCSession.onUpdate = () {
      setState(() {});
    };
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: VideoView(
            isCompact: false,
            renderer: widget.webRTCSession.handler!.remoteRenderer,
          )),
          Positioned(
              right: 0,
              bottom: 40,
              width: 120,
              height: 200,
              child: VideoView(
                isCompact: true,
                renderer: widget.webRTCSession.handler!.localRenderer,
              ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Toggle Audio Button
              IconButton(
                icon: Icon(
                  widget.webRTCSession.isMute ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.webRTCSession.toggleAudio();
                },
              ),

              // Toggle Video Button
              IconButton(
                icon: Icon(
                  widget.webRTCSession.isVideoOn
                      ? Icons.videocam
                      : Icons.videocam_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.webRTCSession.toggleVideo();
                },
              ),

              // Hangup Button
              IconButton(
                icon: const Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
                onPressed: _hangup,
              ),

              // Switch Camera Button
              IconButton(
                icon: const Icon(
                  Icons.switch_camera,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.webRTCSession.switchCamera();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _hangup() {
    widget.webRTCSession.hangup();
    Navigator.pop(context);
  }
}
