class WorkingProcesses {
  WorkingProcesses(
      {required this.workingprocessId,
      required this.profileId,
      this.workplaceName,
      this.workingprocessContent,
      required this.workingprocessStarttime,
      this.workingprocessEndtime,
      required this.workingprocessStatus});
  String workingprocessId;
  String profileId;
  String? workplaceName;
  String? workingprocessContent;
  DateTime workingprocessStarttime;
  DateTime? workingprocessEndtime;
  int workingprocessStatus;
  factory WorkingProcesses.fromJson(Map<String, dynamic> json) {
    return WorkingProcesses(
      workingprocessId: json["workingprocess_id "],
      profileId: json["profile_id "],
      workplaceName: json["workplace_name"],
      workingprocessContent: json["workingprocess_content"],
      workingprocessStarttime: json["workingprocess_starttime"],
      workingprocessEndtime: json["workingprocess_endtime"],
      workingprocessStatus: json["workingprocess_status"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["workingprocess_id"] = workingprocessId;
    map["profile_id"] = profileId;
    map["workplace_name"] = workplaceName;
    map["workingprocess_content"] = workingprocessContent;
    map["workingprocess_starttime"] = workingprocessStarttime;
    map["workingprocess_endtime"] = workingprocessEndtime;
    map["workingprocess_status"] = workingprocessStatus;
    return map;
  }
}
