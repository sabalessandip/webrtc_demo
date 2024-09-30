import 'package:flutter/material.dart';
import 'package:webrtc_demo/entity/IceCandidate.dart';
import 'package:webrtc_demo/signaling/signaling.dart';
import 'package:webrtc_demo/utils/utils.dart';
import 'webrtc_handler.dart';

class WebRTCSession {
  final SignalingClient signalingChannel;
  final String callerId;
  VoidCallback? onConnectedCall;
  VoidCallback? onUpdate;

  WebRTCHandler? _handler;
  String? _calleeId;
  bool _offeror = false;
  bool _mute = false;
  bool _videoOn = true;
  final List<IceCandidate> _iceCandidates = [];

  WebRTCHandler? get handler => _handler;
  bool get isMute => _mute;
  bool get isVideoOn => _videoOn;

  WebRTCSession({required this.callerId, required this.signalingChannel}) {
    _registerSignalingEvents();
  }

  Future<void> initiateCall(calleeId) async {
    _offeror = true;
    _initiateCaller();

    try {
      _calleeId = calleeId;
      var offer = await _handler?.createOffer();
      AppLogger().info("Generated offer=$offer");
      signalingChannel.sendOffer(calleeId: calleeId, offer: offer);
      if (onConnectedCall != null) {
        onConnectedCall!();
      }
    } catch (e) {
      AppLogger().error("Error occurred while initialing call $e");
    }
  }

  void hangup() {
    _calleeId = null;
    _handler?.dispose();
    _handler = null;
    _offeror = false;
    _iceCandidates.clear();
  }

  void toggleAudio() {
    _mute = !_mute;
    _handler?.localStream?.getAudioTracks().forEach((track) {
      track.enabled = !_mute;
    });
    _notifyUpdate();
  }

  void toggleVideo() {
    _videoOn = !_videoOn;

    _handler?.localStream?.getVideoTracks().forEach((track) {
      track.enabled = _videoOn;
    });
    _notifyUpdate();
  }

  void switchCamera() {
    _handler?.localStream?.getVideoTracks().forEach((track) {
      track.switchCamera();
    });
    _notifyUpdate();
  }
}

extension UpdaterHelper on WebRTCSession {
  void _notifyUpdate() {
    if (onUpdate != null) {
      onUpdate!();
    }
  }
}

extension CreateWebRTCHandler on WebRTCSession {
  void _initiateCaller() {
    _createWebRTCHandler();
  }

  void _createWebRTCHandler() {
    _handler = WebRTCHandler();
    _registerOnGenerateIceCandidate();
    _handler?.onConnectedState = () {
      _notifyUpdate();
    };
  }
}

extension SignalingEvents on WebRTCSession {
  void _registerSignalingEvents() {
    signalingChannel.onReceivedOffer = _onReceivedOffer;
    signalingChannel.onReceivedAnswer = _onReceivedAnswer;
    signalingChannel.onReceivedIceCandidate = _onReceiveIceCandidate;
  }

  void _onReceivedOffer(String caller, dynamic offer) async {
    _initiateCaller();

    try {
      AppLogger().info("Received offer=$offer");
      _calleeId = caller;
      var answer = await _handler?.createAnswerForOffer(offer);
      _notifyUpdate();
      AppLogger().info("Generated answer=$answer");
      signalingChannel.sendAnswer(calleeId: caller, answer: answer);
      if (onConnectedCall != null) {
        onConnectedCall!();
      }
    } catch (e) {
      AppLogger().error("Error occurred while accepting offer $e");
    }
  }

  void _onReceivedAnswer(String caller, dynamic answer) {
    try {
      AppLogger().info("Received answer=$answer");
      _handler?.setRemoteDescription(answer);
      _notifyUpdate();
      for (var candidate in _iceCandidates) {
        _sendIceCandidate(candidate);
      }
      _notifyUpdate();
    } catch (e) {
      AppLogger().error("Error occurred while accepting answer $e");
    }
  }

  void _onReceiveIceCandidate(String caller, dynamic candidate) {
    try {
      AppLogger().warning("received ice candidate ${candidate.toString()}");
      var iceCandidate = IceCandidate.withMap(candidate);
      _handler?.setIceCandidate(iceCandidate);
    } catch (e) {
      AppLogger().error("Error receiving ice candidate $e");
    }
  }
}

extension IceCandidates on WebRTCSession {
  void _registerOnGenerateIceCandidate() {
    _handler?.onIceCandidate = _onGenerateIceCandidate;
  }

  void _onGenerateIceCandidate(IceCandidate candidate) {
    try {
      if (_calleeId != null) {
        AppLogger().info("generated ice candidate ${candidate.toString()}");
        if (_offeror) {
          _iceCandidates.add(candidate);
        } else {
          _sendIceCandidate(candidate);
        }
      }
    } catch (e) {
      AppLogger().error("Error sending generated ice candidate $e");
    }
  }

  void _sendIceCandidate(IceCandidate candidate) {
    signalingChannel.sendIceCandidate(
        calleeId: _calleeId!, candidate: candidate.toMap());
  }
}
