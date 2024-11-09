import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/api_services/app.service.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/constant/input.styles.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/repository/profiles_repo.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
  String ?_department;
  List<Departments> departments = [];
  Departments? selectedDepartment;
  List<Positions> positions = [];
  Positions? selectedPositions;
  List<Salaries> salarys = [];
  Salaries? selectedSalarys;
  
  void initState() {
    super.initState();
    _profileIDController.text = widget.profile!.profileId;
    _profileNameController.text = widget.profile!.profileName;
    _birthdayController.text =
        DateFormat('dd-MM-yyy').format(widget.profile!.birthday);
    _placeOfBirthController.text = widget.profile!.placeOfBirth;
    _gender = widget.profile!.gender;
    _identifiNumController.text = widget.profile!.identifiNum;
    _idLicenseDayController.text =
        DateFormat('yyyy-MM-dd').format(widget.profile!.idLicenseDay);
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
  }

  // Method to load departments
  void _loadDepartments() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .fetchAllDepartments();
      departments = Provider.of<DeparmentsViewModel>(context, listen: false)
          .listDepartments;
      setState(() {
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
      positions =
          Provider.of<PositionsViewModel>(context, listen: false).listPositions;
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load departments')),
      );
    }
  }

  void _loadSalaries() async {
    try {
      await Provider.of<SalariesViewModel>(context, listen: false)
          .fetchAllSalaries();
      salarys =
          Provider.of<SalariesViewModel>(context, listen: false).listSalaries;
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load salaries')),
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
        actions: [
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
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete_outline, color: Colors.red)),
        ],
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
                      : (widget.profile!.profileImage != null &&
                              widget.profile!.profileImage!.isNotEmpty
                          ? MemoryImage(
                              base64Decode(widget.profile!.profileImage!))
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
                    labelText: 'profile_id'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_profile_id'.tr();
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8().w(150),
                  CustomTextFormField(
                    textEditingController: _profileNameController,
                    labelText: 'full_name'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_full_name'.tr();
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
                  _buildDateField('birthday', _birthdayController, _birthday,
                      (date) {
                    setState(() {
                      _birthday = date;
                      _birthdayController.text =
                          "${_birthday.toLocal()}".split(' ')[0];
                    });
                  }).px(8).w(150),
                  CustomTextFormField(
                    textEditingController: _placeOfBirthController,
                    labelText: 'place_of_birth'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_place_of_birth'.tr();
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).w(254),
                ],
              ),
              Row(
                children: [
                  Text('Department'.tr()).px(8),
                  _buildDepartmentDropdown('Choose Department').p(8).w(300),
                ],
              ),
              Row(
                children: [
                  Text('Position'.tr()).px(8),
                  _buildPositionsDropdown('Choose Postion').p(8).w(300),
                ],
              ),
              Row(
                children: [
                  Text('Salary'.tr()).px(8),
                  _buildSalaryDropdown('Choose Salary').p(8).w(300),
                ],
              ),
              // Gender + Marriage
              Row(
                children: [
                  Text('gender'.tr()).px(8),
                  _buildDropdownField('Chọn giới tính', _gender, (value) {
                    setState(() {
                      _gender = value!;
                    });
                  }).p(8).w(130),
                  Text('marriage'.tr()),
                  Radio(
                    value: true,
                    groupValue: _marriage,
                    onChanged: (value) {
                      setState(() {
                        _marriage = value!;
                      });
                    },
                  ),
                  Text('yes'.tr()),
                  Radio(
                    value: false,
                    groupValue: _marriage,
                    onChanged: (value) {
                      setState(() {
                        _marriage = value!;
                      });
                    },
                  ),
                  Text('no'.tr()),
                ],
              ),

              // ID number + license day
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _identifiNumController,
                    labelText: 'id_num'.tr(),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_phone_number'.tr();
                      }
                      if (value.length != 12) {
                        return 'please_enter_valid_id_num'
                            .tr(); // Thông báo nhập đúng 10 chữ số
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).w(200).px8(),
                  _buildDateField('id_license_date'.tr(),
                      _idLicenseDayController, _idLicenseDay, (date) {
                    setState(() {
                      _idLicenseDay = date;
                      _idLicenseDayController.text =
                          "${_idLicenseDay.toLocal()}".split(' ')[0];
                    });
                  }).w(184),
                ],
              ).py8(),
              //Nation
              CustomTextFormField(
                validator: (value) =>
                    value.isEmptyOrNull ? 'Please enter nation' : null,
                textEditingController: _nationController,
                labelText: 'nation'.tr(),
                enabled: _isEditing,
              ).p(8),
              //Email + phone
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _emailController,
                    labelText: 'email'.tr(),
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_email'.tr();
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'please_enter_valid_email'.tr();
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px4().w(258),
                  CustomTextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_phone_number'.tr();
                            }
                            if (value.length != 10) {
                              return 'please_enter_valid_phone_number'
                                  .tr(); // Thông báo nhập đúng 10 chữ số
                            }
                            return null;
                          },
                          textEditingController: _phoneController,
                          labelText: 'phone'.tr(),
                          maxLines: 1,
                          enabled: _isEditing,
                          keyboardType: TextInputType.number)
                      .w(145),
                ],
              ).py(8),
              //Password
              // CustomTextFormField(
              //   labelText: "password".tr(),
              //   textEditingController: _passwordController,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'please_enter_password'.tr();
              //     }
              //     return null;
              //   },
              //   enabled: _isEditing,
              // ).p8(),
              //Address
              CustomTextFormField(
                textEditingController: _temporaryAddressController,
                labelText: 'temp_address'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_temp_address'.tr();
                  }
                  return null;
                },
                enabled: _isEditing,
              ).p8(),
              CustomTextFormField(
                textEditingController: _currentAddressController,
                labelText: 'current_address'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_current_address'.tr();
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
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _selectDate(context, initialDate, onDateSelected),
        child: AbsorbPointer(
          child: TextFormField(
            readOnly: true,
            style: TextStyle(color: Colors.black),
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'please_id_license_date'.tr();
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
          DropdownMenuItem(value: false, child: Text('Man')),
          DropdownMenuItem(value: true, child: Text('Woman')),
        ],
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }

  Widget _buildDepartmentDropdown(String hint) {
    return DropdownButtonFormField<Departments>(
      value: selectedDepartment,
      hint: Text(hint),
      onChanged: (Departments? newValue) {
        setState(() {
          selectedDepartment = newValue;
        });
      },
      items: departments.map((Departments department) {
        return DropdownMenuItem<Departments>(
          value: department,
          child: Text(department
              .departmentName), // assuming department has a `name` field
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPositionsDropdown(String hint) {
    return DropdownButtonFormField<Positions>(
      value: selectedPositions,
      hint: Text(hint),
      onChanged: (Positions? newValue) {
        setState(() {
          selectedPositions = newValue;
        });
      },
      items: positions.map((Positions position) {
        return DropdownMenuItem<Positions>(
          value: position,
          child: Text(
              position.positionName), // assuming department has a `name` field
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
}
