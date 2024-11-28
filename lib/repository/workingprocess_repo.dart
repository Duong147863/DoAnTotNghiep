import 'dart:convert';

import 'package:nloffice_hrm/api_services/workingprocess_service.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';

class WorkingprocessRepository {
  final WorkingprocessService service = WorkingprocessService();

  Future<List<WorkingProcesses>> fetchWorkingProcessesOf(
      String profileID) async {
    final response = await service.getWorkingProcessOf(profileID);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => WorkingProcesses.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createNewWorkingprocess(
      WorkingProcesses workingprocess, Function(String) callback) async {
    try {
      final response = await service.createNewWorkingprocess(workingprocess);
      if (response.statusCode == 200 || response.statusCode == 201) {
        callback(
            'Quá trình công tác đã được thêm thành công.'); // Success message
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

  Future<void> updateWorkingprocess(
      WorkingProcesses workingprocess, Function(String) callback) async {
    try {
      // Gửi yêu cầu cập nhật thân nhân
      final response = await service.updateWorkingprocess(workingprocess);

      if (response.statusCode == 200) {
        callback(
            'Quá trình công tác đã được cập nhật thành công!'); // Thông báo thành công
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

  Future<bool> deleteWorkingprocess(int workingprocessId) async {
    try {
      final response = await service.deleteWorkingprocess(workingprocessId);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete Workingprocess');
      }
    } catch (error) {
      throw Exception('Failed to delete Workingprocess');
    }
  }
}
