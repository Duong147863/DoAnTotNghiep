import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_department_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentsScreen extends StatefulWidget {
  @override
  _DepartmentsScreenState createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  List<Departments> departments = [];

  @override
  void initState() {
    super.initState();
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
      showLeadingAction: true,
      defaultBody: true,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B258A),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Departments Management",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFEFF8FF),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
      bodyChildren: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            hintText: '',
            suggestions: departments
                .map(
                  (department) => department.departmentName!,
                )
                .toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(

          child: Consumer<DeparmentsViewModel>(
              builder: (context, viewModel, child) {
            if (!viewModel.fetchingData && viewModel.listDepartments.isEmpty) {
              Provider.of<DeparmentsViewModel>(context, listen: false)
                  .fetchAllDepartments();
            }
            if (viewModel.fetchingData) {
              // While data is being fetched
              return Center(child: CircularProgressIndicator());
            } else {
              // If data is successfully fetched
              List<Departments> departments = viewModel.listDepartments;
              return CustomListView(
                dataSet: departments,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(departments[index].departmentName.toString()),
                    leading: Text(departments[index].departmentID.toString()),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.departmentDetailRoute);
                    },
                  );
                },
              );
            }
          }),
        ),
      ],
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
