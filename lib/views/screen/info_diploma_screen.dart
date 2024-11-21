import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/view_models/diplomas_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_diploma_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoDiplomaScreen extends StatefulWidget {
  final Diplomas? diplomas;

  const InfoDiplomaScreen({super.key, this.diplomas});

  @override
  _InfoDiplomaScreenState createState() => _InfoDiplomaScreenState();
}

class _InfoDiplomaScreenState extends State<InfoDiplomaScreen> {
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
  bool _isEditing = false;
  bool isImagePickerActive = false;
  String? _diplomaImageBase64;

  @override
  void initState() {
    super.initState();
    _profileIDController.text = widget.diplomas!.profileId;
    _diplomaIDController.text = widget.diplomas!.diplomaId;
    _diplomaDegreeNameController.text = widget.diplomas!.diplomaName;
    _diplomaImageBase64 = widget.diplomas!.diplomaImage;
    _modeOfStudyController.text = widget.diplomas!.modeOfStudy;
    _liscenseDateController.text = DateFormat('dd/MM/yyyy')
        .format(widget.diplomas!.licenseDate)
        .toString();
    _liscenseDate = widget.diplomas!.licenseDate;
    _majorController.text = widget.diplomas!.major!;
    _rankingController.text = widget.diplomas!.ranking;
    _grantedByController.text = widget.diplomas!.grantedBy;
    _diplomaTypeController.text = widget.diplomas!.diplomaType;
  }

  void _updateDiploma() async {
    if (_formKey.currentState!.validate()) {
      final updatedDiplomas = Diplomas(
          diplomaId: _diplomaIDController.text,
          diplomaName: _diplomaDegreeNameController.text,
          diplomaImage: _diplomaImageBase64 ?? "",
          modeOfStudy: _modeOfStudyController.text,
          ranking: _rankingController.text,
          licenseDate: _liscenseDate,
          major: _majorController.text,
          grantedBy: _grantedByController.text,
          diplomaType: _diplomaTypeController.text,
          profileId: _profileIDController.text);

      try {
        await Provider.of<DiplomasViewModel>(context, listen: false)
            .updateDiplomas(updatedDiplomas);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diplomas Updated successfully!')),
        );
        Navigator.pop(context, updatedDiplomas);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Diplomas: $e')),
        );
      }
    }
  }

  void _deleteDiploma() async {
    try {
      await Provider.of<DiplomasViewModel>(context, listen: false)
          .deleteDiplomas(widget.diplomas!.diplomaId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Department deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete position: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    if (isImagePickerActive) {
      return;
    }

    try {
      isImagePickerActive = true;

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
          _diplomaImageBase64 = base64String;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $error')),
      );
    } finally {
      isImagePickerActive = false;
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
                return 'please_id ngày cấp';
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      resizeToAvoidBottomInset: true,
      titletext: "Info Diploma Screen",
      appBarColor: AppColor.primaryLightColor,
      actions: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isEditing = true; // Chuyển đổi chế độ chỉnh sửa
            });
          },
          icon: Icon(
            Icons.edit,
            color: AppColor.boneWhite,
          ),
          label: Text(
            "Sửa",
            style: TextStyle(color: AppColor.boneWhite),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            _updateDiploma();
          },
          icon: Icon(
            Icons.save,
            color: AppColor.boneWhite,
          ),
          label: Text(
            "Save",
            style: TextStyle(color: AppColor.boneWhite),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Delete'),
                  content:
                      Text('Are you sure you want to delete this diploma?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Đóng dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Đóng dialog
                        _deleteDiploma(); // Thực hiện xóa
                      },
                      child: Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: Container(
                  width: 400, // Chiều rộng của ảnh
                  height: 400, // Chiều cao của ảnh
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Màu nền mặc định
                    image: _diplomaImageBase64 != null
                        ? DecorationImage(
                            image:
                                MemoryImage(base64Decode(_diplomaImageBase64!)),
                            fit: BoxFit.cover,
                            onError: (error, stackTrace) {
                              print("Error loading image: $error");
                            },
                          )
                        : (widget.diplomas!.diplomaImage != null &&
                                widget.diplomas!.diplomaImage!.isNotEmpty)
                            ? DecorationImage(
                                image: MemoryImage(base64Decode(
                                    widget.diplomas!.diplomaImage!)),
                                fit: BoxFit.cover,
                                onError: (error, stackTrace) {
                                  print("Error loading image: $error");
                                },
                              )
                            : null, // Không có ảnh thì không cần decoration image
                  ),
                  child: _diplomaImageBase64 == null &&
                          (widget.diplomas!.diplomaImage == null ||
                              widget.diplomas!.diplomaImage!.isEmpty)
                      ? Icon(Icons.person,
                          size: 30,
                          color: Colors.grey) // Hiển thị icon khi không có ảnh
                      : null, // Khi có ảnh, không hiển thị icon
                ),
              ),
              Divider(),
              Row(
                children: [
                  CustomTextFormField(
                    enabled: false,
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
                    enabled: _isEditing,
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
                    enabled: _isEditing,
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
                    enabled: _isEditing,
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
                    enabled: _isEditing,
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
                    enabled: _isEditing,
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
                    enabled: _isEditing,
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
                      DateFormat('dd/MM/yyyy').format(_liscenseDate);
                });
              }).px(8).w(150),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
