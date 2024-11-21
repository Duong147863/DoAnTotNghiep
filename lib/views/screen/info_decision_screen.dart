import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/decisions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/decisions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoDecisionScreen extends StatefulWidget {
  final Decisions? decisions;
  const InfoDecisionScreen({super.key, this.decisions});

  @override
  State<InfoDecisionScreen> createState() => _InfoDecisionScreenState();
}

class _InfoDecisionScreenState extends State<InfoDecisionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _decisionIdController = TextEditingController();
  final _decisionNameController = TextEditingController();
  final _assignDateController = TextEditingController();
  final _decisionContentController = TextEditingController();
  DateTime _assignDate = DateTime.now();
  int decisionStatus = 0;
  String? _decisionImageBase64;
  bool _isEditing = false;
  //
  List<Profiles> profile = [];
  Profiles? selectedProfile;
  @override
  void initState() {
    super.initState();
    _decisionImageBase64 = widget.decisions!.decisionImage;
    _decisionIdController.text = widget.decisions!.decisionId;
    _decisionNameController.text = widget.decisions!.decisionName;
    _assignDateController.text = DateFormat('dd/MM/yyyy')
        .format(widget.decisions!.assignDate)
        .toString();
    _assignDate=widget.decisions!.assignDate;
    _decisionContentController.text = widget.decisions!.decisionContent;
    decisionStatus = widget.decisions!.decisionStatus;
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      await Provider.of<ProfilesViewModel>(context, listen: false)
          .fetchAllProfiles();
      profile =
          Provider.of<ProfilesViewModel>(context, listen: false).listProfiles;
      if (profile.isNotEmpty) {
        selectedProfile = profile.firstWhere(
          (pro) => pro.profileId == widget.decisions!.profileId,
        );
      }
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Profile $error')),
      );
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
        _decisionImageBase64 = base64String;
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
                return 'Ngày cấp không được để trống';
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
          DropdownMenuItem(value: -1, child: Text('Từ Chối Duyệt')),
          DropdownMenuItem(value: 0, child: Text('Đợi Duyệt')),
          DropdownMenuItem(value: 1, child: Text('Đã Duyệt')),
        ],
        onChanged: _isEditing ? onChanged : null,
        validator: (value) =>
            value == null ? 'Please select a Trạng thái' : null,
      ),
    );
  }

   void _updateDecision() async {
    if (_formKey.currentState!.validate()) {
      final updatedDecision = Decisions(
        profileName: selectedProfile!.profileName,
        decisionId: _decisionIdController.text,
        decisionName: _decisionNameController.text,
        profileId: selectedProfile!.profileId,
        assignDate: _assignDate,
        decisionImage: _decisionImageBase64 ?? "",
        decisionStatus: decisionStatus,
        decisionContent: _decisionContentController.text
        );

      try {
        await Provider.of<DecisionsViewModel>(context, listen: false)
            .updateDecisions(updatedDecision);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Decisions Updated successfully!')),
        );
        Navigator.pop(context, updatedDecision);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Decisions: $e')),
        );
      }
    }
  }

  void _deleteDecisions() async {
    try {
      await Provider.of<DecisionsViewModel>(context, listen: false)
          .deleteDecisions(widget.decisions!.decisionId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Decisions deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Decisions: $e')),
      );
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
      titletext: "Thông tin quyết định",
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
            _updateDecision();
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
                       _deleteDecisions(); // Thực hiện xóa
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
              Center(
                child: GestureDetector(
                  onTap: _isEditing ? _pickImage : null,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Màu nền mặc định
                      image: _decisionImageBase64 != null
                          ? DecorationImage(
                              image: MemoryImage(
                                  base64Decode(_decisionImageBase64!)),
                              fit: BoxFit.cover,
                              onError: (error, stackTrace) {
                                print("Error loading image: $error");
                              },
                            )
                          : (widget.decisions!.decisionImage != null &&
                                  widget.decisions!.decisionImage!.isNotEmpty)
                              ? DecorationImage(
                                  image: MemoryImage(base64Decode(
                                      widget.decisions!.decisionImage!)),
                                  fit: BoxFit.cover,
                                  onError: (error, stackTrace) {
                                    print("Error loading image: $error");
                                  },
                                )
                              : null, // Không có ảnh thì không cần decoration image
                    ),
                    child: _decisionImageBase64 == null &&
                            (widget.decisions!.decisionImage == null ||
                                widget.decisions!.decisionImage!.isEmpty)
                        ? Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        enabled: false,
                        textEditingController: _decisionIdController,
                        labelText: 'Mã quyết định',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mã quyết định';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      CustomTextFormField(
                        enabled: _isEditing,
                        textEditingController: _decisionNameController,
                        labelText: 'Tên quyết định',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên quyết định';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Chọn hồ sơ", style: TextStyle(fontSize: 16)),
                      _buildProfileDropdown('Chọn hồ sơ').pOnly(top: 8),
                      SizedBox(height: 16),
                      _buildDateField(
                        'Ngày giao',
                        _assignDateController,
                        _assignDate,
                        (date) {
                          setState(() {
                            _assignDate = date;
                           _assignDateController.text =
                                  DateFormat('dd/MM/yyyy').format(_assignDate);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nội dung quyết định",
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      CustomTextFormField(
                        enabled: _isEditing,
                        textEditingController: _decisionContentController,
                        labelText: 'Nội dung quyết định',
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập nội dung quyết định';
                          }
                          return null;
                        },
                      ),
                      Text('Decision Hirings').px(8),
                      _buildDropdownField(
                        'Choose Status Decision',
                        decisionStatus,
                        (value) {
                          setState(() {
                            decisionStatus = value!;
                          });
                        },
                      ).px(8),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDropdown(String hint) {
    return DropdownButtonFormField<Profiles>(
      value: selectedProfile,
      hint: Text(hint),
      onChanged: _isEditing
          ? (Profiles? newValue) {
              setState(() {
                selectedProfile = newValue;
              });
            }
          : null,
      items: profile.map((Profiles profiles) {
        return DropdownMenuItem<Profiles>(
          value: profiles,
          child: Text(
              profiles.profileName), // assuming department has a `name` field
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
