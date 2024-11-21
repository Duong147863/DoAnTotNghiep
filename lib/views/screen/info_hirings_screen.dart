import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/hirings_model.dart';
import 'package:nloffice_hrm/view_models/hirings_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
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
  bool _isEditing = false;
  final idHiringsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _profileNameController.text = widget.hirings!.profileName;
    _birthdayController.text =
        DateFormat('dd/MM/yyyy').format(widget.hirings!.birthday).toString();
    _birthday = widget.hirings!.birthday;
    _hiringProfileImageBase64 = widget.hirings!.hiringProfileImage;
    _placeOfBirthController.text = widget.hirings!.placeOfBirth;
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
  }

  void _updateHirings() async {
    if (_formKey.currentState!.validate()) {
      final updatedHirings = Hirings(
          profileName: _profileNameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          birthday: _birthday,
          currentAddress: _currentAddressController.text,
          placeOfBirth: _placeOfBirthController.text,
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
                return 'Vui lòng nhập ngày sinh';
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
          DropdownMenuItem(value: -1, child: Text('Lưu Trữ')),
          DropdownMenuItem(value: 0, child: Text('Đợi Lọc')),
          DropdownMenuItem(value: 1, child: Text('Đã Liên Hệ')),
          DropdownMenuItem(value: 2, child: Text('Đã Phỏng Vấn')),
        ],
        onChanged: _isEditing ? onChanged : null,
        validator: (value) =>
            value == null ? 'Please select a Trạng thái' : null,
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
                onTap: _isEditing ? _pickImage : null,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _hiringProfileImageBase64 != null
                      ? MemoryImage(base64Decode(_hiringProfileImageBase64!))
                      : null,
                  child: _hiringProfileImageBase64 == null
                      ? Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              Divider(),
              // Profile name and Apply For
              Row(
                children: [
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _applyForController,
                    labelText: 'Apply for',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter Apply For'
                        : null,
                  ).px8().w(150),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _profileNameController,
                    labelText: 'Full Name',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter full name'
                        : null,
                  ).w(230), // Adjust width to 150 instead of 50
                ],
              ).py16(),
              // Birthday and Place of Birth
              Row(
                children: [
                  _buildDateField('Birthday', _birthdayController, _birthday,
                      (date) {
                    setState(() {
                      _birthday = date;
                      _birthdayController.text =
                          DateFormat('dd/MM/yyyy').format(_birthday);
                    });
                  }).px8().w(150),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _placeOfBirthController,
                    labelText: 'Place of Birth',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter place of birth'
                        : null,
                  ).w(230),
                ],
              ),
              // Gender and Nation
              Row(
                children: [
                  Text('Gender').px8(),
                  _buildDropdownField('Chọn giới tính', _gender, (value) {
                    setState(() {
                      _gender = value!;
                    });
                  }).p(8).w(130),
                  CustomTextFormField(
                    enabled: _isEditing,
                    validator: (value) =>
                        value.isEmptyOrNull ? 'Please enter nation' : null,
                    textEditingController: _nationController,
                    labelText: 'Nation',
                  ).p(8).w(200),
                ],
              ),
              // Email and Phone
              Row(
                children: [
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _emailController,
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ).px4().w(225),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _phoneController,
                    labelText: 'Phone',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (value.length != 10) {
                        return 'Please enter valid phone number';
                      }
                      return null;
                    },
                  ).w(155),
                ],
              ).py8(),
              Row(
                children: [
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _workExperienceController,
                    labelText: 'Work Experience',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter Work Experience'
                        : null,
                  ).px4().w(225),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _currentAddressController,
                    labelText: 'Current Address',
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter Current Address'
                        : null,
                  ).w(155),
                ],
              ).py8(),
              // Education Level
              CustomTextFormField(
                enabled: _isEditing,
                labelText: "Education Level",
                textEditingController: _educationalLevelController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter education level'
                    : null,
              ).px8().py(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Hirings').px(8),
                  _buildDropdownStatusField(
                    'Choose Status Hirings',
                    status,
                    (value) {
                      setState(() {
                        status = value!;
                      });
                    },
                  ).px(8),
                ],
              )
            ],
          ),
        ).px8(),
      ),
    );
  }
}
