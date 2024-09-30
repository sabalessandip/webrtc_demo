import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoView extends StatelessWidget {
  final bool isCompact;
  final RTCVideoRenderer renderer;
  const VideoView({super.key, required this.isCompact, required this.renderer});

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: RTCVideoView(
          renderer,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        ),
      );
    }
    return RTCVideoView(
      renderer,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    );
  }
}
