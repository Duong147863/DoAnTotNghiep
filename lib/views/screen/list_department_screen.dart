import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_department_screen.dart';
import 'package:nloffice_hrm/views/screen/info_department_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import '../custom_widgets/custom_card.dart';

class DepartmentsScreen extends StatefulWidget {
  @override
  _DepartmentsScreenState createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  List<Departments> departments = [];

  @override
  void initState() {
    super.initState();
    Provider.of<DeparmentsViewModel>(context, listen: false)
        .fetchAllDepartments();
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
        titletext: "Departments Management".tr(),
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
              if (!viewModel.fetchingData &&
                  viewModel.listDepartments.isEmpty) {
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
                    return CustomCard(
                        title:
                            "${departments[index].departmentID} - ${departments[index].departmentName}",
                        subttile: "Số lượng thành viên:",
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DepartmentInfoScreen(
                                  departments: departments[index],
                                ),
                              ));
                        }));
                  },
                );
              }
            }),
          ),
        ],
        fab: SpeedDial());
  }
}
