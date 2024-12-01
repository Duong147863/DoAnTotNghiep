import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/provinces.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:provider/provider.dart';

class AddProvinces extends StatefulWidget {
  const AddProvinces({super.key});

  @override
  State<AddProvinces> createState() => _AddProvincesState();
}

class _AddProvincesState extends State<AddProvinces> {
  late Future<List<Province>> futureProvinces;
  List<Province> provinces = [];
  List<District> filteredDistricts = [];
  District? selectedDistrict;
  Ward? selectedWard;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Thêm GlobalKey cho Form

  @override
  void initState() {
    super.initState();
    futureProvinces =
        Provider.of<ProfilesViewModel>(context, listen: false).fetchProvinces();
    loadProvinces();
  }

  Future<void> loadProvinces() async {
    final data = await futureProvinces;
    setState(() {
      provinces = data;
      filteredDistricts =
          provinces.expand((province) => province.districts).toList();
    });
  }

  void filterDistricts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredDistricts =
            provinces.expand((province) => province.districts).toList();
      });
      return;
    }

    setState(() {
      filteredDistricts =
          provinces.expand((province) => province.districts).where((district) {
        final province = provinces
            .firstWhere((province) => province.districts.contains(district));
        final combinedName = "${province.name} ${district.name}".toLowerCase();
        return combinedName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn địa điểm')),
      body: provinces.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thanh tìm kiếm
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Tìm kiếm quận/huyện',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: filterDistricts,
                  ),
                  const SizedBox(height: 16),
                  // Danh sách quận/huyện
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDistricts.length,
                      itemBuilder: (context, index) {
                        final district = filteredDistricts[index];
                        final province = provinces.firstWhere((province) =>
                            province.districts.contains(district));
                        return ListTile(
                          title: Text(
                            "${province.name} - ${district.name}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            setState(() {
                              selectedDistrict = district;
                              selectedWard = null; // Reset phường
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Hiển thị tỉnh/quận và phường đã chọn
                  if (selectedDistrict != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Đang chọn: ${selectedDistrict!.name}, ${provinces.firstWhere((province) => province.districts.contains(selectedDistrict!)).name}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Dropdown danh sách phường
                  if (selectedDistrict != null)
                    DropdownButtonFormField<Ward>(
                      value: selectedWard,
                      hint: const Text("Chọn phường"),
                      items: selectedDistrict?.wards.map((ward) {
                        return DropdownMenuItem<Ward>(
                          value: ward,
                          child: Text(
                            ward.name,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWard = value;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  // Nhập địa chỉ chi tiết
                  if (selectedWard != null)
                    Form(
                      key: _formKey,
                      child: TextFormField(
  controller: _addressController,
  decoration: const InputDecoration(
    labelText: 'Địa chỉ',
    border: OutlineInputBorder(),
  ),
  maxLength: 50, // Giới hạn tối đa 50 ký tự
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    // Kiểm tra nếu địa chỉ chứa số nhà và tên đường
    // Số nhà phải có ít nhất một chữ số, và tên đường phải chứa ít nhất một chữ cái
    final addressRegex = RegExp(r'^\d+\s[a-zA-Z\s]+');
    if (!addressRegex.hasMatch(value)) {
      return 'Địa chỉ phải bao gồm số nhà và tên đường';
    }

    // Kiểm tra không có ký tự đặc biệt không hợp lệ
    final nameRegex = RegExp(
      r"^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẵẳặẵÉẾỀỂỆỄêềễệéỆỆÊëẺỆĩíịỉòỏọọụủūăâăấầẩẫậơờởỡợƠƠớửủứửỰữựýỳỵỷỹ\s\/\-]+$"
    );
    if (!nameRegex.hasMatch(value)) {
      return 'Địa chỉ không được chứa ký tự đặc biệt';
    }

    // Kiểm tra chiều dài địa chỉ không vượt quá 50 ký tự
    if (value.length > 50) {
      return 'Địa chỉ không được vượt quá 50 ký tự';
    }

    return null;
  },
),
                    ),
                  const SizedBox(height: 16),
                  // Nút xác nhận
                  if (selectedWard != null)
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (selectedWard != null &&
                              selectedDistrict != null &&
                              provinces.isNotEmpty) {
                            final province = provinces.firstWhere((province) =>
                                province.districts.contains(selectedDistrict));

                            final addressDetail =
                                _addressController.text.trim();
                            final fullAddress = addressDetail.isNotEmpty
                                ? "$addressDetail, ${selectedWard!.name}, ${selectedDistrict!.name}, ${province.name}"
                                : "${selectedWard!.name}, ${selectedDistrict!.name}, ${province.name}";

                            Navigator.pop(context, fullAddress);
                          }
                        }
                      },
                      child: const Text("Lưu"),
                    ),
                ],
              ),
            ),
    );
  }
}
