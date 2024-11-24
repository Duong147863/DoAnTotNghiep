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

  ///APi lấy Địa chỉ
  String? _selectedNation;
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
    
    departmentsPosition = Provider.of<DeparmentsViewModel>(context, listen: false)
        .getlistdepartmentPosition;
    setState(() {
      if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
      } else if (AppStrings.ROLE_PERMISSIONS.contains('Manage Staffs info only')) {
        departmentsPosition = departmentsPosition
            .where((department) => department.departmentID != 'BoD' && department.departmentID != 'HR')
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
        roles =
            allRoles.where((role) => [1, 2, 3].contains(role.roleID)).toList();
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
          roleID: selectedRoles!.roleID,
          departmentId: selectedDepartmentsPosition!.departmentID,
          positionId: selectedDepartmentsPosition!.positionId,
          salaryId: selectedSalarys!.salaryId,
          profileImage: _profileImageBase64 ?? null);
      Provider.of<ProfilesViewModel>(context, listen: false)
          .addProfile(newProfile)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm nhân viên thành công')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm nhân viên thất bại $error')),
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
            //Profile id + full name
            Row(
              children: [
                CustomTextFormField(
                  textEditingController: _profileIDController,
                  maxLength: 10,
                  focusNode: _manvFocusNode,
                  labelText: 'Mã nhân viên',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    } else if (value.length > 10) {
                      return 'Mã nhân viên không được vượt quá 10 ký tự';
                    } else if (!value.startsWith('NV')) {
                      return 'Mã nhân viên phải bắt đầu bằng "NV"';
                    } else if (!RegExp(r'^NV\d+$').hasMatch(value)) {
                      return 'Sau "NV" phải là số';
                    }
                    return null;
                  },
                ).px8().w(150),
                CustomTextFormField(
                  focusNode: _hovaTenFocusNode,
                  textEditingController: _profileNameController,
                  labelText: 'Họ và tên',
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    if (value.length > 50) {
                      return 'Họ và Tên không được vượt quá 50 ký tự';
                    }
                    // Regex kiểm tra ký tự đặc biệt
                    final nameRegex = RegExp(
                        r"^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẵẳặẵÉẾỀỂỆỄêềễệéỆỆÊëẺỆĩíịỉòỏọọụủūăâăấầẩẫậơờởỡợƠƠớửủứửỰữựýỳỵỷỹ\s]+$");
                    if (!nameRegex.hasMatch(value)) {
                      return 'Họ và Tên không được chứa ký tự đặc biệt';
                    }
                    if (!value.isLetter()) {
                      return 'Tên chỉ gồm chữ';
                    }
                    return null;
                  },
                ).w(254),
              ],
            ).py16(),
            //Birthday + Place of birth
            Row(
              children: [
                _buildDateBirthday('Ngày sinh', _birthdayController, _birthday,
                    (date) {
                  setState(() {
                    _birthday = date;
                    _birthdayController.text =
                        "${_birthday.toLocal()}".split(' ')[0];
                  });
                }).px(8).w(150),
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
                ).w(254),
              ],
            ),
            Row(
              children: [
                Text('Chọn').px(6),
                _buildDepartmentPositionDropdown('Chức Vụ - Phòng Ban')
                    .p(8)
                    .w(360),
              ],
            ),
            Row(
              children: [
                Text('Lương cơ bản').px(8),
                _buildSalaryDropdown('Chọn mức lương').p(8).w(300),
              ],
            ),
            Row(
              children: [
                Text('Loại tài khoản').px(8),
                _buildRolesDropdown('Chọn loại tài khoản').p(8).w(300),
              ],
            ),
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
            Row(
              children: [
                CustomTextFormField(
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
                      return 'Số CCCD/CMND không hợp lệ';
                    }
                    if (!value.startsWith('0')) {
                      return 'Số CCCD phải bắt đầu bằng số 0';
                    }
                    if (!value.isNumber()) {
                      return 'Số CCCD chỉ gồm số';
                    }
                    return null;
                  },
                ).w(200).px8(),
                _buildDateLicenseDay(
                    'id ngày cấp', _idLicenseDayController, _idLicenseDay,
                    (date) {
                  setState(() {
                    _idLicenseDay = date;
                    _idLicenseDayController.text =
                        "${_idLicenseDay.toLocal()}".split(' ')[0];
                  });
                }).w(184),
              ],
            ).py8(),
            //Nation
            DropdownButtonFormField<String>(
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
                  _nationController.text = value ?? ""; // Gán vào controller
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
            ).p(8),
            //Email + phone
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
                    // Regex kiểm tra email, bắt buộc phải có đuôi @gmail.com
                    final emailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Email định dạng sai';
                    }
                    if (value.length > 254) {
                      return 'Email không được vượt quá 254 ký tự';
                    }
                    return null;
                  },
                ).px4().w(258),
                CustomTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    if (value.length != 10) {
                      return 'Số điện thoại không hợp lệ';
                    }
                    if (!value.startsWith('0')) {
                      return 'Số điện thoại phải \n bắt đầu bằng số 0';
                    }
                    if (!value.isNumber()) {
                      return 'Số điện thoại chỉ gồm số';
                    }
                    if (value.startsWith('00')) {
                      return 'Số điện thoại không được bắt đầu bằng 00';
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
                ).w(145),
              ],
            ).py(8),
            //Password
            CustomTextFormField(
              labelText: "Mật khẩu",
              focusNode: _passwordFocusNode,
              maxLength: 15,
              textEditingController: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                // Kiểm tra độ dài mật khẩu (từ 8 đến 15 ký tự)
                if (value.length < 8 || value.length > 15) {
                  return 'Mật khẩu phải từ 8 đến 15 ký tự';
                }
                // Kiểm tra mật khẩu có ít nhất một chữ cái viết hoa, một chữ cái viết thường, một số và một ký tự đặc biệt
                if (!RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,15}$')
                    .hasMatch(value)) {
                  return 'Mật khẩu phải bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt';
                }
                return null;
              },
            ).p8(),
            //Thường trú
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

            //Tạm trú
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
            ).p8(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateStartTime(
                  'Ngày bắt đầu thử việc',
                  _startTimeController,
                  _startTime,
                  (date) {
                    setState(() {
                      _startTime = date;
                      _startTimeController.text =
                          "${_startTime.toLocal()}".split(' ')[0];
                    });
                  },
                ).w(184),
                SizedBox(width: 16),
                _buildDateEndTime(
                  'Ngày kết thúc bắt việc',
                  _endTimeController,
                  _endTime,
                  (date) {
                    setState(() {
                      _endTime = date;
                      _endTimeController.text =
                          "${_endTime.toLocal()}".split(' ')[0];
                    });
                  },
                ).w(184),
              ],
            ),
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
          _birthdayController.text = "${_birthday.toLocal()}".split(' ')[0];
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

            // Kiểm tra ngày sinh trong quá khứ
            DateTime birthday = DateTime.parse(value);
            if (birthday.isAfter(DateTime.now())) {
              return 'Ngày sinh phải là ngày trong quá khứ';
            }

            // Kiểm tra độ tuổi đủ làm việc (ví dụ từ 18 tuổi trở lên)
            int age = DateTime.now().year - birthday.year;
            if (DateTime.now().month < birthday.month ||
                (DateTime.now().month == birthday.month &&
                    DateTime.now().day < birthday.day)) {
              age--;
            }
            if (age < 18) {
              return 'Người lao động phải từ 18 tuổi trở lên';
            }

            // Kiểm tra tuổi nghỉ hưu nếu cần
            if (_isRetirementAgeExceeded(birthday, _gender)) {
              return 'Người lao động đã quá tuổi nghỉ hưu!';
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
          _idLicenseDayController.text =
              "${_idLicenseDay.toLocal()}".split(' ')[0];
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

            // Kiểm tra ngày sinh đã nhập (dùng controller)
            if (_birthdayController.text.isEmpty) {
              return 'Cần nhập ngày sinh trước!';
            }

            // Parse ngày sinh từ _birthdayController
            DateTime birthday = DateTime.parse(_birthdayController.text);

            // Kiểm tra tuổi đủ 14 tại thời điểm cấp
            DateTime licenseDay = DateTime.parse(value);
            int ageAtLicense = licenseDay.year - birthday.year;

            if (licenseDay.month < birthday.month ||
                (licenseDay.month == birthday.month &&
                    licenseDay.day < birthday.day)) {
              ageAtLicense--;
            }

            if (ageAtLicense < 14) {
              return 'Ngày cấp không hợp lệ (CCCD chỉ cấp khi đủ 14 tuổi)';
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
              DateTime selectedStartTime = DateTime.parse(value);
              DateTime currentDate = DateTime.now();
              if (selectedStartTime.isBefore(currentDate)) {
                return 'Ngày bắt đầu không được trong quá khứ';
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
          _endTime = selectedDate;
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          focusNode: _endTimeFocusNode,
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (controller.text.isEmpty) {
              return 'Nhập ngày kết thúc';
            }
            try {
              DateTime selectedEndTime = DateTime.parse(controller.text);
              if (selectedEndTime.isBefore(_startTime) ||
                  selectedEndTime.difference(_startTime).inDays < 30) {
                return 'Deadline phải trên 1 tháng kể từ bắt đầu';
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
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSalaryDropdown(String hint) {
    return DropdownButtonFormField<Salaries>(
      value: selectedSalarys,
      hint: Text(hint),
      onChanged: (Salaries? newValue) {
        setState(() {
          selectedSalarys = newValue;
        });
      },
      items: salarys.map((Salaries salary) {
        return DropdownMenuItem<Salaries>(
          value: salary,
          child:
              Text(salary.salaryId), // assuming department has a `name` field
        );
      }).toList(),
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
