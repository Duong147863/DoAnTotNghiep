import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

class Diplomas {
  Diplomas(
      {required this.diplomaId,
      required this.diplomaName,
      required this.grantedBy,
      required this.licenseDate,
      required this.diplomaImage,
      this.ranking,
      this.major,
      this.modeOfStudy});

  String diplomaId;
  String diplomaName;
  String? modeOfStudy;
  String grantedBy;
  DateTime licenseDate;
  File diplomaImage;
  String? ranking;
  String? major;

  factory Diplomas.fromJson(Map<String, dynamic> json) => Diplomas(
        diplomaId: json["diploma_id"],
        major: json["major"],
        ranking: json["ranking"],
        diplomaName: json["diploma_degree_name"],
        licenseDate: json["license_date"],
        modeOfStudy: json["mode_of_study"],
        diplomaImage: Io.File(base64Decode(json["diploma_image"]) as String),
        grantedBy: json["granted_by"],
      );
  Map<String, dynamic> toJson() => {
        "major": major,
        "diploma_id": diplomaId,
        "license_date": licenseDate,
        "diploma_image": base64Encode(diplomaImage.readAsBytesSync()),
      };
}
