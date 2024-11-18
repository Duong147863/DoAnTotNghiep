import 'dart:convert';
import 'dart:ffi';

class Hirings{
  Hirings({
    required this.hiringProfileId,
    required this.profileName,
    required this.birthday,
    required this.placeOfBirth,
    required this.gender,
    required this.phone,
    this.email,
    required this.nation,
    required this.applyFor,
    required this.educationalLevel,
    required this.currentAddress,
    required this.hiringStatus,
    this.hiringProfileImage,
    required this.workExperience,
  });
  int hiringProfileId;
  String profileName;
  DateTime birthday;
  String placeOfBirth;
  int gender;
  String phone;
  String ? email;
  String nation;
  String applyFor;
  String educationalLevel;
  String currentAddress;
  int hiringStatus;
  String ? hiringProfileImage;
  String  workExperience;

   factory Hirings.fromJson(Map<String, dynamic> json) {
    return Hirings(
      hiringProfileId: json["hiring_profile_id"],
      profileName: json["profile_name"],
      birthday: DateTime.parse(json["birthday"]),
      placeOfBirth: json["place_of_birth"],
      gender: json["gender"],
      phone: json["phone"],
      email: json["email"],
      nation: json["nation"],
      applyFor: json["apply_for"],
      educationalLevel: json["educational_level"],
      currentAddress: json["current_address"],
      hiringStatus: json["hiring_status"],
      hiringProfileImage: json["hiring_profile_image"],
      workExperience: json["work_experience"],
    );
  }
}
