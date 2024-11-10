import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_department_screen.dart';
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
  final _positionNameController = TextEditingController();
  final _positionIdController = TextEditingController();
  @override
  void initState() {
    Provider.of<DeparmentsViewModel>(context, listen: false)
        .fetchAllDepartments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        'icon': Icons.supervisor_account,
        'text': 'Danh sách nhân viên',
        'route': AppRoutes.employeeListRoute
      },
      {
        'icon': Icons.calendar_month_outlined,
        'text': 'relatives_add',
        'route': AppRoutes.relativesAddRoute
      },
      {
        'icon': Icons.calendar_month_outlined,
        'text': 'Nghỉ phép',
        'route': AppRoutes.leaveRequestList
      },
      {
        'icon': Icons.calendar_month_outlined,
        'text': 'list_relatives_managment',
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
                "Quản lí nhân sự",
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
                      childAspectRatio: 2,
                      dataSet: departments,
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
                        ).onTap(() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DepartmentInfoScreen(
                                departments: departments[index],
                              ),
                            )));
                      });
                }
              })
            ],
          ),
        ),
      ],
      fab: AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')
          ? SpeedDial(
              elevation: 0,
              icon: Icons.menu,
              buttonSize: Size(50, 50),
              children: [
                SpeedDialChild(
                    label: "Thêm nhân viên",
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.addprofileRoute);
                    }),
                SpeedDialChild(
                    label: "Thêm lương",
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.salariesAddRoute);
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
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                            controller:
                                                _departmentNameController,
                                            decoration: InputDecoration(
                                              labelText: 'Department Name',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter department name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final newDepartment = Departments(
                                                departmentID:
                                                    _departmentIdController
                                                        .text,
                                                departmentName:
                                                    _departmentNameController
                                                        .text,
                                              );
                                              context
                                                  .read<DeparmentsViewModel>()
                                                  .addNewDepartment(
                                                      newDepartment);

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
                SpeedDialChild(
                    label: "Thêm chức vụ",
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
                                            controller: _positionIdController,
                                            decoration: InputDecoration(
                                              labelText: 'Position ID',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                            controller: _positionNameController,
                                            decoration: InputDecoration(
                                              labelText: 'Position Name',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter department name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final newPositions = Positions(
                                                positionId:
                                                    _positionIdController.text,
                                                positionName:
                                                    _positionIdController.text,
                                              );
                                              Provider.of<PositionsViewModel>(
                                                      context)
                                                  .addNewPosition(newPositions);
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
            )
          : FloatingActionButton(
              child: Icon(Icons.add_reaction),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.addprofileRoute);
              }),
    );
  }
}
