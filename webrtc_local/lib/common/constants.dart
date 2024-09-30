abstract class Constants {
  static String kSocketServerHost = "192.168.1.3";
  static int kSocketServerPort = 3000;
  static String kSocketServerURL = "ws://$kSocketServerHost:$kSocketServerPort";
  static String kSocketKeyCallee = "calleeId";
  static String kSocketKeyCaller = "callerId";
  static String kSocketKeyCandidate = "candidate";
  static String kSocketKeyOffer = "offer";
  static String kSocketKeyAnswer = "answer";
  static String kSocketKeyCandidateData = "candidate-data";
  static String kSocketKeyOfferData = "offer-data";
  static String kSocketKeyAnswerData = "answer-data";
  static int kMaxCallerIdLength = 6;
}
