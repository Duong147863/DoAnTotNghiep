import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddRelativeScreen extends StatefulWidget {
  final Profiles? profile;

  const AddRelativeScreen({super.key, this.profile});

  @override
  _AddRelativeScreenState createState() => _AddRelativeScreenState();
}

class _AddRelativeScreenState extends State<AddRelativeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _relativeNameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _phoneRelativeController = TextEditingController();
  final _birthdayRelativeController = TextEditingController();
  DateTime _birthdayRelative = DateTime.now();
  final _nationRelativeController = TextEditingController();
  final _temporaryAddressRelativeController = TextEditingController();
  final _currentAddressRelativeController = TextEditingController();
  final _relativeJobController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    super.initState();
    _profileIDController.text=widget.profile!.profileId;
  }

  // void dispose() {
  //   _profileIDController.dispose();
  //   _relativeNameController.dispose();
  //   _relationshipController.dispose();
  //   _phoneRelativeController.dispose();
  //   _birthdayRelativeController.dispose();
  //   _nationRelativeController.dispose();
  //   _temporaryAddressRelativeController.dispose();
  //   _currentAddressRelativeController.dispose();
  //   super.dispose();
  // }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final addNewRelative = Relatives(
        profileId: _profileIDController.text,
        relativesName: _relativeNameController.text,
        relationship: _relationshipController.text,
        relativesPhone: _phoneRelativeController.text,
        relativesBirthday: _birthdayRelative,
        relativesNation: _nationRelativeController.text,
        relativesTempAddress: _temporaryAddressRelativeController.text,
        relativesCurrentAddress: _currentAddressRelativeController.text,
        relativeJob: _relativeJobController.text,
      );
      print('Data to submit: ${addNewRelative.toJson()}');
      Provider.of<RelativesViewModel>(context, listen: false)
          .addRelative(addNewRelative)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Relative added successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add relative: $error')),
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
        titletext: "Add New Relatives",
        appBarColor: AppColor.primaryLightColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              Row(
                children: [
                  CustomTextFormField(
                    enabled: false,
                    textEditingController: _profileIDController,
                    labelText: 'profile_id',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_profile_id';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  CustomTextFormField(
                    textEditingController: _relativeNameController,
                    labelText: 'full_name_relative',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_full_name_relative';
                      }
                      return null;
                    },
                  ).w(254),
                ],
              ).py16(),
              //relationship + relativephone
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _relationshipController,
                    labelText: 'relationship',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_relationship';
                      }
                      return null;
                    },
                  ).px8().w(150),
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
                          textEditingController: _phoneRelativeController,
                          labelText: 'phone',
                          maxLines: 1,
                          keyboardType: TextInputType.number)
                      .w(254),
                ],
              ),
              //Nation
              CustomTextFormField(
                validator: (value) =>
                    value.isEmptyOrNull ? 'Please enter nation' : null,
                textEditingController: _nationRelativeController,
                labelText: 'relative_nation',
              ).p(8),
              //Phone
              Row(
                children: [
                  _buildDateField('Ngày sinh', _birthdayRelativeController,
                      _birthdayRelative, (date) {
                    setState(() {
                      _birthdayRelative = date;
                      _birthdayRelativeController.text =
                          "${_birthdayRelative.toLocal()}".split(' ')[0];
                    });
                  }).px(8).w(150),
                  CustomTextFormField(
                    textEditingController: _relativeJobController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_relativeJob';
                      }
                      return null;
                    },
                    labelText: 'relative_job',
                  ).w(254),
                ],
              ).py(8),
              //Address
              CustomTextFormField(
                textEditingController: _temporaryAddressRelativeController,
                labelText: 'temp_address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_temp_address';
                  }
                  return null;
                },
              ).p8(),
              CustomTextFormField(
                textEditingController: _currentAddressRelativeController,
                labelText: 'current_address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_current_address';
                  }
                  return null;
                },
              ).p8(),
              //
            ]),
          ),
        ));
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
                return 'please_enter_relative_birthday';
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
}
