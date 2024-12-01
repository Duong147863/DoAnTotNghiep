import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/department_position_model.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/hirings_model.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/hirings_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_provinces.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddHiringsScreen extends StatefulWidget {
  const AddHiringsScreen({super.key});

  @override
  State<AddHiringsScreen> createState() => _AddHiringsScreenState();
}

class _AddHiringsScreenState extends State<AddHiringsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
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
  List<DepartmentPosition> departmentsPosition = [];
  DepartmentPosition? selectedDepartmentsPosition;
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
  @override
  void dispose() {
    _birthdayController.dispose();
    _profileNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _placeOfBirthController.dispose();
    _applyForController.dispose();
    _educationalLevelController.dispose();
    _nationController.dispose();
    _workExperienceController.dispose();
    _currentAddressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
       if (_hiringProfileImageBase64 == null) {
        // Hiển thị thông báo lỗi nếu chưa chọn ảnh
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn ảnh trước khi gửi!')),
        );
        return;
      }
      final newHirings = Hirings(
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
        //
        hiringProfileImage: _hiringProfileImageBase64 ?? "",
      );
      Provider.of<HiringsViewModel>(context, listen: false)
          .createNewHirings(newHirings)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm ứng viên mới thành công')),
        );
        Navigator.pop(context,newHirings);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm thất bại')),
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
          DropdownMenuItem(value: false, child: Text('Nam')),
          DropdownMenuItem(value: true, child: Text('Nữ')),
        ],
        onChanged: onChanged,
        validator: (value) => value == null ? 'Vui lòng chọn giới tính' : null,
      ),
    );
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
        TextButton.icon(
          onPressed: () {
            _submit();
          },
          icon: Icon(
            Icons.save_outlined,
            color: AppColor.boneWhite,
          ),
          label: Text(
            "Lưu hồ sơ",
            style: TextStyle(color: AppColor.boneWhite),
          ),
        )
      ],
      resizeToAvoidBottomInset: true,
      titletext: "Ứng viên mới",
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
            ],
          ),
        ).px8(),
      ),
    );
  }
}
