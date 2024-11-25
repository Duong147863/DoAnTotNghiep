import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nloffice_hrm/api_services/relative_service.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';

class RelativesRepository {
  final RelativeService service = RelativeService();

  Future<List<Relatives>> fetchAllRelatives(String profileId) async {
    final response = await service.getAllRelative(profileId);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return List<Relatives>.from(
          json.decode(response.body).map((x) => Relatives.fromJson(x)),
        );
      } else {
        return []; // Return an empty list if no data is returned
      }
    } else {
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }
  Future<void> addRelative(Relatives relatives, Function(String) callback) async {
  try {
    final response = await service.createNewRelative(relatives);

    if (response.statusCode == 200 || response.statusCode == 201) {
      callback('Thân nhân đã được thêm thành công!');  // Success message

    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] != null) {
        callback(responseData['message']);  // Pass the message to the callback
      } else {
        callback('Đã xảy ra lỗi không xác định');
      }
    }
  } catch (e) {
    callback('Lỗi: $e');  // Pass error message to callback
  }
}

  Future<void> updateRelative(Relatives relatives, Function(String) callback) async {
  try {
    // Gửi yêu cầu cập nhật thân nhân
    final response = await service.updateRelative(relatives);

    if (response.statusCode == 200) {
      callback('Thân nhân đã được cập nhật thành công!'); // Thông báo thành công
    } else {
      // Giải mã nội dung phản hồi
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] != null) {
        callback(responseData['message']); // Hiển thị thông báo lỗi từ API
      } else {
        callback('Đã xảy ra lỗi không xác định'); // Thông báo lỗi chung chung
      }
    }
  } catch (e) {
    callback('Lỗi: $e'); // Thông báo lỗi ngoại lệ
  }
}

  Future<bool> deleteRelative(int relativesId) async {
    try {
      final response = await service.deleteRelative(relativesId);
      if (response.statusCode == 200) {
        return true;
      } else {
      
        return false; 
      }
    } catch (error) {
      throw Exception('Failed to delete Relative');
    }
  }
}
