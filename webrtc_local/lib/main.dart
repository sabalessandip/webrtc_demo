import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:webrtc_demo/utils/app_logger.dart';
import 'webrtc_app.dart';

void main() {
  AppLogger().init(level: Level.debug);
  runApp(const WebRTCApp());
}
