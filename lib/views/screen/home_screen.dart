import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/employeeStatus.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/projects_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';
import 'package:nloffice_hrm/views/screen/add_assignment_screen.dart';
import 'package:nloffice_hrm/views/screen/add_labor_contract_screen.dart';
import 'package:nloffice_hrm/views/screen/add_shifts_screen.dart';
import 'package:nloffice_hrm/views/screen/add_task_screen.dart';
import 'package:nloffice_hrm/views/screen/add_trainingprocesses_screen.dart';
import 'package:nloffice_hrm/views/screen/add_workingprocess_screen.dart';
import 'package:nloffice_hrm/views/screen/change_password_screen.dart';
import 'package:nloffice_hrm/views/screen/info_department_screen.dart';
import 'package:nloffice_hrm/views/screen/info_project_screen.dart';
import 'package:nloffice_hrm/views/screen/list_absent_screen.dart';
import 'package:nloffice_hrm/views/screen/list_project_screen.dart';
import 'package:nloffice_hrm/views/screen/list_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/list_salary_screen.dart';
import 'package:nloffice_hrm/views/screen/list_shifts_screen.dart';
import 'package:nloffice_hrm/views/screen/list_trainingprocesses_screen.dart';
import 'package:nloffice_hrm/views/screen/list_workingprocess_screen.dart';
import 'package:nloffice_hrm/views/screen/profile_screen.dart';
import 'package:nloffice_hrm/views/screen/time_attendance_screen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/positions_model.dart';

class HomeScreen extends StatefulWidget {
  final Profiles? profile;
  const HomeScreen({
    super.key,
    this.profile,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _departmentNameController = TextEditingController();
  final _departmentIdController = TextEditingController();
  final _positionNameController = TextEditingController();
  final _positionIdController = TextEditingController();
  List<bool> isExpandedList = [];
  List<Projects> project = [];
  Projects? selectedProject;

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _loadData() async {
  //   try {
  //     await Provider.of<ProjectsViewModel>(context, listen: false)
  //         .getAllProject();
  //     await Provider.of<DeparmentsViewModel>(context, listen: false)
  //         .fetchAllDepartments();
  //     setState(() {
  //       project =
  //           Provider.of<ProjectsViewModel>(context, listen: false).listProjects;
  //       if (project.isNotEmpty) {
  //         selectedProject = project.firstWhere(
  //           (pro) => pro.projectId == widget.profile!.profileId,
  //         );
  //       }
  //     });
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to load salaries')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final profilesViewModel = Provider.of<ProfilesViewModel>(context);
    return BasePage(
      appBarItemColor: AppColor.boneWhite,
      showAppBar: true,
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Color(0xFF0B258A),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ProfileScreen(profile: widget.profile),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: widget
                                    .profile!.profileImage.isNotEmptyAndNotNull
                                ? Image.memory(
                                    base64Decode(widget.profile!.profileImage!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error,
                                          size: 30, color: Colors.grey);
                                    },
                                  )
                                : const Icon(Icons.person,
                                    size: 30, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.profile!.profileName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.profile!.positionId!.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(children: [
                AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')
                    ? ListTile(
                        title: const Text("Doanh nghiệp"),
                        onTap: () {},
                      )
                    : UiSpacer.emptySpace(),
                ListTile(
                  title: const Text("Nghỉ phép"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => ListAbsentScreen(
                                profiles: widget.profile,
                              )),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Lương"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => SalaryListScreen(
                          profiles: widget.profile,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Thân nhân nhân viên"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            RelativeListScreen(profiles: widget.profile),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Ca làm việc"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const ListShiftsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Danh sách dự án"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const ListProjectScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Hợp đồng lao động"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const AddLaborContractScreen(),
                      ),
                    );
                  },
                ),
              ]),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Đổi mật khẩu"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              ChangePasswordScreen(
                            profiles: widget.profile,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Đăng xuất'),
                    leading: const Icon(Icons.logout),
                    onTap: () {
                      profilesViewModel.logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.loginRoute, (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B258A),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Xin chào ${widget.profile!.profileName}",
                style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFEFF8FF),
                    fontWeight: FontWeight.w600),
              ),
            ).p(10),
          ],
        ),
      ),
      backgroundColor: AppColor.primaryLightColor,
      defaultBody: true,
      bodyChildren: [
        const SizedBox(height: 20),
        AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts') ||
                (DateTime.now().hour.toInt() >= 22 ||
                    DateTime.now().hour.toInt() <=
                        5) // Ẩn nút chấm công nếu ngoài giờ làm việc hoặc là ban giám đốc
            ? UiSpacer.emptySpace()
            : InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => TimeAttendance(
                        loginUser: widget.profile!,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 60.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B42F6), Color(0xFF1CA9F4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chấm công',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'để bắt đầu công việc thôi nào!',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        buildbodyChildren(),
        const SizedBox(height: 20),
      ],
      fab: buildFab(),
    );
  }

  Widget buildFab() {
    if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
      //Giám đốc
      return SpeedDial(
        elevation: 0,
        icon: Icons.menu,
        buttonSize: const Size(50, 50),
        children: [
          SpeedDialChild(
              label: "Thêm nhân viên",
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.addprofileRoute);
              }),
          SpeedDialChild(
              label: "Thêm quyết định",
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.decisionListRoute);
              }),
          SpeedDialChild(
              label: "Tạo phòng ban",
              onTap: () => showDialog<Widget>(
                    context: context,
                    builder: (context) => Dialog(
                      child: Container(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                              key: _formKey,
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                      controller: _departmentIdController,
                                      decoration: const InputDecoration(
                                        labelText: 'Mã phòng ban',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập mã phòng';
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
                                      decoration: const InputDecoration(
                                        labelText: 'Tên phòng ban',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập tên phòng';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        Departments newDepartment = Departments(
                                          departmentID:
                                              _departmentIdController.text,
                                          departmentName:
                                              _departmentNameController.text,
                                        );
                                        // context
                                        //     .read<DeparmentsViewModel>()
                                        //     .addNewDepartment(newDepartment);
                                        Provider.of<DeparmentsViewModel>(
                                                context,
                                                listen: false)
                                            .addNewDepartment(newDepartment);
                                        Navigator.pop(context);
                                        initState();
                                      }
                                    },
                                    child: const Text('Thêm'),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                              key: _formKey,
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                      controller: _positionIdController,
                                      decoration: const InputDecoration(
                                        labelText: 'Mã chức vụ',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập department ID';
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
                                      decoration: const InputDecoration(
                                        labelText: 'Position Name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập department name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final newPositions = Positions(
                                          positionId:
                                              _positionIdController.text,
                                          positionName:
                                              _positionIdController.text,
                                        );
                                        Provider.of<PositionsViewModel>(context)
                                            .addNewPosition(newPositions);
                                        Navigator.pop(context);
                                        initState();
                                      }
                                    },
                                    child: const Text('Add Department'),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  )),
          SpeedDialChild(
              label: "Thêm ca làm việc",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const AddShiftsScreen(),
                  ),
                );
              }),
        ],
      );
    } else if (AppStrings.ROLE_PERMISSIONS
        .contains('Manage Staffs info only')) {
      // HR
      return SpeedDial(
          elevation: 0,
          icon: Icons.menu,
          buttonSize: const Size(50, 50),
          children: [
            SpeedDialChild(
                label: "Thêm Nhân Viên",
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.addprofileRoute);
                }),
            SpeedDialChild(
                label: "Thêm ca làm việc",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const AddShiftsScreen(),
                      ));
                }),
            SpeedDialChild(
                label: "Thân Nhân",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => RelativeListScreen(
                          profiles: widget.profile,
                        ),
                      ));
                }),
          ]);
    } else if (AppStrings.ROLE_PERMISSIONS.contains('Assign Project')) {
      return SpeedDial(
          elevation: 0,
          icon: Icons.menu,
          buttonSize: const Size(50, 50),
          children: [
            SpeedDialChild(
                label: "Task mới",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AddTaskScreen(),
                      ));
                }),
            SpeedDialChild(
                label: "Phân công dự án",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            AddAssignmentScreen(),
                      ));
                }),
          ]);
    } else if (AppStrings.ROLE_PERMISSIONS
        .contains('Create & Delete Project')) {
      final formKey = GlobalKey<FormState>();
      final projectIdController = TextEditingController();
      final projectNameController = TextEditingController();

      return SpeedDial(
        elevation: 0,
        icon: Icons.menu,
        buttonSize: const Size(50, 50),
        children: [
          SpeedDialChild(
            label: "Thêm dự án",
            onTap: () => showDialog<Widget>(
              context: context,
              builder: (context) => Dialog(
                child: Container(
                  height: 300,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                        key: formKey,
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: projectIdController,
                                decoration: InputDecoration(
                                  labelText: 'Mã dự án',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter project ID';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: projectNameController,
                                decoration: InputDecoration(
                                  labelText: 'Tên dự án',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter project name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  final newProject = Projects(
                                    projectId: projectIdController.text,
                                    projectName: projectNameController.text,
                                  );
                                  Provider.of<ProjectsViewModel>(context,
                                          listen: false)
                                      .addNewProject(newProject);
                                  Navigator.pop(context);
                                  initState();
                                }
                              },
                              child: Text('Tạo'),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
          SpeedDialChild(
              label: "Phân công dự án",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const AddAssignmentScreen(),
                    ));
              }),
        ],
      );
    } else {
      return UiSpacer.emptySpace();
    }
  }

  Widget buildbodyChildren() {
    if (AppStrings.ROLE_PERMISSIONS
        .containsAny(['Manage BoD & HR accounts', 'Manage Staffs info only'])) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<DeparmentsViewModel>(builder: (context, viewModel, child) {
              if (!viewModel.fetchingData &&
                  viewModel.listDepartments.isEmpty) {
                Provider.of<DeparmentsViewModel>(context, listen: false)
                    .fetchAllDepartments();
              }
              if (viewModel.fetchingData) {
                // While data is being fetched
                return const Center(child: CircularProgressIndicator());
              } else {
                // If data is successfully fetched
                List<Departments> departments = viewModel.listDepartments;
                return CustomGridView(
                    childAspectRatio: 2,
                    dataSet: departments,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 243, 243, 242),
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
            }),
            const Divider().p12(),
            _buildEmployeeStats()
            // ExpansionPanelList(
            //   expansionCallback: (int panelIndex, bool isExpanded) {
            //     setState(() {
            //       isExpandedList[panelIndex] = isExpanded;
            //     });
            //   },
            //   children: [
            //     ExpansionPanel(
            //       headerBuilder: (BuildContext context, bool isExpanded) {
            //         return const Text("Nhân sự công ty");
            //       },
            //       isExpanded: true,
            //       body: Consumer<ProfilesViewModel>(
            //           builder: (context, viewModel, child) {
            //         if (!viewModel.fetchingData &&
            //             viewModel.allProfiles.isEmpty) {
            //           Provider.of<ProfilesViewModel>(context, listen: false)
            //               .fetchAllProfiles();
            //         }
            //         List<Profiles> listProfiles = viewModel.allProfiles;
            //         return CustomListView(
            //             dataSet: listProfiles,
            //             itemBuilder: (context, index) {
            //               return ListTile(
            //                 leading: const CircleAvatar(),
            //                 title: Text(listProfiles[index].profileName),
            //                 subtitle: Text(listProfiles[index].positionId!),
            //               );
            //             });
            //       }),
            //     ),
            //   ],
            // ).p8()
          ],
        ),
      );
    } else if (AppStrings.ROLE_PERMISSIONS.contains('Assign Project')) {
      {
        return Column(
          children: [
            const Text("Lương của bạn",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )).p8(),
            const Divider().px12(),
            const Text("Công việc của bạn",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )).p8(),
            Divider().px12(),
            // ExpansionPanelList(
            //   expansionCallback: (int panelIndex, bool isExpanded) {
            //     setState(() {
            //       isExpandedList[panelIndex] = isExpanded;
            //     });
            //   },
            //   children: [
            //     ExpansionPanel(
            //       headerBuilder: (BuildContext context, bool isExpanded) {
            //         return const Row(
            //           children: [
            //             // Text("Mã dự án - Tên dự án"),
            //           ],
            //         );
            //       },
            //       body: Card(),
            //     ),
            //   ],
            // ).p8(),
             Consumer<ProjectsViewModel>(builder: (context, viewModel, child) {
              if (!viewModel.fetchingData &&
                  viewModel.listProjects.isEmpty) {
                Provider.of<ProjectsViewModel>(context, listen: false)
                    .getAllProject();
              }
              if (viewModel.fetchingData) {
                // While data is being fetched
                return const Center(child: CircularProgressIndicator());
              } else {
                // If data is successfully fetched
                List<Projects> projects = viewModel.listProjects;
                return CustomGridView(
                    childAspectRatio: 2,
                    dataSet: projects,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 243, 243, 242),
                        elevation: 1,
                        // margin: EdgeInsets.all(13),
                        child: Wrap(
                          clipBehavior: Clip.antiAlias,
                          direction: Axis.vertical,
                          children: [
                            Text(
                              projects[index].projectName,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ).p(13),
                      ).onTap(() => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoProjectScreen(
                              projects: projects[index],
                            ),
                          )));
                    });
              }
            }),
            
          ],
        );
      }
    } else {
      return UiSpacer.emptySpace();
    }
  }
  }

  Widget _buildEmployeeStats() {
    return Consumer<ProfilesViewModel>(
  builder: (context, viewModel, child) {
    if (!viewModel.fetchingData) {
      viewModel.fetchQuitAndActiveMembersCount();
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCircularChart(
        title: ChartTitle(text: 'Thống kê nhân viên'),  // Tiêu đề cho biểu đồ
        legend: Legend(isVisible: true, position: LegendPosition.bottom),  // Hiển thị legend ở dưới
        series: <CircularSeries<EmployeeStat, String>>[
          PieSeries<EmployeeStat, String>(
            dataSource: [
              EmployeeStat('Đang làm việc', viewModel.activeCount),
              EmployeeStat('Đã nghỉ việc', viewModel.quitCount),
            ],
            xValueMapper: (EmployeeStat stats, _) => stats.status,
            yValueMapper: (EmployeeStat stats, _) => stats.count,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,  // Đặt nhãn ra ngoài
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),  // Cải thiện kiểu nhãn
            ),
            pointColorMapper: (EmployeeStat stats, _) {
              // Thay đổi màu sắc của từng phần trong biểu đồ
              if (stats.status == 'Đang làm việc') {
                return Colors.blue;
              } else {
                return Colors.red;
              }
            },
            explode: true,  // Tạo hiệu ứng khi nhấn vào một phần trong biểu đồ
            explodeIndex: 0,  // Tạo hiệu ứng phóng to phần "Đang làm việc"
            explodeOffset: "10%",  // Điều chỉnh độ phóng to của phần explode
            radius: '70%',  // Đặt kích thước biểu đồ tròn
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),  // Hiển thị tooltip khi hover qua phần tử
      ),
    );
  },
);
  }