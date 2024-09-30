// https://pub.dev/documentation/flutter_webrtc/latest/flutter_webrtc/flutter_webrtc-library.html

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc_demo/entity/entity.dart';
import 'package:webrtc_demo/utils/app_logger.dart';

typedef IceCandidateCallback = void Function(IceCandidate);

class WebRTCHandler {
  RTCPeerConnection? _peerConnection;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;
  MediaStream? get localStream => _localStream;

  IceCandidateCallback? onIceCandidate;
  VoidCallback? onConnectedState;

  WebRTCHandler();

  Future<String?> createOffer() async {
    _initRenderers();
    await _setupPeerConnection();

    _peerConnection?.onConnectionState = (state) {
      AppLogger().info("Caller status : ${state.toString()}");
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected &&
          onConnectedState != null) {
        onConnectedState!();
      }
    };

    // Caller Step 1: Create offer SDP
    RTCSessionDescription description = await _peerConnection!.createOffer();

    // Caller Step 2: Set the local description with the offer SDP
    _peerConnection!.setLocalDescription(description);

    // Callee Step 3: Share the offer SDP to callee
    AppLogger().info('Offer SDP: ${description.sdp}');
    return description.sdp;
  }

  // Caller Step 4: Set the remote description with Callee's answer SDP
  void setRemoteDescription(String remoteSDP) async {
    AppLogger().info("Caller - Remote SDP :$remoteSDP");
    RTCSessionDescription description =
        RTCSessionDescription(remoteSDP, 'answer');
    AppLogger().info("Caller - Remote SDP type:${description.type}");

    await _peerConnection!.setRemoteDescription(description);
  }

  Future<String?> createAnswerForOffer(String remoteSDP) async {
    AppLogger().info("Callee - Remote SDP :$remoteSDP");
    _initRenderers();
    await _setupPeerConnection();

    _peerConnection?.onConnectionState = (state) {
      AppLogger().info("Callee status : ${state.toString()}");
    };

    // Callee Step 1: Set the remote description with the Caller's offer SDP
    RTCSessionDescription offerDescription =
        RTCSessionDescription(remoteSDP, 'offer');
    AppLogger().info("Callee - Remote SDP type:${offerDescription.type}");
    await _peerConnection!.setRemoteDescription(offerDescription);

    // Callee Step 2: Create answer SDP
    RTCSessionDescription answerDescription =
        await _peerConnection!.createAnswer();

    // Callee Step 3: Set the local description with the answer SDP
    await _peerConnection!.setLocalDescription(answerDescription);

    // Callee Step 4: Share the answer SDP back to caller
    AppLogger().info('Answer SDP: ${answerDescription.sdp}');
    return answerDescription.sdp;
  }

  void setIceCandidate(IceCandidate candidate) {
    RTCIceCandidate receivedCandidate =
        RTCIceCandidate(candidate.candidate, candidate.id, candidate.index);
    _peerConnection?.addCandidate(receivedCandidate);
  }

  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.close();
    _peerConnection?.dispose();
    _localStream?.dispose();
  }
}

extension WebRTCHandlerPrivate on WebRTCHandler {
  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _setupPeerConnection() async {
    // Configuration for STUN/TURN servers
    Map<String, dynamic> configuration = {
      // 'iceServers': [
      //   {'urls': []}
      // ]
    };

    // Map<String, dynamic> configuration = {
    //   'iceServers': [
    //     {
    //       'urls': [
    //         'stun:stun1.l.google.com:19302',
    //         'stun:stun2.l.google.com:19302'
    //       ]
    //     }
    //   ]
    // };

    _peerConnection = await createPeerConnection(configuration);

    // Handling ICE candidates
    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      AppLogger().info('New ICE candidate: ${candidate.toMap()}');
      if (onIceCandidate != null) {
        onIceCandidate!(IceCandidate(
            id: candidate.sdpMid,
            index: candidate.sdpMLineIndex,
            candidate: candidate.candidate));
      }
    };

    // Setup remote stream and attach to renderer
    // _peerConnection!.onAddStream = (MediaStream remoteStream) {
    //   _remoteRenderer.srcObject = remoteStream;
    // };
    _peerConnection!.onTrack = (event) {
      _remoteRenderer.srcObject = event.streams[0];
    };

    // Setup local stream and attach to renderer
    _localStream = await _getUserMedia();
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
    _localRenderer.srcObject = _localStream;
  }

  Future<MediaStream> _getUserMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
        'optional': [],
      },
    };
    return await navigator.mediaDevices.getUserMedia(constraints);
  }
}
