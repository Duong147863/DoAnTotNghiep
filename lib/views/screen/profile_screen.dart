import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/constant/input.styles.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/repository/profiles_repo.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/view_models/workingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';
import 'package:nloffice_hrm/views/screen/add_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/add_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/list_trainingprocesses_screen.dart';
import 'package:nloffice_hrm/views/screen/list_workingprocess_screen.dart';

import 'package:provider/provider.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/velocity_xx.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  final Profiles? profile;
  const ProfileScreen({super.key, this.profile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
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

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _profileNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _identifiNumController = TextEditingController();
  final _idLicenseDayController = TextEditingController();
  final _nationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _temporaryAddressController = TextEditingController();
  final _currentAddressController = TextEditingController();
  DateTime _birthday = DateTime.now();
  DateTime _idLicenseDay = DateTime.now();
  bool _gender = false;
  bool _marriage = false;
  bool _isEditing = false;
  String? _profileImageBase64;
  bool _isButtonEnabled = true;
  //
  List<Departments> departments = [];
  Departments? selectedDepartment;
  List<Positions> positions = [];
  Positions? selectedPositions;
  List<Salaries> salarys = [];
  Salaries? selectedSalarys;
  List<WorkingProcesses> workingProcesses = [];
  WorkingProcesses? selectedWorkingProcesses;

  void initState() {
    super.initState();
    _profileIDController.text = widget.profile!.profileId;
    _profileNameController.text = widget.profile!.profileName;
    _birthdayController.text = widget.profile!.birthday.toIso8601String();
    _placeOfBirthController.text = widget.profile!.placeOfBirth;
    _gender = widget.profile!.gender;
    _identifiNumController.text = widget.profile!.identifiNum;
    // print(widget.profile!.idLicenseDay.toIso8601String());
    _idLicenseDayController.text =
        widget.profile!.idLicenseDay.toIso8601String();
    _nationController.text = widget.profile!.nation;
    _emailController.text = widget.profile!.email ?? '';
    _phoneController.text = widget.profile!.phone;
    // _passwordController.text = widget.profile!.password;
    _temporaryAddressController.text = widget.profile!.temporaryAddress;
    _currentAddressController.text = widget.profile!.currentAddress;
    _profileImageBase64 = widget.profile!.profileImage;
    _marriage = widget.profile!.marriage;
    _gender = widget.profile!.gender;
    _loadDepartments();
    _loadPositions();
    _loadSalaries();
    _loadworkingProcesses();
  }

  // Method to load departments
  void _loadDepartments() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .fetchAllDepartments();
      setState(() {
        departments = Provider.of<DeparmentsViewModel>(context, listen: false)
            .listDepartments;
        if (departments.isNotEmpty) {
          selectedDepartment = departments.firstWhere(
            (department) =>
                department.departmentID == widget.profile!.departmentId,
          );
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load departments')),
      );
    }
  }

  // Method to load departments
  void _loadPositions() async {
    try {
      await Provider.of<PositionsViewModel>(context, listen: false)
          .fetchPositions();
      setState(() {
        positions = Provider.of<PositionsViewModel>(context, listen: false)
            .listPositions;
        if (positions.isNotEmpty) {
          selectedPositions = positions.firstWhere(
            (position) => position.positionId == widget.profile!.positionId,
          );
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Positions')),
      );
    }
  }

  void _loadSalaries() async {
    try {
      await Provider.of<SalariesViewModel>(context, listen: false)
          .fetchAllSalaries();
      setState(() {
        salarys =
            Provider.of<SalariesViewModel>(context, listen: false).listSalaries;
        if (salarys.isNotEmpty) {
          selectedSalarys = salarys.firstWhere(
            (salary) => salary.salaryId == widget.profile!.salaryId,
          );
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load salaries')),
      );
    }
  }

  void _loadworkingProcesses() async {
    try {
      await Provider.of<WorkingprocessesViewModel>(context, listen: false)
          .fetchWorkingProcess(widget.profile!.profileId);
      setState(() {
        workingProcesses =
            Provider.of<WorkingprocessesViewModel>(context, listen: false)
                .listWorkingProcess;
        if (workingProcesses.isNotEmpty) {
          selectedWorkingProcesses = workingProcesses.firstWhere(
            (wor) => wor.profileId == widget.profile!.profileId,
          );
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Workingprocesses')),
      );
    }
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = Profiles(
          profileId: _profileIDController.text,
          profileName: _profileNameController.text,
          birthday: _birthday,
          placeOfBirth: _placeOfBirthController.text,
          gender: _gender,
          identifiNum: _identifiNumController.text,
          idLicenseDay: _idLicenseDay,
          nation: _nationController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: "Liempn@13",
          temporaryAddress: _temporaryAddressController.text,
          currentAddress: _currentAddressController.text,
          marriage: _marriage,
          departmentId: selectedDepartment!.departmentID,
          positionId: selectedPositions!.positionId,
          salaryId: selectedSalarys!.salaryId,
          profileImage: _profileImageBase64 ?? '');

      Provider.of<ProfilesViewModel>(context, listen: false)
          .updateProfile(updatedProfile)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Update successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update profile: $error')),
        );
      });
    }
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

  Future<void> _pickImage() async {
    try {
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
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Quay lại trang trước đó
          },
        ),
        actions: AppStrings.ROLE_PERMISSIONS.containsAny(
                ['Manage BoD & HR accounts', 'Manage Staffs info only'])
            ? <Widget>[
                IconButton(
                  enableFeedback: true,
                  onPressed: _isButtonEnabled
                      ? () {
                          // Tắt nút sau khi nhấn
                          setState(() {
                            _isButtonEnabled = false;
                          });
                          // Thực hiện hành động
                          _updateProfile();
                        }
                      : null, // Nếu nút không được bật, sẽ không thực hiện hành động
                  icon: Icon(Icons.save, color: Colors.red),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true; // Chuyển đổi chế độ chỉnh sửa
                    });
                  },
                  icon: Icon(Icons.edit_outlined, color: Colors.red),
                ),
              ]
            : [],
      ),
      extendBodyBehindAppBar: false,
      body: ListView(children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _profileImageBase64 != null &&
                          _profileImageBase64!.isNotEmpty
                      ? MemoryImage(base64Decode(_profileImageBase64!))
                      : (widget.profile!.profileImage.isNotEmpty
                          ? MemoryImage(
                              base64Decode(widget.profile!.profileImage))
                          : AssetImage('assets/images/male_avatar.png')
                              as ImageProvider), // Default avatar
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.dstATop,
                  ),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              alignment: Alignment.center,
              child: UiSpacer.emptySpace(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isEditing
                      ? _pickImage
                      : null, // Cho phép chọn ảnh khi đang ở chế độ chỉnh sửa
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: 250,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: _profileImageBase64 != null
                          ? Image.memory(
                              base64Decode(_profileImageBase64!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print("Error loading image: $error");
                                return Icon(Icons.error,
                                    size: 30, color: Colors.grey);
                              },
                            )
                          : (widget.profile!.profileImage != null &&
                                  widget.profile!.profileImage!.isNotEmpty
                              ? Image.memory(
                                  base64Decode(widget.profile!.profileImage!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Error loading image: $error");
                                    return Icon(Icons.error,
                                        size: 30, color: Colors.grey);
                                  },
                                )
                              : Icon(Icons.person,
                                  size: 30, color: Colors.grey)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile ID + Full name
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _profileIDController,
                    labelText: 'Mã',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_profile_id';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8().w(150),
                  CustomTextFormField(
                    textEditingController: _profileNameController,
                    labelText: 'Họ và tên',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_full_name';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).w(254),
                ],
              ).py16(),

              // Birthday + Place of birth
              Row(
                children: [
                  _buildDateField('Ngày sinh', _birthdayController, _birthday,
                      (date) {
                    setState(() {
                      _birthday = date;
                      _birthdayController.text =
                          "${_birthday.toLocal()}".split(' ')[0];
                    });
                  }).px(8).w(150),
                  CustomTextFormField(
                    textEditingController: _placeOfBirthController,
                    labelText: 'Nơi sinh',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_place_of_birth';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).w(254),
                ],
              ),
              Row(
                children: [
                  Text('Phòng:').px(8),
                  _buildDepartmentDropdown('Choose Department').p(8).w(300),
                ],
              ),
              Row(
                children: [
                  Text('Chức vụ').px(8),
                  _buildPositionsDropdown('Choose Postion').p(8).w(300),
                ],
              ),
              Row(
                children: [
                  Text('Lương').px(8),
                  _buildSalaryDropdown('Choose Salary').p(8).w(300),
                ],
              ),
              // Gender + Marriage
              Row(
                children: [
                  Text('Giới tính').px(8),
                  _buildDropdownField('Chọn giới tính', _gender, (value) {
                    setState(() {
                      _gender = value!;
                    });
                  }).p(8).w(130),
                  //Nation
                  CustomTextFormField(
                    validator: (value) =>
                        value.isEmptyOrNull ? 'Please enter nation' : null,
                    textEditingController: _nationController,
                    labelText: 'Quốc tịch',
                    enabled: _isEditing,
                  ).p(8).w(160),
                ],
              ),
              Row(
                children: [
                  Text('Hôn nhân:'),
                  Radio(
                    value: true,
                    groupValue: _marriage,
                    onChanged: _isEditing
                        ? (value) {
                            setState(() {
                              _marriage = value as bool;
                            });
                          }
                        : null,
                  ),
                  Text('Đã kết hôn'),
                  Radio(
                    value: false,
                    groupValue: _marriage,
                    onChanged: _isEditing
                        ? (value) {
                            setState(() {
                              _marriage = value as bool;
                            });
                          }
                        : null,
                  ),
                  Text('Chưa kết hôn'),
                ],
              ),

              // ID number + license day
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _identifiNumController,
                    labelText: 'id_num',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_phone_number';
                      }
                      if (value.length != 12) {
                        return 'please_enter_valid_id_num'; // Thông báo nhập đúng 10 chữ số
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).w(200).px8(),
                  _buildDateField(
                      'id_license_date', _idLicenseDayController, _idLicenseDay,
                      (date) {
                    setState(() {
                      _idLicenseDay = date;
                      _idLicenseDayController.text =
                          "${_idLicenseDay.toLocal()}".split(' ')[0];
                    });
                  }).w(184),
                ],
              ).py8(),

              //Email + phone
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _emailController,
                    labelText: 'Email',
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_email';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'please_enter_valid_email';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px4().w(258),
                  CustomTextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_phone_number';
                            }
                            if (value.length != 10) {
                              return 'please_enter_valid_phone_number'; // Thông báo nhập đúng 10 chữ số
                            }
                            return null;
                          },
                          textEditingController: _phoneController,
                          labelText: 'Số điện thoại',
                          maxLines: 1,
                          enabled: _isEditing,
                          keyboardType: TextInputType.number)
                      .w(145),
                ],
              ).py(8),
              //Address
              CustomTextFormField(
                textEditingController: _temporaryAddressController,
                labelText: 'Địa chỉ tạm trú',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_temp_address';
                  }
                  return null;
                },
                enabled: _isEditing,
              ).p8(),
              CustomTextFormField(
                textEditingController: _currentAddressController,
                labelText: 'Nơi ở hiện tại',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_current_address';
                  }
                  return null;
                },
                enabled: _isEditing,
              ).p8(),
              //
            ],
          ),
        ),
      ]),
      fab: AppStrings.ROLE_PERMISSIONS.contains('Manage Staffs info only')
          ? SpeedDial(
              elevation: 0,
              icon: Icons.menu,
              buttonSize: Size(50, 50),
              children: [
                  SpeedDialChild(
                      label: "Thêm Thân Nhân",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  AddRelativeScreen(
                                profile: widget.profile,
                              ),
                            ));
                      }),
                  SpeedDialChild(
                      label: "Thêm Bằng Cấp",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  AddDiplomaScreen(
                                profile: widget.profile,
                              ),
                            ));
                      }),
                  SpeedDialChild(
                      label: "Phê Duyệt Quá Trình Đạo Tạo",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ListTrainingprocessesScreen(
                                profiles: widget.profile,
                              ),
                            ));
                      }),
                  SpeedDialChild(
                      label: "Phê Duyệt Quá Trình Làm Việc",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ListWorkingprocessScreen(
                                profiles: widget.profile,
                              ),
                            ));
                      })
                ])
          : UiSpacer.emptySpace(),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: _isEditing
            ? () => _selectDate(context, initialDate, onDateSelected)
            : null,
        child: AbsorbPointer(
          child: TextFormField(
            readOnly: true,
            style: TextStyle(color: Colors.black),
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_id_license_date';
              }
              return null;
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
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
        onChanged: _isEditing
            ? onChanged
            : null, // Nếu không cho phép chọn, onChanged = null
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }

  Widget _buildDepartmentDropdown(String hint) {
    return DropdownButtonFormField<Departments>(
      value: selectedDepartment,
      hint: Text(hint),
      onChanged: _isEditing
          ? (Departments? newValue) {
              setState(() {
                selectedDepartment = newValue;
              });
            }
          : null, // Khi không cho phép chọn, onChanged = null
      items: departments.map((Departments department) {
        return DropdownMenuItem<Departments>(
          value: department,
          child: Text(department.departmentName),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabled: _isEditing, // Vô hiệu hóa cả dropdown nếu _isEditing là false
      ),
    );
  }

  Widget _buildPositionsDropdown(String hint) {
    return DropdownButtonFormField<Positions>(
      value: selectedPositions,
      hint: Text(hint),
      onChanged: _isEditing
          ? (Positions? newValue) {
              setState(() {
                selectedPositions = newValue;
              });
            }
          : null,
      items: positions.map((Positions position) {
        return DropdownMenuItem<Positions>(
          value: position,
          child: Text(
              position.positionName), // assuming department has a `name` field
        );
      }).toList(),
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabled: _isEditing),
    );
  }

  Widget _buildSalaryDropdown(String hint) {
    return DropdownButtonFormField<Salaries>(
      value: selectedSalarys,
      hint: Text(hint),
      onChanged: _isEditing
          ? (Salaries? newValue) {
              setState(() {
                selectedSalarys = newValue;
              });
            }
          : null,
      items: salarys.map((Salaries salary) {
        return DropdownMenuItem<Salaries>(
          value: salary,
          child:
              Text(salary.salaryId), // assuming department has a `name` field
        );
      }).toList(),
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabled: _isEditing),
    );
  }
}
