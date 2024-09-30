import 'package:flutter/services.dart';
import 'package:webrtc_demo/utils/app_logger.dart';

abstract class ClipboardUtility {
  static Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      AppLogger().error("Failed to copy text to clipboard: $e");
    }
  }

  static Future<String?> getFromClipboard() async {
    try {
      ClipboardData? clipboardData = await Clipboard.getData('text/plain');
      return clipboardData?.text;
    } catch (e) {
      AppLogger().error("Failed to get text from clipboard: $e");
      return null;
    }
  }
}
