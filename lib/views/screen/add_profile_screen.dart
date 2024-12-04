import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/department_position_model.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/provinces.dart';
import 'package:nloffice_hrm/models/roles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/roles_view_models.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_provinces.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'list_nation.dart';

class AddProfilePage extends StatefulWidget {
  final Profiles? profile;
  const AddProfilePage({super.key, this.profile});

  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _profileNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _identifiNumController = TextEditingController();
  final _idLicenseDayController = TextEditingController();
  final _nationController = TextEditingController();
  final _temporaryAddressController = TextEditingController();
  final _currentAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateTime _birthday = DateTime.now();
  DateTime _idLicenseDay = DateTime.now();
  bool _gender = false; // Assuming `false` is Male, `true` is Female
  bool _marriage = false; // Assuming `false` is Male, `true` is Female
  //
  List<Departments> departments = [];
  Departments? selectedDepartment;
  List<DepartmentPosition> departmentsPosition = [];
  DepartmentPosition? selectedDepartmentsPosition;
  List<Positions> positions = [];
  Positions? selectedPositions;
  List<Salaries> salarys = [];
  Salaries? selectedSalarys;
  List<Roles> roles = [];
  Roles? selectedRoles;
  String? _profileImageBase64;
  int? daysDifference; //tổng số ngày của start time - end time
  ///APi lấy Địa chỉ
  String? _selectedNation;
  bool _passwordVisible = false;
  //Json Địa Chỉ
  late Future<List<Province>> futureProvinces;
  List<Province> provinces = [];

  //Ẩn hiện thông báo
  FocusNode _manvFocusNode = FocusNode();
  FocusNode _hovaTenFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _identifiNumFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _birthdayFocusNode = FocusNode();
  FocusNode _noisinhFocusNode = FocusNode();
  FocusNode _tamtruFocusNode = FocusNode();
  FocusNode _thuongtruFocusNode = FocusNode();
  FocusNode _ngayccdFocusNode = FocusNode();
  FocusNode _nationFocusNode = FocusNode();
  FocusNode _startTimeFocusNode = FocusNode();
  FocusNode _endTimeFocusNode = FocusNode();
  @override
  void dispose() {
    _profileIDController.dispose();
    _profileNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _placeOfBirthController.dispose();
    _identifiNumController.dispose();
    _idLicenseDayController.dispose();
    _nationController.dispose();
    _temporaryAddressController.dispose();
    _currentAddressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDepartments();
    _loadPositions();
    _loadSalaries();
    _loadRoles();
    futureProvinces =
        Provider.of<ProfilesViewModel>(context, listen: false).fetchProvinces();
    loadProvinces();

    // Focus
    _identifiNumFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_identifiNumFocusNode.hasFocus) {
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
    // Focus

    _passwordFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_passwordFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _hovaTenFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_hovaTenFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _manvFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_manvFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });

    _noisinhFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_noisinhFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _tamtruFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_tamtruFocusNode.hasFocus) {
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
    _ngayccdFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_ngayccdFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _birthdayFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_birthdayFocusNode.hasFocus) {
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
    _startTimeFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_startTimeFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _endTimeFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_endTimeFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  Future<void> loadProvinces() async {
    final data = await futureProvinces;
    setState(() {
      provinces = data;
    });
  }

  void _loadDepartments() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .getDepartmentsByPosition();
      departmentsPosition =
          Provider.of<DeparmentsViewModel>(context, listen: false)
              .getlistdepartmentPosition;
      setState(() {
        if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
        } else if (AppStrings.ROLE_PERMISSIONS
            .contains('Manage Staffs info only')) {
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

  // Method to load departments
  void _loadPositions() async {
    try {
      await Provider.of<PositionsViewModel>(context, listen: false)
          .fetchPositions();
      positions =
          Provider.of<PositionsViewModel>(context, listen: false).listPositions;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load departments')),
      );
    }
  }

  void _loadRoles() async {
    try {
      await Provider.of<RolesViewModels>(context, listen: false).getAllRoles();
      List<Roles> allRoles =
          Provider.of<RolesViewModels>(context, listen: false).listRoles;
      print("AppStrings.ROLE_PERMISSIONS: ${AppStrings.ROLE_PERMISSIONS}");
      print("All roles: ${allRoles.map((role) => role.roleID).toList()}");
      if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
        roles = allRoles
            .where((role) => [1, 2, 3, 4, 5].contains(role.roleID))
            .toList();
      } else if (AppStrings.ROLE_PERMISSIONS
          .contains('Manage Staffs info only')) {
        roles = allRoles
            .where((role) => [1, 2, 3, 4].contains(role.roleID))
            .toList();
      } else {
        roles = [];
      }
      print("Filtered roles: ${roles.map((role) => role.roleID).toList()}");
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Roles')),
      );
    }
  }

  void _loadSalaries() async {
    try {
      await Provider.of<SalariesViewModel>(context, listen: false)
          .fetchAllSalaries();
      salarys =
          Provider.of<SalariesViewModel>(context, listen: false).listSalaries;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load salaries')),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newProfile = Profiles(
          profileId: _profileIDController.text,
          profileName: _profileNameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          birthday: _birthday,
          temporaryAddress: _temporaryAddressController.text,
          currentAddress: _currentAddressController.text,
          identifiNum: _identifiNumController.text,
          idLicenseDay: _idLicenseDay,
          password: _passwordController.text,
          placeOfBirth: _placeOfBirthController.text,
          nation: _nationController.text,
          gender: _gender,
          marriage: _marriage,
          profileStatus: 0,
          startTime: _startTime,
          endTime: _endTime,
          //
          roleID: 1,
          departmentId: selectedDepartmentsPosition!.departmentID,
          positionId: selectedDepartmentsPosition!.positionId,
          salaryId: selectedSalarys!.salaryId,
          profileImage: _profileImageBase64 ?? null);
      Provider.of<ProfilesViewModel>(context, listen: false)
          .addProfile(newProfile, (message) {
        if (message == 'Nhân viên đã được thêm thành công.') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context, newProfile); // Đóng màn hình
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
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
        _profileImageBase64 = base64String;
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
void _showWarningDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Xác nhận lưu thông tin",
          style: TextStyle(color: AppColor.darkThemeColor),
        ),
        content: Text(
          "Bạn có chắc chắn muốn lưu thông tin không?\nVui lòng kiểm tra kỹ trước khi xác nhận.",
          style: TextStyle(color: AppColor.darkThemeColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
            child: Text(
              "Hủy",
              style: TextStyle(color: AppColor.darkThemeColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
              _submit(); // Gọi hàm lưu
            },
            child: Text(
              "Xác nhận",
              style: TextStyle(color: AppColor.primaryDarkColor),
            ),
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
        showLeadingAction: true,
        defaultBody: false,
        appBarItemColor: AppColor.boneWhite,
        backgroundColor: AppColor.aliceBlue,
        actions: [
          TextButton.icon(
            onPressed: () {
              _showWarningDialog();
            },
            icon: Icon(
              Icons.save_outlined,
              color: AppColor.boneWhite,
            ),
            label: Text(
              "Lưu",
              style: TextStyle(color: AppColor.boneWhite),
            ),
          )
        ],
        resizeToAvoidBottomInset: true,
        titletext: "Thêm nhân viên",
        appBarColor: AppColor.primaryLightColor,
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImageBase64 != null
                    ? MemoryImage(base64Decode(_profileImageBase64!))
                    : null,
                child: _profileImageBase64 == null
                    ? Icon(Icons.add_a_photo)
                    : null,
              ),
            ),
            Divider(),
            // //Profile id + full name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                    textEditingController: _profileIDController,
                    maxLength: 10,
                    focusNode: _manvFocusNode,
                    labelText: 'Mã nhân viên',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được\nđể trống';
                      } else if (value.length > 10) {
                        return 'Mã nhân viên\nkhông được vượt quá 10 ký tự';
                      } else if (!value.startsWith('NV')) {
                        return 'Mã nhân viên\nphải bắt đầu\nbằng"NV"';
                      } else if (!RegExp(r'^NV\d+$').hasMatch(value)) {
                        return 'Sau "NV"\nphải là số';
                      }
                      return null;
                    },
                  ),
                ).p(8),
                // Họ và tên
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                    focusNode: _hovaTenFocusNode,
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
                  ),
                ).p(8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildDateBirthday(
                      'Ngày sinh', _birthdayController, _birthday, (date) {
                    setState(() {
                      _birthday = date;
                      _birthdayController.text =
                          DateFormat('dd/MM/yyyy').format(date);
                    });
                  }),
                ).p(8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
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
                          _placeOfBirthController.text = selectedAddress;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      // Ngăn không cho bàn phím mở ra khi nhấn
                      child: CustomTextFormField(
                        focusNode: _noisinhFocusNode,
                        textEditingController: _placeOfBirthController,
                        labelText: 'Nơi sinh',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ).p(8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildDepartmentPositionDropdown('Chức Vụ - Phòng Ban')
                      .p(8),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildSalaryDropdown(
                    'Mức lương',
                  ),
                ).p(8),
                Row(children: [
                  Text('Giới tính').px(8),
                  _buildDropdownField('Chọn giới tính', _gender, (value) {
                    setState(() {
                      _gender = value!;
                    });
                  }).p(8).w(130),
                ]),
                //Gender + Marriage
                Row(
                  children: [
                    Text('Hôn nhân').px8(),
                    Radio(
                      value: true,
                      groupValue: _marriage,
                      onChanged: (value) {
                        setState(() {
                          _marriage = value!;
                        });
                      },
                    ),
                    Text('Đã kết hôn'),
                    Radio(
                      value: false,
                      groupValue: _marriage,
                      onChanged: (value) {
                        setState(() {
                          _marriage = value!;
                        });
                      },
                    ),
                    Text('Chưa kết hôn'),
                  ],
                ),
                // ID number + license day

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                    maxLength: 12,
                    textEditingController: _identifiNumController,
                    labelText: 'Số CCCD/CMND',
                    keyboardType: TextInputType.number,
                    focusNode: _identifiNumFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      if (value.length != 12) {
                        return 'Số CCCD/CMND không\nhợp lệ';
                      }
                      if (!value.startsWith('0')) {
                        return 'Số CCCD phải bắt đầu\nbằng số 0';
                      }
                      if (!value.isNumber()) {
                        return 'Số CCCD chỉ gồm số';
                      }
                      return null;
                    },
                  ),
                ).px(8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildDateLicenseDay(
                      'Ngày cấp', _idLicenseDayController, _idLicenseDay,
                      (date) {
                    setState(() {
                      _idLicenseDay = date;
                      _idLicenseDayController.text =
                          DateFormat('dd/MM/yyyy').format(date);
                    });
                  }),
                ).px(8),
                //Nation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedNation,
                    focusNode: _nationFocusNode,
                    items: NationNames.map((nation) {
                      return DropdownMenuItem(
                        value: nation,
                        child: Text(nation),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Quốc tịch',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedNation = value; // Cập nhật giá trị được chọn
                        _nationController.text =
                            value ?? ""; // Gán vào controller
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ),
                ).p(8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
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
                  ),
                ).p(8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
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
                  ),
                ).p(8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomTextFormField(
                    labelText: "Mật khẩu",
                    focusNode: _passwordFocusNode,
                    maxLength: 15,
                    textEditingController: _passwordController,
                    obscureText: !_passwordVisible, 
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      if (value.trim() != value) {
                        return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                      }
                      // Kiểm tra độ dài mật khẩu (từ 8 đến 15 ký tự)
                      if (value.length < 8 || value.length > 15) {
                        return 'Mật khẩu phải từ 8 đến 15 ký tự';
                      }
                      // Kiểm tra mật khẩu có ít nhất một chữ cái viết hoa, một chữ cái viết thường, một số và một ký tự đặc biệt
                      if (!RegExp(
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,15}$')
                          .hasMatch(value)) {
                        return 'Mật khẩu phải bao gồm chữ cái viết hoa, chữ cái viết\nthường, số và ký tự đặc biệt';
                      }
                      return null;
                    },
                  ),
                ).p8(),
                //Thường trú
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
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
                  ),
                ).p8(),

                //Tạm trú
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
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
                          _temporaryAddressController.text = selectedAddress;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      // Ngăn không cho bàn phím mở ra khi nhấn
                      child: CustomTextFormField(
                        focusNode: _tamtruFocusNode,
                        textEditingController: _temporaryAddressController,
                        labelText: 'Địa chỉ tạm trú',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ).p8(),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _buildDateStartTime(
                        'Ngày bắt đầu\nthử việc',
                        _startTimeController,
                        _startTime,
                        (date) {
                          setState(() {
                            _startTime = date;
                            _startTimeController.text =
                                "${_startTime.toLocal()}".split(' ')[0];
                            _calculateDaysDifference(); // Tính số ngày khi ngày bắt đầu thay đổi
                          });
                        },
                      ),
                    ).p(8),
                    if (daysDifference != null)
                      Text(
                        'Tổng ngày: $daysDifference',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ).p(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _buildDateEndTime(
                        'Ngày kết thúc\nthử việc',
                        _endTimeController,
                        _endTime,
                        (date) {
                          setState(() {
                            _endTime = date;
                            _endTimeController.text =
                                "${_endTime.toLocal()}".split(' ')[0];
                            _calculateDaysDifference(); // Tính số ngày khi ngày kết thúc thay đổi
                          });
                        },
                      ),
                    ).p(8),
                  ],
                ),

                SizedBox(width: 16),
              ],
            ),

            // Hiển thị số ngày thử việc
          ]),
        )));
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

  Widget _buildDateLicenseDay(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _idLicenseDay = selectedDate;
          // Định dạng ngày theo DD/MM/YYYY và gán vào controller
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          focusNode: _ngayccdFocusNode,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nhập ngày cấp';
            }

            // Kiểm tra ngày cấp là ngày trong quá khứ
            DateTime licenseDay = DateFormat('dd/MM/yyyy').parse(value);
            if (licenseDay.isAfter(DateTime.now())) {
              return 'Ngày cấp phải là ngày\ntrong quá khứ';
            }

            // Kiểm tra ngày sinh đã nhập (dùng controller)
            if (_birthdayController.text.isEmpty) {
              return 'Cần nhập ngày sinh trước!';
            }

            // Parse ngày sinh từ _birthdayController
            DateTime birthday =
                DateFormat('dd/MM/yyyy').parse(_birthdayController.text);

            // Kiểm tra tuổi đủ 14 tại thời điểm cấp CCCD
            int ageAtLicense = licenseDay.year - birthday.year;
            if (licenseDay.month < birthday.month ||
                (licenseDay.month == birthday.month &&
                    licenseDay.day < birthday.day)) {
              ageAtLicense--;
            }

            if (ageAtLicense < 14) {
              return 'Ngày cấp không hợp lệ\n(CCCD chỉ cấp khi đủ\n14 tuổi)';
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

  Widget _buildDateStartTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _startTime = selectedDate;
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          focusNode: _startTimeFocusNode,
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nhập ngày bắt đầu';
            }
            try {
              // Parse ngày được nhập
              DateTime selectedStartTime =
                  DateFormat('dd/MM/yyyy').parse(value);

              // Lấy ngày hiện tại không tính thời gian (00:00:00)
              DateTime today = DateTime.now();
              DateTime todayWithoutTime =
                  DateTime(today.year, today.month, today.day);

              // Kiểm tra nếu ngày bắt đầu là ngày trong quá khứ
              if (selectedStartTime.isBefore(todayWithoutTime)) {
                return 'Ngày bắt đầu\nkhông được là\nngày trong quá khứ';
              }
            } catch (e) {
              return 'Định dạng ngày không hợp lệ';
            }
            return null; // Hợp lệ nếu không vi phạm điều kiện
          },
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  void _calculateDaysDifference() {
    if (_startTime != null && _endTime != null) {
      setState(() {
        daysDifference = _endTime.difference(_startTime).inDays;
        // Nếu số ngày âm, chuyển thành 0
        if (daysDifference! < 0 || daysDifference! > 300) {
          daysDifference = 0;
        }
      });
    }
  }

  Widget _buildDateEndTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _endTime = selectedDate;
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          focusNode: _endTimeFocusNode,
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nhập ngày kết thúc';
            }
            try {
              DateTime selectedEndTime = DateFormat('dd/MM/yyyy').parse(value);
              if (selectedEndTime.isBefore(_startTime)) {
                return 'Ngày kết thúc\nkhông được trước\nngày bắt đầu';
              }
              int daysDifference =
                  selectedEndTime.difference(_startTime).inDays;
              if (daysDifference < 30) {
                return 'Thời gian thử việc\ntối thiểu là 30 ngày';
              }
              if (daysDifference > 60) {
                return 'Thời gian thử việc\nkhông được quá\n60 ngày';
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
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }

  Widget _buildDepartmentPositionDropdown(String hint) {
    return DropdownButtonFormField<DepartmentPosition>(
      value: selectedDepartmentsPosition,
      hint: Text(hint),
      onChanged: (DepartmentPosition? newValue) {
        setState(() {
          selectedDepartmentsPosition = newValue;
        });
      },
      items: departmentsPosition.map((DepartmentPosition dep) {
        return DropdownMenuItem<DepartmentPosition>(
          value: dep,
          child: Text(
              "${dep.positionName!}  -  ${dep.departmentName!}"), // assuming department has a `name` field
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

  Widget _buildSalaryDropdown(String hint) {
    return DropdownButtonFormField<Salaries>(
      value: selectedSalarys,
      isExpanded: true,
      hint: Text(hint),
      onChanged: (Salaries? newValue) {
        setState(() {
          selectedSalarys = newValue;
        });
      },
      items: salarys.map((Salaries salary) {
        return DropdownMenuItem<Salaries>(
          value: salary,
          child: Text(
              "${salary.salaryId} - ${salary.salaryCoefficient}"), // assuming department has a `name` field
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Nhập lương';
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildRolesDropdown(String hint) {
    return DropdownButtonFormField<Roles>(
      value: selectedRoles,
      hint: Text(hint),
      onChanged: (Roles? newValue) {
        setState(() {
          selectedRoles = newValue;
        });
      },
      items: roles.map((Roles role) {
        return DropdownMenuItem<Roles>(
          value: role,
          child: Text(role.roleName),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
