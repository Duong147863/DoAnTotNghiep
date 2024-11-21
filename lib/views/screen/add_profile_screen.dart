import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/roles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/roles_view_models.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

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
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _birthday = DateTime.now();
  DateTime _idLicenseDay = DateTime.now();
  bool _gender = false; // Assuming `false` is Male, `true` is Female
  bool _marriage = false; // Assuming `false` is Male, `true` is Female
  //
  List<Departments> departments = [];
  Departments? selectedDepartment;
  List<Positions> positions = [];
  Positions? selectedPositions;
  List<Salaries> salarys = [];
  Salaries? selectedSalarys;
  List<Roles> roles = [];
  Roles? selectedRoles;
  String? _profileImageBase64;
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
  }

  // Method to load departments
  void _loadDepartments() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .fetchAllDepartments();
      departments = Provider.of<DeparmentsViewModel>(context, listen: false)
          .listDepartments;
      setState(() {
        // Check if widget.profile and widget.profile!.departmentId are not null
        if (widget.profile != null && widget.profile!.departmentId != 'BoD') {
          departments.removeWhere((e) => e.departmentID == 'BoD');
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
        profileStatus: 1,
        //
        roleID: selectedRoles!.roleID,
        departmentId: selectedDepartment!.departmentID,
        positionId: selectedPositions!.positionId,
        salaryId: selectedSalarys!.salaryId,
        profileImage: _profileImageBase64 ?? "",
      );
      Provider.of<ProfilesViewModel>(context, listen: false)
          .addProfile(newProfile)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile added successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add profile: $error')),
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
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
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
                  labelText: 'Mã nhân viên',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    return null;
                  },
                ).px8().w(150),
                CustomTextFormField(
                  textEditingController: _profileNameController,
                  labelText: 'Họ và tên',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    return null;
                  },
                ).w(254),
              ],
            ).py16(),
            //Birthday + Place of birth
            Row(
              children: [
                _buildDateBirthday('birthday', _birthdayController, _birthday,
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
                      return 'Không được để trống';
                    }
                    return null;
                  },
                ).w(254),
              ],
            ),
            Row(
              children: [
                Text('Phòng ban').px(8),
                _buildDepartmentDropdown('Chọn phòng ban').p(8).w(300),
              ],
            ),
            Row(
              children: [
                Text('Chức vụ').px(8),
                _buildPositionsDropdown('Chọn chức vụ').p(8).w(300),
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

            //Gender + Marriage
            Row(
              children: [
                Text('Giới tính').px(8),
                _buildDropdownField('Chọn giới tính', _gender, (value) {
                  setState(() {
                    _gender = value!;
                  });
                }).p(8).w(130),
                Text('marriage'),
                Radio(
                  value: true,
                  groupValue: _marriage,
                  onChanged: (value) {
                    setState(() {
                      _marriage = value!;
                    });
                  },
                ),
                Text('Rồi'),
                Radio(
                  value: false,
                  groupValue: _marriage,
                  onChanged: (value) {
                    setState(() {
                      _marriage = value!;
                    });
                  },
                ),
                Text('Chưa'),
              ],
            ),
            // ID number + license day
            Row(
              children: [
                CustomTextFormField(
                  textEditingController: _identifiNumController,
                  labelText: 'Số CCCD/CMND',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    if (value.length != 12) {
                      return 'Số CCCD/CMND không hợp lệ'; // Thông báo nhập đúng 10 chữ số
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
            CustomTextFormField(
              validator: (value) =>
                  value.isEmptyOrNull ? 'Please enter nation' : null,
              textEditingController: _nationController,
              labelText: 'Quê quán',
            ).p(8),
            //Email + phone
            Row(
              children: [
                CustomTextFormField(
                  textEditingController: _emailController,
                  labelText: 'Email',
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Email không hợp lệ';
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
                            return 'Số điện thoại không hợp lệ'; // Thông báo nhập đúng 10 chữ số
                          }
                          return null;
                        },
                        textEditingController: _phoneController,
                        labelText: 'Điện thoại',
                        maxLines: 1,
                        keyboardType: TextInputType.number)
                    .w(145),
              ],
            ).py(8),
            //Password
            CustomTextFormField(
              labelText: "Mật khẩu",
              textEditingController: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
            ).p8(),
            //Address
            CustomTextFormField(
              textEditingController: _temporaryAddressController,
              labelText: 'Tạm trú',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
            ).p8(),
            CustomTextFormField(
              textEditingController: _currentAddressController,
              labelText: 'Địa chỉ hường trú',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
            ).p8(),
            //
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
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
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

   Widget _buildDateLicenseDay(String label, TextEditingController controller,
    DateTime initialDate, Function(DateTime) onDateSelected) {
  return GestureDetector(
    onTap: () => _selectDate(context, initialDate, (selectedDate) {
      onDateSelected(selectedDate);
      setState(() {
        _idLicenseDay = selectedDate;
      });
    }),
    child: AbsorbPointer(
      child: TextFormField(
        readOnly: true,
        style: TextStyle(color: Colors.black),
        controller: controller,
        validator: (value) {
          if (controller.text.isNotEmpty) {
            try {
              DateTime selectedLicenseDay = DateTime.parse(controller.text);
              // Kiểm tra nếu ngày cấp CCCD phải lớn hơn 14 tuổi tính từ ngày sinh (_birthday)
              if (selectedLicenseDay.isBefore(_birthday.add(Duration(days: 365 * 14)))) {
                return 'CCCD phải trên 14 tuổi';
              }
            } catch (e) {
              return 'Định dạng ngày không hợp lệ';
            }
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
