import 'dart:convert';

abstract class Encoder {
  static String encode(String sdp) {
    return base64Encode(utf8.encode(sdp));
  }

  static String decode(String encodedSDP) {
    return utf8.decode(base64Decode(encodedSDP));
  }
}
