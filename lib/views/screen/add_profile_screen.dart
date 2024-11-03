import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddProfilePage extends StatefulWidget {
  // final Profiles? profile;

  const AddProfilePage({super.key});

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
        roleID: 0,
        marriage: _marriage,
        profileStatus: 1,
        //
        profileImage: "Hihi",
      );
      Provider.of<ProfilesViewModel>(context, listen: false)
          .addProfile(newProfile)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile added successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        // ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar(content: Text('Failed to add profile: $error')),
        // );
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
              "save",
              style: TextStyle(color: AppColor.boneWhite),
            ),
          )
        ],
        resizeToAvoidBottomInset: true,
        titletext: "add_new_profile",
        appBarColor: AppColor.primaryLightColor,
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(children: [
            CircleAvatar(),
            Divider(),
            //Profile id + full name
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
                ).w(254),
              ],
            ).py16(),
            //Birthday + Place of birth
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
                ).w(254),
              ],
            ),
            //Gender + Marriage
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
                ).w(200).px8(),
                _buildDateField('id_license_date'.tr(), _idLicenseDayController,
                    _idLicenseDay, (date) {
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
                        keyboardType: TextInputType.number)
                    .w(145),
              ],
            ).py(8),
            //Password
            CustomTextFormField(
              labelText: "password".tr(),
              textEditingController: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_enter_password'.tr();
                }
                return null;
              },
            ).p8(),
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
            ).p8(),
            //
          ]),
        )));
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
}
