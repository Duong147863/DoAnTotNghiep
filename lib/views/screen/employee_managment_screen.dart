import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/leave_request_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _departmentNameController = TextEditingController();
  final _departmentIdController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        'icon': Icons.supervisor_account,
        'text': 'Danh sách nhân viên'.tr(),
        'route': AppRoutes.employeeListRoute
      },
      {
        'icon': Icons.calendar_month_outlined,
        'text': 'relatives_add'.tr(),
        'route': AppRoutes.relativesAddRoute
      },
      {
        'icon': Icons.calendar_month_outlined,
        'text': 'Nghỉ phép'.tr(),
        'route': AppRoutes.leaveRequestList
      },
      {
        'icon': Icons.calendar_month_outlined,
        'text': 'list_relatives_managment'.tr(),
        'route': AppRoutes.relativeListRoute
      },
    ];
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
                "Employee Management",
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<DeparmentsViewModel>(
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
                  return CustomGridView(
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      dataSet: data,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color.fromARGB(255, 243, 243, 242),
                          elevation: 1,
                          // margin: EdgeInsets.all(13),
                          child: Wrap(
                            clipBehavior: Clip.antiAlias,
                            direction: Axis.vertical,
                            children: [
                              Text(
                                departments[index].departmentName,
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ).p(13),
                        ).onTap(() => Navigator.of(context).pushNamed(''));
                      });
                }
              })
            ],
          ),
        ),
      ],
      fab: SpeedDial(
        elevation: 0,
        icon: Icons.menu,
        buttonSize: Size(50, 50),
        // direction: SpeedDialDirection.down,
        children: [
          SpeedDialChild(
              label: "Thêm nhân viên",
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.addprofileRoute);
              }),
          SpeedDialChild(
              label: "Thêm phòng ban",
              onTap: () => showDialog<Widget>(
                    context: context,
                    builder: (context) => Dialog(
                      child: Container(
                        height: 300,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Form(
                              key: _formKey,
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                      controller: _departmentIdController,
                                      decoration: InputDecoration(
                                        labelText: 'Department ID',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter department ID';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                      controller: _departmentNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Department Name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter department name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final newDepartment = Departments(
                                          departmentID:
                                              _departmentIdController.text,
                                          departmentName:
                                              _departmentNameController.text,
                                        );
                                        Provider.of<DeparmentsViewModel>(
                                                context)
                                            .addNewDepartment(newDepartment);
                                        Navigator.pop(context);
                                        initState();
                                      }
                                    },
                                    child: Text('Add Department'),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}
