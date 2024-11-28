import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/repository/labor_contact_repo.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';

class LaborContactsViewModel extends ChangeNotifier {
  final LaborContactRepository repository = LaborContactRepository();
  final ProfilesViewModel profilesViewModel= ProfilesViewModel();
  List<LaborContracts> _list = [];
  bool fetchingData = false;
  List<LaborContracts> get listLaborContact => _list;

    Future<void> getSecondContractEndTime(String profileId) async {
    try {
      fetchingData = true;  // Đang tải dữ liệu
      notifyListeners();

      // Gọi repository để lấy dữ liệu
      LaborContracts? contract = await repository.getSecondContractEndTime(profileId);

      // Kiểm tra nếu có hợp đồng lần 2
      if (contract != null) {
        _list = [contract];  // Cập nhật danh sách hợp đồng
      } else {
        _list = [];  // Không có hợp đồng lần 2
      }

      fetchingData = false;  // Dừng trạng thái tải dữ liệu
      notifyListeners();  // Cập nhật UI
    } catch (error) {
      fetchingData = false;  // Dừng trạng thái tải dữ liệu
      notifyListeners();  // Cập nhật UI

      // Xử lý lỗi (in ra console hoặc thông báo lỗi tùy ý)
      print("Error fetching second contract end time: $error");
      // Bạn có thể thêm logic xử lý lỗi tùy thích ở đây.
    }
  }
      // Modify addRelative method to accept a callback for success messages
  Future<void> addNewLaborContact(LaborContracts laborContact, Function(String) callback) async {
    try {
      await repository.addLaborContact(laborContact,callback); // Call the repository method
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }
    Future<void> getLaborContactOf(String profileId) async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.getLaborContactOf(profileId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
  Future<void> updateLaborContact(LaborContracts laborContact, Function(String) callback) async {
    try {
      await repository.updateLaborContact(laborContact,callback);
      int index =
          _list.indexWhere((lab) => lab.laborContractId == laborContact.laborContractId);
      if (index != -1) {
        _list[index] = laborContact;
        notifyListeners();
      }
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }
}
