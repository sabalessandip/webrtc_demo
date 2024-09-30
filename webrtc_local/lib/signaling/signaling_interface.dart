typedef StringDynamicCallback = void Function(String, dynamic);

abstract class SignalingInterface {
  StringDynamicCallback? onReceivedOffer;
  StringDynamicCallback? onReceivedAnswer;
  StringDynamicCallback? onReceivedIceCandidate;

  void sendIceCandidate({required String calleeId, required dynamic candidate});
  void sendAnswer({required String calleeId, required dynamic answer});
  void sendOffer({required String calleeId, required dynamic offer});
}
