import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/api_services/department_service.dart'; // Import service
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_department_screen.dart';
import 'package:nloffice_hrm/views/screen/info_department_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentsScreen extends StatefulWidget {
  @override
  _DepartmentsScreenState createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  List<Departments> departments = [];
  String _title = 'Danh sách phòng ban';

  @override
  void initState() {
    super.initState();
    _loadTitle();
    // _fetchDepartments();
  }

  Future<void> _loadTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _title = prefs.getString('departmentsTitle') ?? 'Danh sách phòng ban';
    });
  }

  // Future<void> _fetchDepartments() async {
  //   try {
  //     List<Departments> fetchedDepartments = await fetchDepartmentsData();
  //     setState(() {
  //       departments = fetchedDepartments;
  //     });
  //   } catch (error) {
  //     print('Error fetching departments: $error');
  //   }
  // }

  Future<void> _saveTitle(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('departmentsTitle', title);
  }

  void _changeTitle() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController =
            TextEditingController(text: _title);
        return AlertDialog(
          title: Text('Đổi tên tiêu đề'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Nhập tên tiêu đề mới'),
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                setState(() {
                  _title = titleController.text;
                });
                _saveTitle(titleController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDelete(Departments department) {
    setState(() {
      departments = departments
          .where((dep) => dep.departmentID != department.departmentID)
          .toList();
    });
  }

  void _handleAdd(Departments newDepartment) {
    setState(() {
      departments.add(newDepartment);
    });
  }

  List<Departments> filteredDepartments = [];
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDepartments = departments;
      } else {
        filteredDepartments = departments.where((department) {
          return department.departmentName!
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
Widget build(BuildContext context) {
  return BasePage(
    showAppBar: true,
    appBar: AppBar(
      title: Text(_title),
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.black),
          onPressed: _changeTitle,
        ),
      ],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            suggestions: departments
                .map((department) => department.departmentName ?? 'Unnamed')
                .toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
  child: ListView.builder(
    itemCount: filteredDepartments.isNotEmpty ? filteredDepartments.length : departments.length,
    itemBuilder: (context, index) {
      final department = filteredDepartments.isNotEmpty ? filteredDepartments[index] : departments[index];
      if (department.departmentStatus == 0 || department.departmentName == null) return Container();
      return ListTile(
        title: Text(department.departmentName ?? 'Unnamed Department'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DepartmentInfoScreen(
                department: department,
                onDelete: () => _handleDelete(department),
              ),
            ),
          );
        },
      );
    },
  ),
),
      ],
    ),
    fab: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddDepartmentScreen(onAdd: _handleAdd),
          ),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
    ),
  );
}
}