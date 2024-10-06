import 'package:permission_handler/permission_handler.dart';

class CallManager {
  static final CallManager _singleton = CallManager._internal();

  factory CallManager() {
    return _singleton;
  }

  CallManager._internal();

  Future<bool> checkRequiredPermissions() async {
    if (await Permission.phone.request().isGranted &&
        await Permission.microphone.request().isGranted &&
        await Permission.camera.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void displayIncomingCall() {}

  void makeOutgoingCall() {}
}
