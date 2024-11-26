import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/assignments_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/projects_model.dart';
import 'package:nloffice_hrm/models/tasks_model.dart';
import 'package:nloffice_hrm/view_models/assignment_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/view_models/task_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({super.key});

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Projects> projects = [];
  Projects? selectedProjects;
  List<Tasks> tasks = [];
  Tasks? selectedTask;
  List<Profiles> profiles = [];
  Profiles? selectedProfiles;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadProject();
    _loadTask();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newAssignmet = Assignments(
          profileId: selectedProfiles!.profileId,
          projectId: selectedProjects!.projectId,
          taskId: selectedTask!.taskId);
      Provider.of<AssignmentsViewModel>(context, listen: false)
          .createNewAssignments(newAssignmet)
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  void _loadProject() async {
    try {
      await Provider.of<ProjectsViewModel>(context, listen: false)
          .getAllProject();
      setState(() {
        projects =
            Provider.of<ProjectsViewModel>(context, listen: false).listProjects;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load project $error')),
      );
    }
  }

  void _loadTask() async {
    try {
      await Provider.of<TaskViewModel>(context, listen: false).getAllTask();
      tasks = Provider.of<TaskViewModel>(context, listen: false).listTasks;
      setState(() {
        tasks = Provider.of<TaskViewModel>(context, listen: false).listTasks;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load task $error')),
      );
    }
  }

  void _loadProfile() async {
    try {
      await Provider.of<ProfilesViewModel>(context, listen: false)
          .fetchAllProfiles();

      setState(() {
        profiles =
            Provider.of<ProfilesViewModel>(context, listen: false).listProfiles;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile $error ')),
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
      titletext: "thêm phân công",
      appBarColor: AppColor.primaryLightColor,
      actions: [
        TextButton.icon(
          onPressed: () {
            _submit();
          },
          icon: Icon(
            Icons.save_outlined,
            color: AppColor.aliceBlue,
          ),
          label: Text(
            "save",
            style: TextStyle(color: AppColor.aliceBlue),
          ),
        )
      ],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Dropdown
              _buildDropdownRow(
                  'Profile', _buildProfileDropdown('Chọn Profile')),

              // Project Dropdown
              _buildDropdownRow(
                  'Project', _buildProjectDropdown('Chọn Project')),

              // Task Dropdown
              Expanded(
                  child: _buildDropdownRow(
                      'Task', _buildTaskDropdown('Chọn Task'))),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build rows with dropdowns
  Widget _buildDropdownRow(String label, Widget dropdown) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(label).px(8),
          Expanded(child: dropdown),
        ],
      ),
    );
  }

  // Profile Dropdown
  Widget _buildProfileDropdown(String hint) {
    return DropdownButtonFormField<Profiles>(
      value: selectedProfiles,
      hint: Text(hint),
      onChanged: (Profiles? newValue) {
        setState(() {
          selectedProfiles = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Vui lòng chọn Profile';
        }
        return null;
      },
      items: profiles.map((Profiles profile) {
        return DropdownMenuItem<Profiles>(
          value: profile,
          child: Text(profile.profileName),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

// Project Dropdown
  Widget _buildProjectDropdown(String hint) {
    return DropdownButtonFormField<Projects>(
      value: selectedProjects,
      hint: Text(hint),
      onChanged: (Projects? newValue) {
        setState(() {
          selectedProjects = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Vui lòng chọn Project';
        }
        return null;
      },
      items: projects.map((Projects project) {
        return DropdownMenuItem<Projects>(
          value: project,
          child: Text(project.projectName),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

// Task Dropdown
  Widget _buildTaskDropdown(String hint) {
    return DropdownButtonFormField<Tasks>(
      value: selectedTask,
      hint: Text(hint),
      onChanged: (Tasks? newValue) {
        setState(() {
          selectedTask = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Vui lòng chọn Task';
        }
        return null;
      },
      items: tasks.where((task) => task.taskStatus == 0).map((Tasks task) {
        return DropdownMenuItem<Tasks>(
          value: task,
          child: Text(task.taskName),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
