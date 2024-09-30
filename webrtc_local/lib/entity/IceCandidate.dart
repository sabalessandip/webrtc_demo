class IceCandidate {
  String? id;
  int? index;
  String? candidate;

  IceCandidate(
      {required this.id, required this.index, required this.candidate});

  Map<String, dynamic> toMap() {
    return {"id": id, "index": index, "candidate": candidate};
  }

  factory IceCandidate.withMap(Map<String, dynamic> map) {
    return IceCandidate(
      id: map['id'] as String?,
      index: map['index'] as int?,
      candidate: map['candidate'] as String?,
    );
  }
}
