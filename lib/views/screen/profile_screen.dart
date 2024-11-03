import 'package:flutter/material.dart';
import 'package:nloffice_hrm/api_services/app.service.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/constant/input.styles.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
  // Thêm các controller cần thiết cho các trường thông tin
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
  Image avatar = Image.asset('assets/images/male_avatar.png');
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
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline)),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: 
          ListView(
            children: [
               Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: avatar.image,
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
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  alignment: Alignment.center,
                  child: avatar,
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
            
                  // Birthday + Place of birth
                  Row(
                    children: [
                      _buildDateField(
                          'birthday', _birthdayController, _birthday, (date) {
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
}
