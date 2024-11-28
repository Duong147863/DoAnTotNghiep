import 'dart:convert';

import 'package:nloffice_hrm/api_services/diploma_service.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';

class DiplomasRepository {
  final DiplomaService service = DiplomaService();

  Future<List<Diplomas>> getDiplomasOf(String profileID) async {
    final response = await service.getDiplomaOf(profileID);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((x) => Diplomas.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> AddDiplomas(Diplomas diploma, Function(String) callback) async {
    try {
      final response = await service.createNewDiploma(diploma);

      if (response.statusCode == 200 || response.statusCode == 201) {
        callback('Bằng cấp đã được thêm thành công.'); // Success message
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['message'] != null) {
          callback(responseData['message']); // Pass the message to the callback
        } else {
          callback('Đã xảy ra lỗi không xác định');
        }
      }
    } catch (e) {
      callback('Lỗi: $e'); // Pass error message to callback
    }
  }

  Future<void> updateDiplomas(
      Diplomas diploma, Function(String) callback) async {
    try {
      // Gửi yêu cầu cập nhật thân nhân
      final response = await service.updateDiplomas(diploma);

      if (response.statusCode == 200) {
        callback(
            'Bằng cấp đã được cập nhật thành công.'); // Thông báo thành công
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

  Future<bool> deleteDiplomas(String diplomas) async {
    try {
      final response = await service.deleteDiplomas(diplomas);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete Trainingprocesses');
      }
    } catch (error) {
      throw Exception('Failed to delete Trainingprocesses');
    }
  }
}
