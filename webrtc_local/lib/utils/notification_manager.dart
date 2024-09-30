import 'package:flutter/material.dart';

abstract class NotificationManager {
  static void notify({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to Clipboard: $message')),
    );
  }
}
