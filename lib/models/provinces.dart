class Province {
  final String name;
  final int code;
  final List<District> districts;

  Province({required this.name, required this.code, required this.districts});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      name: json['name'],
      code: json['code'],
      districts: (json['districts'] as List)
          .map((district) => District.fromJson(district))
          .toList(),
    );
  }
}

class District {
  final String name;
  final List<Ward> wards;

  District({required this.name, required this.wards});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      name: json['name'],
      wards: (json['wards'] as List)
          .map((ward) => Ward.fromJson(ward))
          .toList(),
    );
  }
}

class Ward {
  final String name;

  Ward({required this.name});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      name: json['name'],
    );
  }
}
