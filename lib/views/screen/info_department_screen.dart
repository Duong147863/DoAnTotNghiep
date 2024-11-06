import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class DepartmentInfoScreen extends StatefulWidget {
  final Departments? departments;

  DepartmentInfoScreen({super.key, this.departments});

  @override
  _DepartmentInfoScreenState createState() => _DepartmentInfoScreenState();
}

class _DepartmentInfoScreenState extends State<DepartmentInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _departmentIDController = TextEditingController();
  final _departmentNameController = TextEditingController();
  bool _isEditing = false;
  void initState() {
    super.initState();
    _departmentIDController.text = widget.departments!.departmentID;
    _departmentNameController.text = widget.departments!.departmentName;
  }

  void _updateDepartment() async {
    if (_formKey.currentState!.validate()) {
      final updatedDeparment = Departments(
          departmentID: _departmentIDController.text,
          departmentName: _departmentNameController.text);
      try {
        await Provider.of<DeparmentsViewModel>(context, listen: false)
            .updateDepartment(updatedDeparment);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department Updated successfully!')),
        );
        Navigator.pop(context, updatedDeparment);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Department: $e')),
        );
      }
    }
  }

  void _deleteDepartment() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .deleteDepartment(widget.departments!.departmentID);
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'department_info'.tr(),
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
                    textEditingController: _departmentIDController,
                    labelText: 'department_id'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_profile_id'.tr();
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _departmentNameController,
                    labelText: 'department_name'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_full_name'.tr();
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateDepartment,
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
                        onPressed: _deleteDepartment,
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
}
