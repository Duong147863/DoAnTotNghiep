import 'dart:convert';

import 'package:nloffice_hrm/api_services/labor_contact_services.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';

class LaborContactRepository {
  final LaborContactServices service = LaborContactServices();
  Future<void> addLaborContact(
      LaborContracts laborContact, Function(String) callback) async {
    try {
      final response = await service.addNewLaborContact(laborContact);

      if (response.statusCode == 200 || response.statusCode == 201) {
        callback('Hợp đồng đã được thêm thành công.'); // Success message
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
   // Phương thức để gọi API và xử lý kết quả
  Future<LaborContracts?> getSecondContractEndTime(String profileId) async {
    try {
      final response = await service.getSecondContractEndTime(profileId);

      // Kiểm tra mã trạng thái HTTP
      if (response.statusCode == 200) {
        // Nếu thành công, parse dữ liệu JSON từ response
        final responseData = jsonDecode(response.body);

        // Kiểm tra nếu API trả về dữ liệu đúng
        if (responseData['status'] == true) {
          // Chuyển đổi dữ liệu thành đối tượng LaborContracts
          return LaborContracts.fromJson(responseData);
        } else {
          // Nếu API trả về lỗi, có thể throw exception hoặc trả về null
          return null;
        }
      } else {
        // Nếu có lỗi HTTP, throw exception
        throw Exception('Failed to load second contract end time');
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Error: $error');
      return null;
    }
  }
    Future<List<LaborContracts>> getLaborContactOf(String profileId) async {
    final response = await service.getLaborContactOf(profileId);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return List<LaborContracts>.from(
          json.decode(response.body).map((x) => LaborContracts.fromJson(x)),
        );
      } else {
        return []; // Return an empty list if no data is returned
      }
    } else {
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }

   Future<void> updateLaborContact(LaborContracts laborContact, Function(String) callback) async {
  try {
    // Gửi yêu cầu cập nhật thân nhân
    final response = await service.updateLaborContact(laborContact);

    if (response.statusCode == 200) {
      callback('Hợp đồng đã được cập nhật thành công.'); // Thông báo thành công
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

}
