import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/projects_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoProjectScreen extends StatefulWidget {
  final Projects? projects;
  const InfoProjectScreen({super.key, this.projects});

  @override
  State<InfoProjectScreen> createState() => _InfoProjectScreenState();
}

class _InfoProjectScreenState extends State<InfoProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectIdController = TextEditingController();
  final _projectNameController = TextEditingController();
  bool _isEditing = false;
  int _statusProject=0;
    @override
  void initState() {
    super.initState();
    _projectIdController.text=widget.projects!.projectId;
    _projectNameController.text=widget.projects!.projectName;
    _statusProject=widget.projects!.projectStatus;
  }
  void _updateProject() async {
    if (_formKey.currentState!.validate()) {
      final updatedProjects = Projects(
        projectId: _projectIdController.text,
        projectName: _projectNameController.text,
        projectStatus: _statusProject, 
      );
      try {
        await Provider.of<ProjectsViewModel>(context, listen: false)
            .updateProject(updatedProjects);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project Updated successfully!')),
        );
        Navigator.pop(context, updatedProjects);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Project: $e')),
        );
      }
    }
  }

  void _deleteProjects() async {
    try {
      await Provider.of<ProjectsViewModel>(context, listen: false)
          .deleteProject(widget.projects!.projectId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Project): $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Shifts Info Screen',
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
                    textEditingController: _projectIdController,
                    labelText: 'project ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_project_ID';
                      }
                      return null;
                    },
                    enabled: false,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _projectNameController,
                    labelText: 'project Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_project_Name';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                     Text('Status Project').px(8),
                  _buildDropdownField('Status Project', _statusProject, (value) {
                    setState(() {
                      _statusProject = value!;
                    });
                  }).px(8),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateProject,
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
                                    'Are you sure you want to delete this shifts?'),
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
                                      _deleteProjects(); // Thực hiện xóa
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
        DropdownMenuItem(value: 0, child: Text('Đang làm')),  // Trạng thái 0
        DropdownMenuItem(value: 1, child: Text('Hoàn Thành')), // Trạng thái 1
      ],
      onChanged: _isEditing
          ? onChanged
          : null, // Nếu không cho phép chọn, onChanged = null
      validator: (value) => value == null ? 'Please select a status project' : null,
    ),
  );
}
}
