import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class AddDecisionScreen extends StatefulWidget {
  @override
  _AddDecisionScreenState createState() => _AddDecisionScreenState();
}

class _AddDecisionScreenState extends State<AddDecisionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _decisionIdController = TextEditingController();
  final _decisionNameController = TextEditingController();
  final _assignDateController = TextEditingController();
  final _decisionContentController = TextEditingController();
  DateTime _assignDate = DateTime.now();
  int decisionStatus = 0;
  String? _decisionImageBase64;
  //
  List<Profiles> profile = [];
  Profiles? selectedProfile;
  @override
  void dispose() {
    _decisionNameController.dispose();
    _decisionNameController.dispose();
    _assignDateController.dispose();
    _decisionContentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final createNewDecision = Decisions(
          decisionId: _decisionIdController.text,
          decisionName: _decisionNameController.text,
          profileId: selectedProfile!.profileId,
          assignDate: _assignDate,
          decisionImage: _decisionImageBase64 ?? "",
          decisionStatus: decisionStatus,
          decisionContent: _decisionContentController.text);
      Provider.of<DecisionsViewModel>(context, listen: false)
          .createNewDecisions(createNewDecision)
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  void _loadProfile() async {
    try {
      await Provider.of<ProfilesViewModel>(context, listen: false)
          .fetchAllProfiles();
      profile =
          Provider.of<ProfilesViewModel>(context, listen: false).listProfiles;
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
        onTap: () => _selectDate(context, initialDate, onDateSelected),
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      resizeToAvoidBottomInset: true,
      titletext: "Tạo quyết định mới",
      appBarColor: AppColor.primaryLightColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: _decisionImageBase64 != null
                          ? DecorationImage(
                              image: MemoryImage(
                                  base64Decode(_decisionImageBase64!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _decisionImageBase64 == null
                        ? Icon(Icons.add_a_photo, size: 30)
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
                                "${_assignDate.toLocal()}".split(' ')[0];
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
                    ],
                  ),
                ),
              ),
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
                  child: Text('Tạo quyết định mới'),
                ),
              ),
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
      onChanged: (Profiles? newValue) {
        setState(() {
          selectedProfile = newValue;
        });
      },
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
