class Trainingprocesses{
  Trainingprocesses({
    required this.profileId,
    required this.trainingprocessesId,
    required this.trainingprocessesContent,
    required this.trainingprocessesStatus,
    required this.startTime,
    required this.endTime,
  });
  String profileId;
  String trainingprocessesId;
  String trainingprocessesContent;
  int trainingprocessesStatus;
  DateTime startTime;
  DateTime endTime;
  factory Trainingprocesses.fromJson(Map<String, dynamic> json) {
    return Trainingprocesses(
      profileId: json["profile_id"],
      trainingprocessesId: json["trainingprocesses_id"],
      trainingprocessesContent: json["trainingprocesses_content"],
      trainingprocessesStatus: json["trainingprocesses_status"],
      startTime: json["start_time"],
      endTime: json["end_time"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_id"] = profileId;
    map["trainingprocesses_id"] = trainingprocessesId;
    map["trainingprocesses_content"] = trainingprocessesContent;
    map["trainingprocesses_status"] = trainingprocessesStatus;
    map["start_time"] = startTime;
    map["end_time"] = endTime;
    return map;
  }
}