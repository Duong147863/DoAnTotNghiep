import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddLaborContractScreenKHD2 extends StatefulWidget {
  final Profiles? profiles;
  final LaborContracts? laborContracts;
  const AddLaborContractScreenKHD2(
      {super.key, this.profiles, this.laborContracts});

  @override
  State<AddLaborContractScreenKHD2> createState() =>
      _AddLaborContractScreenKHD2State();
}

class _AddLaborContractScreenKHD2State
    extends State<AddLaborContractScreenKHD2> {
  final _formKey = GlobalKey<FormState>();
  final _laborContractIDController = TextEditingController();
  final _profileNameController = TextEditingController();
  final _startTimeHopDongController = TextEditingController();
  final _endTimeHopDongController = TextEditingController();
  DateTime _startTimeHopDong = DateTime.now();
  DateTime _endTimeHopDong = DateTime.now();
  DateTime endTimeHopDong1 = DateTime.now();
  String? _laborContractImageBase64;
  int? statusProfile;
  String? profileId;
  FocusNode _mahdFocusNode = FocusNode();
  FocusNode _starttimeFocusNode = FocusNode();
  FocusNode _endtimeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    profileId = widget.profiles!.profileId;
    _profileNameController.text = widget.profiles!.profileName;
    statusProfile = widget.profiles!.profileStatus;
    endTimeHopDong1 = widget.laborContracts!.endTime!;
    if (statusProfile == 2) {
      // Gán startTime hợp đồng lần 3 bằng endTime của hợp đồng lần 2
      _startTimeHopDong = endTimeHopDong1;
      _startTimeHopDongController.text =
          DateFormat('dd/MM/yyyy').format(endTimeHopDong1);
    }
    if (statusProfile == 1) {
      // Gán startTime hợp đồng lần 3 bằng endTime của hợp đồng lần 2
      _startTimeHopDong = endTimeHopDong1;
      _startTimeHopDongController.text =
          DateFormat('dd/MM/yyyy').format(endTimeHopDong1);
    }
    // Focus
    _mahdFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_mahdFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _starttimeFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_starttimeFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus

    _endtimeFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_endtimeFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (imageFile != null) {
      File file = File(imageFile.path);
      String base64String = await AppStrings.ImagetoBase64(file);
      setState(() {
        _laborContractImageBase64 = base64String;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Kiểm tra ngày bắt đầu của hợp đồng mới
      if (_startTimeHopDong.isBefore(endTimeHopDong1)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Ngày bắt đầu hợp đồng không được trước ngày kết thúc hợp đồng trước đó.')));
        return; // Dừng lại nếu không hợp lệ
      }

      // Nếu có hợp đồng trước, kiểm tra thêm ngày kết thúc hợp đồng mới
      if (_endTimeHopDong.isBefore(_startTimeHopDong)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Ngày kết thúc hợp đồng không thể trước ngày bắt đầu hợp đồng.')));
        return; // Dừng lại nếu không hợp lệ
      }
      if (_laborContractImageBase64 == null) {
        // Hiển thị thông báo lỗi nếu chưa chọn ảnh
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn ảnh trước khi gửi!')),
        );
        return;
      }
      final newLaborContact = LaborContracts(
        profiles: profileId!,
        laborContractId: _laborContractIDController.text,
        startTime: _startTimeHopDong,
        endTime:
            _endTimeHopDongController.text.isNotEmpty ? _endTimeHopDong : null,
        image: _laborContractImageBase64 ?? "",
      );

      // Gọi phương thức để thêm hợp đồng mới
      Provider.of<LaborContactsViewModel>(context, listen: false)
          .addNewLaborContact(newLaborContact, (message) {
        if (message == 'Hợp đồng đã được thêm thành công.') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context, newLaborContact); // Đóng màn hình
          Navigator.pop(context, newLaborContact); // Đóng màn hình
          Navigator.pop(context, newLaborContact); // Đóng màn hình
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1960),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBarColor: AppColor.primaryLightColor,
      titletext: 'Tạo Hợp Đồng Lao Động',
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          image: _laborContractImageBase64 != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                      base64Decode(_laborContractImageBase64!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _laborContractImageBase64 == null
                            ? Icon(Icons.add_a_photo, size: 50)
                            : null,
                      ),
                    ),
                  ).px8(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      CustomTextFormField(
                        focusNode: _mahdFocusNode,
                        textEditingController: _laborContractIDController,
                        labelText: 'Mã hợp đồng',
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được\nđể trống';
                          } else if (value.length > 10) {
                            return 'Mã hợp đồng\nkhông được vượt quá 10 ký tự';
                          } else if (!value.startsWith('HD-')) {
                            return 'Mã hợp đồng\nphải bắt đầu\nbằng "HD-"';
                          } else if (!RegExp(r'^HD-\d+$').hasMatch(value)) {
                            return 'Sau "HD-" phải\nlà số';
                          }
                          return null;
                        },
                      ).px8().w(150),
                      CustomTextFormField(
                        textEditingController: _profileNameController,
                        labelText: 'Họ và tên',
                        enabled: false,
                        maxLength: 50,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống';
                          }
                          // Kiểm tra không có khoảng trắng ở cuối tên
                          if (value.trim() != value) {
                            return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                          }
                          if (value.length < 4) {
                            return 'Họ và Tên phải có ít nhất 4 ký tự';
                          }
                          // Regex kiểm tra ký tự đặc biệt
                          final nameRegex = RegExp(
                              r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                          if (!nameRegex.hasMatch(value.trim())) {
                            return 'Họ và Tên không được chứa ký tự đặc biệt';
                          }

                          // Kiểm tra và chuyển chữ cái đầu tiên của mỗi từ thành chữ hoa
                          List<String> words = value.split(" ");
                          for (int i = 0; i < words.length; i++) {
                            // Chuyển chữ cái đầu tiên của mỗi từ thành chữ hoa
                            words[i] = words[i].substring(0, 1).toUpperCase() +
                                words[i].substring(1).toLowerCase();
                          }
                          String capitalizedName = words.join(" ");

                          // Kiểm tra xem tên có đúng định dạng hay không (chữ cái đầu tiên mỗi từ viết hoa)
                          if (value != capitalizedName) {
                            return 'Chữ cái đầu tiên của mỗi từ phải viết hoa. Ví dụ: Nguyễn Bình Dương';
                          }
                          if (!value.isLetter()) {
                            return 'Tên chỉ gồm chữ';
                          }
                          return null;
                        },
                      ).w(170),
                    ],
                  ),
                  SizedBox(height: 16),
                 
                      Padding(
                           padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _buildDateStartTime(
                          'Thời hạn hợp đồng từ:',
                          _startTimeHopDongController,
                          _startTimeHopDong,
                          (date) {
                            setState(() {
                              _startTimeHopDong = date;
                              _startTimeHopDongController.text =
                                  "${_startTimeHopDong.toLocal()}"
                                      .split(' ')[0];
                            });
                          },
                        ),
                      ).p(8),
              
                      Padding(
                           padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _buildDateEndTimeWithClearButton(
                          'Đến',
                          _endTimeHopDongController,
                          _endTimeHopDong,
                          (date) {
                            setState(() {
                              _endTimeHopDong = date!;
                              _endTimeHopDongController.text =
                                  "${_endTimeHopDong.toLocal()}".split(' ')[0];
                            });
                          },
                        ),
                      ).p(8),
                  
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      child: Text('Tạo hợp đồng'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateStartTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _startTimeHopDong = selectedDate; // Cập nhật giá trị
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập ngày bắt\nđầu hợp đồng';
            }
            try {
              DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(value);

              // Kiểm tra ngày bắt đầu hợp đầu 1 không được trước ngày kết thúc hợp đồng 1
              if (selectedDate.isBefore(endTimeHopDong1)) {
                return 'Ngày bắt đầu hợp đồng\nphải sau ngày '
                    '${DateFormat('dd/MM/yyyy').format(endTimeHopDong1)}';
              }

              // Kiểm tra ngày không được trong quá khứ
              if (selectedDate.isBefore(DateTime.now())) {
                return 'Ngày bắt đầu hợp đồng\n không được trong quá khứ';
              }
            } catch (e) {
              return 'Định dạng ngày không hợp lệ';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  // Widget _buildDateEndTime(String label, TextEditingController controller,
  //     DateTime initialDate, Function(DateTime) onDateSelected) {
  //   return GestureDetector(
  //     onTap: () => _selectDate(context, initialDate, (selectedDate) {
  //       onDateSelected(selectedDate);
  //       setState(() {
  //         _endTimeHopDong = selectedDate; // Cập nhật giá trị endTimeư
  //         controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
  //       });
  //     }),
  //     child: AbsorbPointer(
  //       child: TextFormField(
  //         readOnly: true,
  //         style: TextStyle(color: Colors.black),
  //         controller: controller,
  //         validator: (value) {
  //           // Validator kiểm tra ràng buộc hợp đồng lần 1
  //           if (value == null || value.isEmpty) {
  //             return 'Vui lòng chọn ngày kết thúc hợp đồng';
  //           }
  //           try {
  //             DateTime selectedEndTime = DateFormat('dd/MM/yyyy').parse(value);

  //             // Kiểm tra ngày kết thúc phải sau ngày bắt đầu ít nhất 1 tháng
  //             if (selectedEndTime.isBefore(_startTimeHopDong.add(Duration(days: 365)))) {
  //                 return 'Ngày kết thúc phải sau\nngày bắt đầu ít nhất\n1 năm';
  //             }

  //             // Kiểm tra ngày kết thúc không được vượt quá 36 tháng từ ngày bắt đầu
  //             if (selectedEndTime.isAfter(_startTimeHopDong.add(Duration(days: 36 * 30)))) {
  //                 return 'Ngày kết thúc không\nđược vượt quá 36 tháng\nkể từ ngày bắt đầu';
  //             }
  //           } catch (e) {
  //             return 'Định dạng ngày không hợp lệ';
  //           }
  //           return null; // Hợp lệ
  //         },
  //         decoration: InputDecoration(
  //           labelText: label,
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  //         ),
  //       ),
  //     ),
  //   );
  // }
//   Widget _buildDateEndTime(
//   String label,
//   TextEditingController controller,
//   DateTime initialDate,
//   Function(DateTime) onDateSelected) {
//   return GestureDetector(
//     onTap: () => _selectDate(context, initialDate, (selectedDate) {
//       onDateSelected(selectedDate);
//       setState(() {
//         _endTimeHopDong = selectedDate; // Cập nhật giá trị
//         controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
//       });
//     }),
//     child: AbsorbPointer(
//       child: TextFormField(
//         readOnly: true,
//         style: TextStyle(color: Colors.black),
//         controller: controller,
//         validator: (value) {
//           if (statusProfile == 1 && (value == null || value.isEmpty)) {
//             return 'Ngày kết thúc hợp đồng là\nbắt buộc khi tạo hợp đồng\nlần 2';
//           } else if (statusProfile == 2 && value != null && value.isNotEmpty) {
//             return 'Ngày kết thúc hợp đồng\nkhông được phép nhập khi\ntạo hợp đồng lần 3';
//           }
//           // Kiểm tra ngày kết thúc hợp đồng hợp lệ nếu có
//           if (value != null && value.isNotEmpty) {
//             try {
//               DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(value);
//               if (selectedDate.isBefore(_startTimeHopDong)) {
//                 return 'Ngày kết thúc hợp đồng\nkhông thể trước ngày bắt đầu\nhợp đồng';
//               }

//               // Kiểm tra thời gian kết thúc hợp đồng tối thiểu 12 tháng và tối đa 36 tháng
//               Duration duration = selectedDate.difference(_startTimeHopDong);
//               if (duration.inDays < 365 || duration.inDays > 1080) { // 12 tháng = 365 ngày, 36 tháng = 1095 ngày
//                 return 'Ngày kết thúc hợp đồng phải\ntrong khoảng từ 12 đến 36\ntháng kể từ ngày bắt đầu';
//               }
//             } catch (e) {
//               return 'Ngày kết thúc không hợp lệ';
//             }
//           }
//           return null;
//         },
//       ),
//     ),
//   );
// }
  Widget _buildDateEndTimeWithClearButton(
    String label,
    TextEditingController controller,
    DateTime? initialDate,
    Function(DateTime?) onDateSelected,
  ) {
    return Row(
      children: [
        // Trường nhập ngày với GestureDetector
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(
              context,
              initialDate ?? DateTime.now(),
              (selectedDate) {
                onDateSelected(selectedDate);
                setState(() {
                  _endTimeHopDong = selectedDate;
                  controller.text = selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate)
                      : '';
                });
              },
            ),
            child: AbsorbPointer(
              child: TextFormField(
                focusNode: _endtimeFocusNode,
                readOnly: true,
                style: TextStyle(color: Colors.black),
                controller: controller,
                validator: (value) {
                  if (statusProfile == 1 && (value == null || value.isEmpty)) {
                    return 'Ngày kết thúc hợp đồng là\nbắt buộc khi tạo hợp đồng\nlần 2';
                  } else if (statusProfile == 2 &&
                      value != null &&
                      value.isNotEmpty) {
                    return 'Ngày kết thúc\nhợp đồng không\nđược phép nhập\nkhi tạo hợp đồng\nlần 3';
                  }
                  // Kiểm tra ngày kết thúc hợp đồng hợp lệ nếu có
                  if (value != null && value.isNotEmpty) {
                    try {
                      DateTime selectedDate =
                          DateFormat('dd/MM/yyyy').parse(value);
                      if (selectedDate.isBefore(_startTimeHopDong)) {
                        return 'Ngày kết thúc hợp đồng\nkhông thể trước ngày bắt đầu\nhợp đồng';
                      }

                      // Kiểm tra thời gian kết thúc hợp đồng tối thiểu 12 tháng và tối đa 36 tháng
                      Duration duration =
                          selectedDate.difference(_startTimeHopDong);
                      if (duration.inDays < 365 || duration.inDays > 1080) {
                        // 12 tháng = 365 ngày, 36 tháng = 1095 ngày
                        return 'Ngày kết thúc hợp đồng phải\ntrong khoảng từ 12 đến 36\ntháng kể từ ngày bắt đầu';
                      }
                    } catch (e) {
                      return 'Ngày kết thúc không hợp lệ';
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Nút xóa ngày
        IconButton(
          onPressed: () {
            setState(() {
              controller.clear(); // Xóa nội dung TextFormField
            });
          },
          icon: Icon(Icons.clear, color: Colors.red),
          tooltip: 'Xóa ngày kết thúc',
        ),
      ],
    );
  }
}
