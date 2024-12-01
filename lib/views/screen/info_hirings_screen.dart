import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/department_position_model.dart';
import 'package:nloffice_hrm/models/hirings_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/hirings_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_provinces.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoHiringsScreen extends StatefulWidget {
  final Hirings? hirings;
  const InfoHiringsScreen({super.key, this.hirings});

  @override
  State<InfoHiringsScreen> createState() => _InfoHiringsScreenState();
}

class _InfoHiringsScreenState extends State<InfoHiringsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationController = TextEditingController();
  final _applyForController = TextEditingController();
  final _educationalLevelController = TextEditingController();
  final _currentAddressController = TextEditingController();
  final _workExperienceController = TextEditingController();
  DateTime _birthday = DateTime.now();
  bool _gender = false; // Assuming `false` is Male, `true` is Female
  String? _hiringProfileImageBase64;
  int status = 0;
  bool _isEditing = false;
  FocusNode _profileNameFocusNode = FocusNode();
  FocusNode _birthdayFocusNode = FocusNode();
  FocusNode _placeOfBirthFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _nationFocusNode = FocusNode();
  FocusNode _applyForFocusNode = FocusNode();
  FocusNode _educationalLevelFocusNode = FocusNode();
  FocusNode _workExperienceFocusNode = FocusNode();
  FocusNode _thuongtruFocusNode = FocusNode();
  final idHiringsController = TextEditingController();
  List<DepartmentPosition> departmentsPosition = [];
  DepartmentPosition? selectedDepartmentsPosition;
  @override
  void initState() {
    super.initState();
    _profileNameController.text = widget.hirings!.profileName;
    _birthdayController.text =
        DateFormat('dd/MM/yyyy').format(widget.hirings!.birthday).toString();
    _birthday = widget.hirings!.birthday;
    _hiringProfileImageBase64 = widget.hirings!.hiringProfileImage;
    _emailController.text = widget.hirings!.email!;
    _phoneController.text = widget.hirings!.phone;
    _nationController.text = widget.hirings!.nation;
    _applyForController.text = widget.hirings!.applyFor;
    _educationalLevelController.text = widget.hirings!.educationalLevel;
    _currentAddressController.text = widget.hirings!.currentAddress;
    _workExperienceController.text = widget.hirings!.workExperience;
    _gender = widget.hirings!.gender;
    status = widget.hirings!.hiringStatus;
    idHiringsController.text = widget.hirings!.hiringProfileId.toString();
    // Focus
    _profileNameFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_profileNameFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _birthdayFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_birthdayFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _placeOfBirthFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_placeOfBirthFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus

    _phoneFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_phoneFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _emailFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_emailFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _applyForFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_applyForFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });

    _educationalLevelFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_educationalLevelFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _thuongtruFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_thuongtruFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });

    _nationFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_nationFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });

    _workExperienceFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_workExperienceFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _loadDepartments();
  }

  void _updateHirings() async {
    if (_formKey.currentState!.validate()) {
      if (_hiringProfileImageBase64 == null) {
        // Hiển thị thông báo lỗi nếu chưa chọn ảnh
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn ảnh trước khi gửi!')),
        );
        return;
      }
      final updatedHirings = Hirings(
          profileName: _profileNameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          birthday: _birthday,
          currentAddress: _currentAddressController.text,
          nation: _nationController.text,
          gender: _gender,
          hiringStatus: status,
          applyFor: _applyForController.text,
          educationalLevel: _educationalLevelController.text,
          workExperience: _workExperienceController.text,
          hiringProfileId: int.tryParse(idHiringsController.text),
          //
          hiringProfileImage: _hiringProfileImageBase64 ?? "");

      Provider.of<HiringsViewModel>(context, listen: false)
          .updateHirings(updatedHirings)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hirings Update successfully!')),
        );
        Navigator.pop(context, updatedHirings);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Hirings: $error')),
        );
      });
    }
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
        _hiringProfileImageBase64 = base64String;
      });
    }
  }

  Widget _buildDateBirthday(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _birthday = selectedDate;

          // Định dạng ngày theo DD/MM/YYYY và gán vào controller
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          focusNode: _birthdayFocusNode,
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nhập ngày sinh';
            }

            // Parse ngày theo định dạng nhập
            DateTime birthday = DateFormat('dd/MM/yyyy').parse(value);

            // Kiểm tra ngày sinh trong quá khứ
            if (birthday.isAfter(DateTime.now())) {
              return 'Ngày sinh phải là\nngày trong quá khứ';
            }

            // Kiểm tra độ tuổi đủ làm việc (ví dụ từ 18 tuổi trở lên)
            int age = DateTime.now().year - birthday.year;
            if (DateTime.now().month < birthday.month ||
                (DateTime.now().month == birthday.month &&
                    DateTime.now().day < birthday.day)) {
              age--;
            }
            if (age < 18) {
              return 'Người lao động\nphải từ 18 tuổi\ntrở lên.';
            }

            // Kiểm tra tuổi nghỉ hưu nếu cần
            if (_isRetirementAgeExceeded(birthday, _gender)) {
              return 'Người lao động\nđã quá tuổi\nnghỉ hưu.';
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

// Hàm kiểm tra tuổi nghỉ hưu
  bool _isRetirementAgeExceeded(DateTime birthday, bool gender) {
    DateTime currentDate = DateTime.now();

    // Tính số năm và tháng từ ngày sinh
    int ageInYears = currentDate.year - birthday.year;
    int ageInMonths = currentDate.month - birthday.month;
    if (ageInMonths < 0) {
      ageInYears--;
      ageInMonths += 12;
    }

    // Kiểm tra độ tuổi nghỉ hưu
    if (gender) {
      // Nữ (55 tuổi 4 tháng)
      if (ageInYears > 55 || (ageInYears == 55 && ageInMonths >= 4)) {
        return true;
      }
    } else {
      // Nam (60 tuổi 3 tháng)
      if (ageInYears > 60 || (ageInYears == 60 && ageInMonths >= 3)) {
        return true;
      }
    }
    return false;
  }

  Widget _buildDropdownField(
      String label, bool currentValue, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<bool>(
        value: currentValue,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: [
          DropdownMenuItem(value: false, child: Text('Man')),
          DropdownMenuItem(value: true, child: Text('Woman')),
        ],
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  Widget _buildDropdownStatusField(
      String label, int currentValue, Function(int?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: currentValue,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: [
          DropdownMenuItem(value: -1, child: Text('Đã từ chối')),
          DropdownMenuItem(value: 0, child: Text('Ứng viên mới')),
          DropdownMenuItem(value: 1, child: Text('Phỏng vấn')),
          DropdownMenuItem(value: 2, child: Text('Đề nghị làm')),
          DropdownMenuItem(value: 3, child: Text('Đã duyệt')),
        ],
        onChanged: _isEditing ? onChanged : null,
        validator: (value) =>
            value == null ? 'Please select a Trạng thái' : null,
      ),
    );
  }

  void _loadDepartments() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .getDepartmentsByPosition();
      departmentsPosition =
          Provider.of<DeparmentsViewModel>(context, listen: false)
              .getlistdepartmentPosition;
      setState(() {
        if (AppStrings.ROLE_PERMISSIONS.containsAny(
            ['Manage BoD & HR accounts', 'Manage Staffs info only'])) {
          departmentsPosition = departmentsPosition
              .where((department) =>
                  department.departmentID != 'PB-GĐ' &&
                  department.departmentID != 'PB-HR')
              .toList();
        }
      });
    } catch (error) {
      // Hiển thị thông báo lỗi nếu có sự cố
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load departments and position')),
      );
    }
  }

  Widget _buildDepartmentPositionDropdown(String hint) {
    return DropdownButtonFormField<DepartmentPosition>(
      value: selectedDepartmentsPosition,
      hint: Text(hint),
      isExpanded: false,
      onChanged: (DepartmentPosition? newValue) {
        setState(() {
          selectedDepartmentsPosition = newValue;
          // Gán giá trị từ dropdown vào _nationController.text
          if (newValue != null) {
            _applyForController.text =
                "${newValue.positionName!} - ${newValue.departmentName!}";
          }
        });
      },
      items: departmentsPosition.map((DepartmentPosition dep) {
        return DropdownMenuItem<DepartmentPosition>(
          value: dep,
          child: Text("${dep.positionName!}  -  ${dep.departmentName!}"),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Nhập chức vụ và phòng ban';
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      actions: [
        IconButton(
          icon: Icon(Icons.save, color: const Color.fromARGB(255, 33, 243, 61)),
          onPressed: _updateHirings,
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
        ),
      ],
      resizeToAvoidBottomInset: true,
      titletext: "Thông tin tuyển dụng",
      appBarColor: AppColor.primaryLightColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 500, // Kích thước hình vuông
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Màu nền nếu không có ảnh
                    border: Border.all(color: Colors.grey), // Viền (nếu cần)
                    borderRadius: BorderRadius.circular(8), // Bo góc (nếu cần)
                    image: _hiringProfileImageBase64 != null
                        ? DecorationImage(
                            image: MemoryImage(
                                base64Decode(_hiringProfileImageBase64!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _hiringProfileImageBase64 == null
                      ? Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                      : null,
                ),
              ).py8(),
              // Profile name and Apply For
              CustomTextFormField(
                focusNode: _profileNameFocusNode,
                textEditingController: _profileNameController,
                labelText: 'Họ và tên',
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  // Kiểm tra không có khoảng trắng ở cuối tên
                  if (value.trim() != value) {
                    return 'Không được có khoảng trắng thừa\nở đầu hoặc cuối';
                  }
                  if (value.length < 4) {
                    return 'Họ và Tên phải có ít nhất 4 ký tự';
                  }
                  // Regex kiểm tra ký tự đặc biệt
                  final nameRegex = RegExp(
                      r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                  if (!nameRegex.hasMatch(value)) {
                    return 'Họ và Tên không hợp lệ. Vui lòng\nnhập đúng định dạng.';
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
                    return 'Chữ cái đầu tiên của mỗi từ phải viết\n hoa. Ví dụ: Nguyễn Bình Dương';
                  }

                  if (!value.isLetter()) {
                    return 'Tên chỉ gồm chữ';
                  }
                  return null;
                },
              ).p(8),
              _buildDepartmentPositionDropdown('Vị trí ứng tuyển').p(8),

              // Birthday and Place of Birth
              Row(
                children: [
                  _buildDateBirthday(
                      'Ngày sinh', _birthdayController, _birthday, (date) {
                    setState(() {
                      _birthday = date;
                      _birthdayController.text =
                          "${_birthday.toLocal()}".split(' ')[0];
                    });
                  }).px8().w(150),
                  InkWell(
                    onTap: () async {
                      // Điều hướng đến trang AddProvinces và nhận dữ liệu trả về
                      final selectedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProvinces(),
                        ),
                      );

                      if (selectedAddress != null) {
                        setState(() {
                          // Cập nhật TextEditingController với địa chỉ được chọn
                          _nationController.text = selectedAddress;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      // Ngăn không cho bàn phím mở ra khi nhấn
                      child: CustomTextFormField(
                        focusNode: _nationFocusNode,
                        textEditingController: _nationController,
                        labelText: 'Quê quán',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống';
                          }
                          return null;
                        },
                      ),
                    ),
                  ).w(230),
                ],
              ),
              // Gender and Nation
              Row(
                children: [
                  Text('Giới tính').px8(),
                  _buildDropdownField('Chọn giới tính', _gender, (value) {
                    setState(() {
                      _gender = value!;
                    });
                  }).p(8).w(130)
                ],
              ),
              // Email and Phone
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _emailController,
                    labelText: 'Email',
                    maxLength: 254,
                    maxLines: 1,
                    focusNode: _emailFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      final emailRegex =
                          RegExp(r'^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*@gmail\.com$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Email phải đúng định dạng\nvà có đuôi @gmail.com';
                      }
                      // Kiểm tra độ dài phần trước @
                      final localPart = value.split('@')[0];
                      if (localPart.length < 6 || localPart.length > 30) {
                        return 'Phần trước @ phải từ 6-30 ký tự';
                      }
                      if (value.length > 254) {
                        return 'Email không được vượt quá 254 ký tự';
                      }
                      return null;
                    },
                  ).px4().w(225),
                  CustomTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được\nđể trống';
                      }
                      if (value.length != 10) {
                        return 'Số điện thoại\nkhông hợp lệ';
                      }
                      if (!value.startsWith('0')) {
                        return 'Số điện thoại\nphải bắt đầu\nbằng số 0';
                      }
                      if (!value.isNumber()) {
                        return 'Số điện thoại\nchỉ gồm số';
                      }
                      if (value.startsWith('00')) {
                        return 'Số điện thoại\nkhông được\nbắt đầu bằng 00';
                      }
                      return null;
                    },
                    textEditingController: _phoneController,
                    labelText: 'Điện thoại',
                    maxLines: 1,
                    maxLength: 10,
                    focusNode: _phoneFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorMaxLines: 2, errorStyle: TextStyle(fontSize: 12)),
                  ).w(155),
                ],
              ).py8(),
              InkWell(
                onTap: () async {
                  // Điều hướng đến trang AddProvinces và nhận dữ liệu trả về
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProvinces(),
                    ),
                  );

                  if (selectedAddress != null) {
                    setState(() {
                      // Cập nhật TextEditingController với địa chỉ được chọn
                      _currentAddressController.text = selectedAddress;
                    });
                  }
                },
                child: AbsorbPointer(
                  // Ngăn không cho bàn phím mở ra khi nhấn
                  child: CustomTextFormField(
                    focusNode: _thuongtruFocusNode,
                    textEditingController: _currentAddressController,
                    labelText: 'Địa chỉ thường trú',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ),
                ),
              ).p8(),
              SizedBox(
                height: 20,
              ),
              // Education Level
              CustomTextFormField(
                labelText: "Học vấn",
                maxLines: 10,
                maxLength: 1000,
                focusNode: _educationalLevelFocusNode,
                textEditingController: _educationalLevelController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng không để trống';
                  }
                  // Kiểm tra không có khoảng trắng ở cuối tên
                  if (value.trim() != value) {
                    return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                  }
                  if (value.length < 10) {
                    return 'Học vấn phải có ít nhất 10 ký tự';
                  }
                  // Regex kiểm tra ký tự đặc biệt
                  final nameRegex = RegExp(
                      r"^[a-zA-Z0-9ÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                  if (!nameRegex.hasMatch(value)) {
                    return 'Học vấn không hợp lệ. Vui lòng nhập\nđúng định dạng.';
                  }
                  if (!value.isLetter()) {
                    return 'Học vấn chỉ gồm chữ';
                  }
                  return null;
                },
              ).px(8),
              SizedBox(
                height: 20,
              ),

              CustomTextFormField(
                focusNode: _workExperienceFocusNode,
                maxLength: 1000,
                textEditingController: _workExperienceController,
                labelText: 'Kinh nghiệm làm việc',
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng không để trống';
                  }
                  // Kiểm tra không có khoảng trắng ở cuối tên
                  if (value.trim() != value) {
                    return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                  }
                  if (value.length < 10) {
                    return 'Kinh nghiệm làm việc phải có ít nhất 10 ký tự';
                  }
                  // Regex kiểm tra ký tự đặc biệt
                  final nameRegex = RegExp(
                      r"^[a-zA-Z0-9ÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                  if (!nameRegex.hasMatch(value)) {
                    return 'Kinh nghiệm làm việc không hợp lệ. Vui lòng nhập\nđúng định dạng.';
                  }
                  if (!value.isLetter()) {
                    return 'Kinh nghiệm làm việc chỉ gồm chữ';
                  }
                  return null;
                },
              ).px4(),
              Row(
                children: [
                  Text('Status Hirings').px(8),
                  _buildDropdownStatusField(
                'Chọn Status Hirings',
                status,
                (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ).px(8).w(286),
                ],
              ),
              
            ],
          ),
        ).px8(),
      ),
    );
  }
}
