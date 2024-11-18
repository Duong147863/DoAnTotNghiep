import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/assiginment_task.dart';
import 'package:nloffice_hrm/models/assignments_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/projects_model.dart';
import 'package:nloffice_hrm/models/tasks_model.dart';
import 'package:nloffice_hrm/view_models/assignment_view_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/view_models/task_view_model.dart';
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
  int _statusProject = 0;
  List<AssiginmentTask> assignments = [];
  AssiginmentTask? selectedassignments;
  List<Projects> project = [];
  Projects? selectedProjects;
  List<Tasks> tasks = [];
  Tasks? selectedTasks;
  @override
  void initState() {
    super.initState();
    _projectIdController.text = widget.projects!.projectId;
    _projectNameController.text = widget.projects!.projectName;
    _statusProject = widget.projects!.projectStatus;
    _loadAssignments();
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

  void _loadAssignments() async {
    try {
      await Provider.of<AssignmentsViewModel>(context, listen: false)
          .getAssignmentsDetails(widget.projects!.projectId);
      assignments = Provider.of<AssignmentsViewModel>(context, listen: false)
          .assiginmentTaskList;
      setState(() {
        if (assignments.isNotEmpty) {
          selectedassignments = assignments.firstWhere(
            (ass) => ass.projectId == widget.projects!.projectId,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Assignments $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Thông tin dự án',
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
      body: SingleChildScrollView(
        child: Padding(
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
                    Visibility(
                      visible: false, // Đặt thành false để ẩn widget
                      child: CustomTextFormField(
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
                    ),
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
                    _buildDropdownField('Status Project', _statusProject,
                        (value) {
                      setState(() {
                        _statusProject = value!;
                      });
                    }).px(8),
                    _buildAssignmentList(),
                    SizedBox(height: 20), // Tạo khoảng cách cuối cùng
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
                                      'Are you sure you want to delete this project?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _deleteProjects();
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
          DropdownMenuItem(
              value: 0, child: Text('Đang thực hiện')), // Trạng thái 0
          DropdownMenuItem(value: 1, child: Text('Hoàn Thành')), // Trạng thái 1
        ],
        onChanged: _isEditing
            ? onChanged
            : null, // Nếu không cho phép chọn, onChanged = null
        validator: (value) =>
            value == null ? 'Please select a Trạng thái' : null,
      ),
    );
  }

  Widget _buildAssignmentList() {
    if (assignments.isEmpty) {
      return Center(
        child: Text(
          "Không có thông tin task nào",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    }

    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.all(0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          assignments[index].isExpanded = isExpanded;
        });
      },
      children: assignments.map((process) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: Icon(Icons.personal_injury,
                  color: const Color.fromARGB(255, 68, 218, 255)),
              title: Text("Tên nhiệm vụ: ${process.taskName}",
                  style: TextStyle(fontSize: 16)),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chi tiết:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    SizedBox(height: 10),
                    Text("Tên nhân viên: ${process.profileName}",
                        style: TextStyle(fontSize: 16)),
                    Text("Tên Dự án: ${process.projectName}",
                        style: TextStyle(fontSize: 16)),
                    Text("nội dung nhiệm vụ: ${process.taskContent}",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          isExpanded: process.isExpanded,
        );
      }).toList(),
    );
  }
}
