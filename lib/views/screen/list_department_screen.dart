import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_department_screen.dart';
import 'package:provider/provider.dart';

class DepartmentsScreen extends StatefulWidget {
  @override
  _DepartmentsScreenState createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  List<Departments> departments = [];

  @override
  void initState() {
    super.initState();
    Provider.of<DeparmentsViewModel>(context, listen: false).fetchAllDepartments();
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

  void _handleUpdate(Departments updatedDepartment) {
    setState(() {
      int index = departments.indexWhere((dep) => dep.departmentID == updatedDepartment.departmentID);
      if (index != -1) {
        departments[index] = updatedDepartment; // Cập nhật thông tin department
      }
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
      showLeadingAction: true,
      defaultBody: true,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      titletext: "Departments Management".tr(),
      bodyChildren: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            hintText: '',
            suggestions: departments.map((department) => department.departmentName!).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: Consumer<DeparmentsViewModel>(builder: (context, viewModel, child) {
            if (!viewModel.fetchingData && viewModel.listDepartments.isEmpty) {
              Provider.of<DeparmentsViewModel>(context, listen: false).fetchAllDepartments();
            }
            if (viewModel.fetchingData) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<Departments> departments = viewModel.listDepartments;
              return CustomListView(
                dataSet: departments,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(departments[index].departmentName.toString()),
                    trailing: Text(
                      departments[index].departmentID.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () async {
                      // Gọi màn hình thông tin phòng ban và chờ kết quả
                      final updatedDepartment = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepartmentInfoScreen(departments: departments[index]),
                        ),
                      );

                      // Kiểm tra xem có dữ liệu cập nhật không
                      if (updatedDepartment != null) {
                        _handleUpdate(updatedDepartment);
                      }
                    },
                  );
                },
              );
            }
          }),
        ),
      ],
      // Bạn có thể bỏ comment nếu muốn sử dụng Floating Action Button
      // fab: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddDepartmentScreen(onAdd: _handleAdd),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.blue,
      // ),
    );
  }
}
