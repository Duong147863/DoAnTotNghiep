import 'package:easy_localization/easy_localization.dart';

class WorkingProcesses {
  WorkingProcesses(
      { this.workingprocessId,
      required this.profileId,
      required this.workplaceName,
      this.workingprocessContent,
      required this.startTime,
      this.endTime,
      this.isExpanded = false,});
  int? workingprocessId;
  String profileId;
  String workplaceName;
  String? workingprocessContent;
  DateTime startTime;
  DateTime? endTime;
  bool isExpanded;
  factory WorkingProcesses.fromJson(Map<String, dynamic> json) {
    return WorkingProcesses(
      workingprocessId: json["workingprocess_id"],
      profileId: json["profile_id"],
      workplaceName: json["workplace_name"],
      workingprocessContent: json["workingprocess_content"],
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'])
          : null,
   
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["workingprocess_id"] = workingprocessId;
    map["profile_id"] = profileId;
    map["workplace_name"] = workplaceName;
    map["workingprocess_content"] = workingprocessContent;
    map["start_time"] = DateFormat("dd-MM-yyyy").format(startTime);
    if (endTime != null) {
      map["end_time"] = DateFormat("dd-MM-yyyy").format(endTime!);
    } else {
      map["end_time"] = null; 
    }
    return map;
  }
}
 
