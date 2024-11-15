import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/edit_relative_screen.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoRelativeScreen extends StatefulWidget {
  final Relatives profile;
  const InfoRelativeScreen({
    required this.profile,
  });

  @override
  _InfoRelativeScreenState createState() => _InfoRelativeScreenState();
}

class _InfoRelativeScreenState extends State<InfoRelativeScreen> {
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
  final idrelativeController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  bool _isEditing = false;
  List<Relatives> relatives = [];
  void initState() {
    super.initState();
    _profileIDController.text = widget.profile.profileId;
    _relativeNameController.text = widget.profile.relativesName;
    _phoneRelativeController.text = widget.profile.relativesPhone;
    _birthdayRelativeController.text =
        DateFormat('yyyy-MM-dd').format(widget.profile.relativesBirthday);
    _nationRelativeController.text = widget.profile.relativesNation;
    _temporaryAddressRelativeController.text =
        widget.profile.relativesTempAddress;
    _currentAddressRelativeController.text =
        widget.profile.relativesCurrentAddress;
    _relativeJobController.text = widget.profile.relativeJob;
    _relationshipController.text = widget.profile.relationship;
    idrelativeController.text = widget.profile.relativeId.toString();
  }

  void _updateRelatives() async {
    if (_formKey.currentState!.validate()) {
      final updatedRelative = Relatives(
        profileId: _profileIDController.text,
        relativesName: _relativeNameController.text,
        relationship: _relationshipController.text,
        relativesPhone: _phoneRelativeController.text,
        relativesBirthday: _birthdayRelative,
        relativesNation: _nationRelativeController.text,
        relativesTempAddress: _temporaryAddressRelativeController.text,
        relativesCurrentAddress: _currentAddressRelativeController.text,
        relativeJob: _relativeJobController.text,
        relativeId: int.tryParse(idrelativeController.text),
      );
      try {
        await Provider.of<RelativesViewModel>(context, listen: false)
            .updateRelatives(updatedRelative);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Relative Updated successfully!')),
        );
        Navigator.pop(context, updatedRelative);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Relative: $e')),
        );
      }
    }
  }

  void _deleteRelatives() async {
    try {
      final relativeId = widget.profile.relativeId;

      if (relativeId != null) {
        await Provider.of<RelativesViewModel>(context, listen: false)
            .deleteRelative(relativeId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Relative deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Relative ID is null. Cannot delete relative.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Relative: $e')),
      );
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
      titletext: 'Relative Info',
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    textEditingController: _profileIDController,
                    labelText: 'profile_id',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_profile_id';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _relativeNameController,
                    labelText: 'relative_name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_relative_name';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _relationshipController,
                    labelText: 'relationship',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_relationship';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                          enabled: _isEditing,
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
                      .px8(),
                  SizedBox(height: 16),
                  //Nation
                  CustomTextFormField(
                    enabled: _isEditing,
                    validator: (value) =>
                        value.isEmptyOrNull ? 'Please enter nation' : null,
                    textEditingController: _nationRelativeController,
                    labelText: 'relative_nation',
                  ).px(8),
                  SizedBox(height: 16),
                  _buildDateField('Ngày sinh', _birthdayRelativeController,
                      _birthdayRelative, (date) {
                    setState(() {
                      _birthdayRelative = date;
                      _birthdayRelativeController.text =
                          "${_birthdayRelative.toLocal()}".split(' ')[0];
                    });
                  }).px(8),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _relativeJobController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_relativeJob';
                      }
                      return null;
                    },
                    labelText: 'relative_job',
                  ).px(8),
                  SizedBox(height: 16),
                  //Address
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _temporaryAddressRelativeController,
                    labelText: 'temp_address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_temp_address';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _currentAddressRelativeController,
                    labelText: 'current_address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_current_address';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateRelatives,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Delete'),
                                content: Text(
                                    'Are you sure you want to delete this position?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Đóng dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Đóng dialog
                                      _deleteRelatives(); // Thực hiện xóa
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
