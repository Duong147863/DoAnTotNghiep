import 'dart:convert';

import 'package:nloffice_hrm/api_services/trainingprocesses_service.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';

class TrainingprocessesRepository {
  final TrainingprocessesService service = TrainingprocessesService();

  Future<List<Trainingprocesses>> getTrainingProcessesOf(
      String profileID) async {
    final response = await service.getTrainingProcessesOf(profileID);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => Trainingprocesses.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

    Future<bool> createTrainingProcesses(Trainingprocesses trainingprocesses, Function(String) callback) async {
  try {
    final response = await service.createTrainingProcesses(trainingprocesses,callback);
    if (response.statusCode == 200 || response.statusCode == 201) {
      callback('Quá trình đào tạo đã được thêm thành công.');  // Success message
      return true;
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] != null) {
        
        callback(responseData['message']);  // Pass the message to the callback
        return false;
      } else {
        callback('Đã xảy ra lỗi không xác định');
         return false;
      }
    }
  } catch (e) {
    callback('Lỗi: $e');  // Pass error message to callback
     return false;
  }
}

  Future<void> updateTrainingProcesses(
     Trainingprocesses trainingprocesses, Function(String) callback) async {
    try {
      // Gửi yêu cầu cập nhật thân nhân
      final response = await service.updateTrainingProcesses(trainingprocesses);

      if (response.statusCode == 200) {
         print("Add successful. Response body: ${response.body}");
        callback(
            'Quá trình đào tạo đã được cập nhật thành công!'); // Thông báo thành công
      } else {
        // Giải mã nội dung phản hồi
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
            print("Failed to delete Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
          callback(responseData['message']); // Hiển thị thông báo lỗi từ API
        } else {
            print("Failed to delete Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
          callback('Đã xảy ra lỗi không xác định'); // Thông báo lỗi chung chung
        }
      }
    } catch (e) {
      callback('Lỗi: $e'); // Thông báo lỗi ngoại lệ
    }
  }

  Future<bool> deleteTrainingProcesses(int trainingprocessesId) async {
    try {
      final response =
          await service.deleteTrainingProcesses(trainingprocessesId);
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
