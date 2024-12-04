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

  class AddLaborContractScreen extends StatefulWidget {
    final Profiles? profiles;
    const AddLaborContractScreen({super.key, this.profiles});

    @override
    State<AddLaborContractScreen> createState() => _AddLaborContractScreenState();
  }

  class _AddLaborContractScreenState extends State<AddLaborContractScreen> {
    final _formKey = GlobalKey<FormState>();
    final _laborContractIDController = TextEditingController();
    final _profileNameController = TextEditingController();
    final _startTimeHopDongController = TextEditingController();
    final _endTimeHopDongController = TextEditingController();
    DateTime _startTimeHopDong = DateTime.now();
    DateTime _endTimeHopDong = DateTime.now();
    DateTime endTimeThuViec = DateTime.now();
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
      endTimeThuViec = widget.profiles!.endTime!;
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
        Provider.of<LaborContactsViewModel>(context, listen: false)
            .addNewLaborContact(newLaborContact, (message) {
          if (message == 'Hợp đồng đã được thêm thành công.') {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
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
    void _showConfirmationDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // Không cho phép người dùng đóng dialog bằng cách nhấn ngoài
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Kiểm tra lại dữ liệu'),
        content: Text('Vui lòng kiểm tra tất cả thông tin trước khi tạo hợp đồng.'),
        actions: <Widget>[
          TextButton(
            child: Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog khi nhấn Hủy
            },
          ),
          TextButton(
            child: Text('Xác nhận'),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog khi nhấn Xác nhận
              _submit(); // Gọi hàm submit để tiếp tục tạo hợp đồng
            },
          ),
        ],
      );
    },
  );
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
                                ? DecorationImage (
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
                    Row(
                      children: [
                        Expanded(
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
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDateEndTime(
                            'Đến',
                            _endTimeHopDongController,
                            _endTimeHopDong,
                            (date) {
                              setState(() {
                                _endTimeHopDong = date;
                                _endTimeHopDongController.text =
                                    "${_endTimeHopDong.toLocal()}".split(' ')[0];
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog();
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
                // Kiểm tra trạng thái hồ sơ
                if (statusProfile != 0) {
                  return 'Hồ sơ không trong trạng thái thử việc để ký hợp đồng lần 1';
                }
                String formattedDate = DateFormat('dd/MM/yyyy').format(endTimeThuViec);
                // Kiểm tra ngày bắt đầu hợp đầu 1 không được trước ngày kết thúc thử việc
                if (selectedDate.isBefore(endTimeThuViec)) {
                  return 'Ngày bắt đầu hợp đồng\nphải sau ngày ''$formattedDate';
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

  Widget _buildDateEndTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _endTimeHopDong = selectedDate; // Cập nhật giá trị endTimeư
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            // Validator kiểm tra ràng buộc hợp đồng lần 1
            if (value == null || value.isEmpty) {
              return 'Vui lòng chọn ngày kết\nthúc hợp đồng';
            }
            try {
              DateTime selectedEndTime = DateFormat('dd/MM/yyyy').parse(value);

              // Kiểm tra ngày kết thúc phải sau ngày bắt đầu ít nhất 1 tháng
              if (selectedEndTime.isBefore(_startTimeHopDong.add(Duration(days: 365)))) {
                return 'Ngày kết thúc phải sau\nngày bắt đầu ít nhất\n1 năm';
              }

              // Kiểm tra ngày kết thúc không được vượt quá 36 tháng từ ngày bắt đầu
              if (selectedEndTime.isAfter(_startTimeHopDong.add(Duration(days: 36 * 30)))) {
                return 'Ngày kết thúc không\nđược vượt quá 36 tháng\nkể từ ngày bắt đầu';
              }
            } catch (e) {
              return 'Định dạng ngày không hợp lệ';
            }
            return null; // Hợp lệ
          },
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
  }
