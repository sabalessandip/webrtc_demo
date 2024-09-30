import 'package:webrtc_demo/common/common.dart';
import 'signaling_interface.dart';
import 'package:webrtc_demo/utils/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as SocketIO;

class SignalingClient implements SignalingInterface {
  SocketIO.Socket? _socket;
  String selfCallerId;

  @override
  StringDynamicCallback? onReceivedAnswer;

  @override
  StringDynamicCallback? onReceivedIceCandidate;

  @override
  StringDynamicCallback? onReceivedOffer;
  SignalingClient({required this.selfCallerId});

  @override
  void sendIceCandidate(
      {required String calleeId, required dynamic candidate}) {
    _socket?.emit(Constants.kSocketKeyCandidateData, {
      Constants.kSocketKeyCaller: selfCallerId,
      Constants.kSocketKeyCallee: calleeId,
      Constants.kSocketKeyCandidate: candidate
    });
  }

  @override
  void sendAnswer({required String calleeId, required dynamic answer}) {
    _socket?.emit(Constants.kSocketKeyAnswerData, {
      Constants.kSocketKeyCaller: selfCallerId,
      Constants.kSocketKeyCallee: calleeId,
      Constants.kSocketKeyAnswer: answer
    });
  }

  @override
  void sendOffer({required String calleeId, required dynamic offer}) {
    _socket?.emit(Constants.kSocketKeyOfferData, {
      Constants.kSocketKeyCaller: selfCallerId,
      Constants.kSocketKeyCallee: calleeId,
      Constants.kSocketKeyOffer: offer
    });
  }
}

extension SocketConnection on SignalingClient {
  Future<void> connect({required String socketURL}) async {
    _socket = SocketIO.io(
        socketURL,
        SocketIO.OptionBuilder()
            .setQuery({Constants.kSocketKeyCaller: selfCallerId}).setTransports(
                ['websocket']).build());
    _socket?.onConnect((_) {
      AppLogger().info("$selfCallerId connected");
    });

    _socket?.on(
      Constants.kSocketKeyOfferData,
      _handleIncomingMessage,
    );
    _socket?.on(
      Constants.kSocketKeyAnswerData,
      _handleIncomingMessage,
    );
    _socket?.on(
      Constants.kSocketKeyCandidateData,
      _handleIncomingMessage,
    );

    _socket?.onError(
      (error) {
        AppLogger().error('Error received: $error');
      },
    );

    _socket?.onDisconnect(
      (data) {
        AppLogger().info("$selfCallerId disconnected");
      },
    );
  }

  void dispose() {
    _socket?.dispose();
  }
}

extension SignalingClientPrivateMethods on SignalingClient {
  void _handleIncomingMessage(dynamic message) async {
    var caller = message[Constants.kSocketKeyCaller];
    var offer = message[Constants.kSocketKeyOffer];
    var answer = message[Constants.kSocketKeyAnswer];
    var iceCandidate = message[Constants.kSocketKeyCandidate];
    if (offer != null && onReceivedOffer != null) {
      onReceivedOffer!(caller, offer);
    } else if (answer != null && onReceivedAnswer != null) {
      onReceivedAnswer!(caller, answer);
    } else if (iceCandidate != null && onReceivedIceCandidate != null) {
      onReceivedIceCandidate!(caller, iceCandidate);
    }
  }
}
