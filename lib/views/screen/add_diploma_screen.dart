import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/diplomas_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddDiplomaScreen extends StatefulWidget {
  final Profiles? profile;
  const AddDiplomaScreen({super.key, this.profile});
  @override
  _AddDiplomaScreenState createState() => _AddDiplomaScreenState();
}

class _AddDiplomaScreenState extends State<AddDiplomaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diplomaIDController = TextEditingController();
  final _diplomaDegreeNameController = TextEditingController();
  final _modeOfStudyController = TextEditingController();
  final _rankingController = TextEditingController();
  final _liscenseDateController = TextEditingController();
  final _majorController = TextEditingController();
  final _grantedByController = TextEditingController();
  final _diplomaTypeController = TextEditingController();
  final _profileIDController = TextEditingController();
  DateTime _liscenseDate = DateTime.now();

  //
  File? _diplomaImageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _profileIDController.text=widget.profile!.profileId;
  }
  void dispose() {
    _diplomaIDController.dispose();
    _diplomaDegreeNameController.dispose();
    _modeOfStudyController.dispose();
    _rankingController.dispose();
    _liscenseDateController.dispose();
    _majorController.dispose();
    _diplomaTypeController.dispose();
    _profileIDController.dispose();
    _grantedByController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _diplomaImageFile = File(image.path);
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final createNewDiploma = Diplomas(
        diplomaId: _diplomaIDController.text,
        diplomaName: _diplomaDegreeNameController.text,
        diplomaImage: _diplomaImageFile?.path ?? '',
        modeOfStudy: _modeOfStudyController.text,
        ranking: _rankingController.text,
        licenseDate: _liscenseDate,
        major: _majorController.text,
        grantedBy: _grantedByController.text,
        diplomaType: _diplomaTypeController.text,
        profileId: _profileIDController.text,
      );
      Provider.of<DiplomasViewModel>(context, listen: false)
          .AddDiploma(createNewDiploma)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile added successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add Diplomar: $error')),
        );
      });
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
      resizeToAvoidBottomInset: true,
      titletext: "Add New Diploma",
      appBarColor: AppColor.primaryLightColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _diplomaImageFile == null
                    ? Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.add_a_photo, color: Colors.grey[700]),
                      )
                    : Image.file(_diplomaImageFile!, height: 150),
              ).pOnly(bottom: 16),
              Divider(),
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _diplomaIDController,
                    labelText: 'ID Diploma',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_id_diploma';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  CustomTextFormField(
                    textEditingController: _diplomaDegreeNameController,
                    labelText: 'Diploma Degree Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_Diploma_Degree_Name';
                      }
                      return null;
                    },
                  ).w(229),
                ],
              ).py16(),
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _grantedByController,
                    labelText: 'Granted By',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_granted_by';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  CustomTextFormField(
                    textEditingController: _modeOfStudyController,
                    labelText: 'Mode Of Study',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_mode_of_study';
                      }
                      return null;
                    },
                  ).w(229),
                ],
              ).py16(),
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _rankingController,
                    labelText: 'Ranking',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_ranking';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  CustomTextFormField(
                    textEditingController: _majorController,
                    labelText: 'Major',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_major';
                      }
                      return null;
                    },
                  ).w(229),
                ],
              ).py16(),
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _diplomaTypeController,
                    labelText: 'Diploma Type',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_diploma_type';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  CustomTextFormField(
                    enabled: false,
                    textEditingController: _profileIDController,
                    labelText: 'Profile ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_profile_id';
                      }
                      return null;
                    },
                  ).w(229),
                ],
              ).py16(),
              _buildDateField(
                  'License Date', _liscenseDateController, _liscenseDate,
                  (date) {
                setState(() {
                  _liscenseDate = date;
                  _liscenseDateController.text =
                      "${_liscenseDate.toLocal()}".split(' ')[0];
                });
              }).px(8).w(150),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    backgroundColor: AppColor.primaryDarkColor,
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Add Diploma'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
