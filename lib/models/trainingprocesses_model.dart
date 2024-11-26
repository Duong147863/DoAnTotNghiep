import 'package:easy_localization/easy_localization.dart';

class Trainingprocesses {
  Trainingprocesses({
    required this.profileId,
    this.trainingprocessesId,
    required this.trainingprocessesName,
    required this.trainingprocessesContent,
    required this.startTime,
    this.endTime,
    this.isExpanded = false,
  });
  String profileId;
  String? trainingprocessesId;
  String trainingprocessesName;
  String trainingprocessesContent;
  DateTime startTime;
  DateTime? endTime;
  bool isExpanded;
  factory Trainingprocesses.fromJson(Map<String, dynamic> json) {
    return Trainingprocesses(
      profileId: json["profile_id"],
      trainingprocessesId: json["trainingprocesses_id"],
      trainingprocessesName: json["trainingprocesses_name"],
      trainingprocessesContent: json["trainingprocesses_content"],
      startTime: DateTime.parse(json['start_time']),
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_id"] = profileId;
    map["trainingprocesses_id"] = trainingprocessesId;
    map["trainingprocesses_name"] = trainingprocessesName;
    map["trainingprocesses_content"] = trainingprocessesContent;
    map["start_time"] = DateFormat("dd-MM-yyyy").format(startTime);
    if (endTime != null) {
      map["end_time"] = DateFormat("dd-MM-yyyy").format(endTime!);
    } else {
      map["end_time"] = null;
    }
    return map;
  }
}
