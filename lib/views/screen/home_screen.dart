import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';
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
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';
import 'package:nloffice_hrm/views/screen/add_absent_request_screen.dart';
import 'package:nloffice_hrm/views/screen/add_assignment_screen.dart';
import 'package:nloffice_hrm/views/screen/add_labor_contract_screen.dart';
import 'package:nloffice_hrm/views/screen/add_salary_screen.dart';
import 'package:nloffice_hrm/views/screen/add_shifts_screen.dart';
import 'package:nloffice_hrm/views/screen/add_task_screen.dart';
import 'package:nloffice_hrm/views/screen/change_password_screen.dart';
import 'package:nloffice_hrm/views/screen/info_department_screen.dart';
import 'package:nloffice_hrm/views/screen/info_enterprises_screen.dart';
import 'package:nloffice_hrm/views/screen/list_absent_screen.dart';
import 'package:nloffice_hrm/views/screen/list_hirings_screen.dart';
import 'package:nloffice_hrm/views/screen/list_project_screen.dart';
import 'package:nloffice_hrm/views/screen/list_salary_screen.dart';
import 'package:nloffice_hrm/views/screen/list_shifts_screen.dart';
import 'package:nloffice_hrm/views/screen/profile_screen.dart';
import 'package:nloffice_hrm/views/screen/time_attend_table.dart';
import 'package:nloffice_hrm/views/screen/time_attendance_screen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../models/positions_model.dart';
import '../../models/timekeepings_model.dart';

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
  late Profiles _profile; // Tạo biến để quản lý profile trong state
  final _formKey = GlobalKey<FormState>();
  final _departmentNameController = TextEditingController();
  final _departmentIdController = TextEditingController();
  final _positionNameController = TextEditingController();
  final _positionIdController = TextEditingController();
  List<bool> isExpandedList = [];
  List<Projects> project = [];
  Projects? selectedProject;
  FocusNode _maPBFocusNode = FocusNode();
  FocusNode _tenPBFocusNode = FocusNode();
  FocusNode _maCVFocusNode = FocusNode();
  FocusNode _tenCVFocusNode = FocusNode();
  late TabController _controller;
  List<Departments> departments = [];
  Departments? selectedDepartment;
  List<Profiles> profile = [];
  DateTime now = DateTime.now();
  // Lấy ngày đầu và cuối tuần này
  DateTime startOfWeek = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - 1)); // Thứ 2
  DateTime endOfWeek = DateTime.now()
      .add(Duration(days: 7 - DateTime.now().weekday)); // Chủ nhật
  // Lấy ngày đầu và cuối tháng này
  DateTime startOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
          .subtract(Duration(days: 1));
  // Format ngày nếu cần
  String formatDatetoJson(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);
  String formatDatetoUI(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  @override
  void initState() {
    super.initState();
    _loadDepartments();
    _profile = widget.profile!;
    _maPBFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_maPBFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _tenPBFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_tenPBFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _maCVFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_maCVFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _tenCVFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_tenCVFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
     
    Provider.of<TimeKeepingViewModel>(context, listen: false)
        .getProfileCheckInHistory(formatDatetoJson(startOfWeek),
            formatDatetoJson(endOfWeek), widget.profile!.profileId);
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  void _loadDepartments() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .fetchAllDepartments();
      departments = Provider.of<DeparmentsViewModel>(context, listen: false)
          .listDepartments;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load departments')),
      );
    }
  }

  // Hàm chuyển sang tuần trước
  void _previousWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(Duration(days: 7));
      endOfWeek = endOfWeek.subtract(Duration(days: 7));
      Provider.of<TimeKeepingViewModel>(context, listen: false)
          .getProfileCheckInHistory(formatDatetoJson(startOfWeek),
              formatDatetoJson(endOfWeek), widget.profile!.profileId);
      Provider.of<TimeKeepingViewModel>(context, listen: false)
          .getProfileCheckInHistory(formatDatetoJson(startOfWeek),
              formatDatetoJson(endOfWeek), widget.profile!.profileId);
    });
  }

  // Hàm chuyển sang tuần tiếp theo
  void _nextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(Duration(days: 7));
      endOfWeek = endOfWeek.add(Duration(days: 7));
      Provider.of<TimeKeepingViewModel>(context, listen: false)
          .getProfileCheckInHistory(formatDatetoJson(startOfWeek),
              formatDatetoJson(endOfWeek), widget.profile!.profileId);
      Provider.of<TimeKeepingViewModel>(context, listen: false)
          .getProfileCheckInHistory(formatDatetoJson(startOfWeek),
              formatDatetoJson(endOfWeek), widget.profile!.profileId);
    });
  }

  //   void _handleUpdateProfile(Profiles updatedProfile) {
  //   setState(() {
  //     int index = profile
  //         .indexWhere((pro) => pro.profileId == updatedProfile.profileId);
  //     if (index != -1) {
  //       profile[index] = updatedProfile;
  //     }
  //   });
  // }
  void _handleUpdateProfile(Profiles updatedProfile) {
    setState(() {
      _profile = updatedProfile; // Cập nhật Profile trong state
    });
  }

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
                      onTap: () async {
                        final updatedProfile = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              profile: widget.profile,
                              loginUser: widget
                                  .profile, // lấy thông tin TK đang đăng nhập
                            ),
                          ),
                          // )
                          // .then((updatedProfile) {
                          //   if (updatedProfile != null) {
                          //     _handleUpdateProfile(
                          //         updatedProfile); // Cập nhật lại thông tin
                          //   }
                          // }
                        );
                        if (updatedProfile != null) {
                          _handleUpdateProfile(
                              updatedProfile); // Cập nhật lại dữ liệu
                        }
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
                      _profile.profileName,
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
              child: ListView(
                  children: AppStrings.ROLE_PERMISSIONS
                          .contains('Manage BoD & HR accounts')
                      ? <Widget>[
                          ListTile(
                            title: const Text("Doanh nghiệp của bạn"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          InfoEnterpriseScreen()));
                            },
                          ),
                          ListTile(
                            title: const Text("Chấm công"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        TimeAttendanceTable()),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text("Nghỉ phép"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        ListAbsentScreen(
                                          profiles: widget.profile,
                                        )),
                              );
                            },
                          ),
                          // ListTile(
                          //   title: const Text("Lương"),
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute<void>(
                          //         builder: (BuildContext context) =>
                          //             SalaryListScreen(
                          //           profiles: widget.profile,
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // ListTile(
                          //   title: const Text("Thân nhân nhân viên"),
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute<void>(
                          //         builder: (BuildContext context) =>
                          //             RelativeListScreen(
                          //                 profiles: widget.profile),
                          //       ),
                          //     );
                          //   },
                          // ),
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
                            title: const Text("Tuyển dụng"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const ListHiringsScreen(),
                                ),
                              );
                            },
                          ),
                          // ListTile(
                          //   title: const Text("Dự án"),
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute<void>(
                          //         builder: (BuildContext context) =>
                          //             const ListProjectScreen(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // ListTile(
                          //   title: const Text("Hợp đồng lao động"),
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute<void>(
                          //         builder: (BuildContext context) =>
                          //             const Placeholder(),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ]
                      : AppStrings.ROLE_PERMISSIONS
                              .contains('Manage Staffs info only')
                          ? [
                              ListTile(
                                title: const Text("Nghỉ phép"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            ListAbsentScreen(
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
                                      builder: (BuildContext context) =>
                                          SalaryListScreen(
                                        profiles: widget.profile,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // ListTile(
                              //   title: const Text("Thân nhân nhân viên"),
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute<void>(
                              //         builder: (BuildContext context) =>
                              //             RelativeListScreen(
                              //                 profiles: widget.profile),
                              //       ),
                              //     );
                              //   },
                              // ),
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
                                title: const Text("Tuyển dụng"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const ListHiringsScreen(),
                                    ),
                                  );
                                },
                              ),
                              // ListTile(
                              //   title: const Text("Hợp đồng lao động"),
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute<void>(
                              //         builder: (BuildContext context) =>
                              //             const AddLaborContractScreen(),
                              //       ),
                              //     );
                              //   },
                              // ),
                            ]
                          : [
                              SizedBox.shrink(),
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
        iconTheme: IconThemeData(color: Colors.white),
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
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute<void>(
          //           builder: (BuildContext context) => NotificationScreen(),
          //         ),
          //       );
          //     },
          //     icon: Icon(Icons.notifications_none))
        ],
      ),
      backgroundColor: AppColor.primaryLightColor,
      defaultBody: true,
      bodyChildren: [
        const SizedBox(height: 20),
        AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts') ||
                (now.hour.toInt() >= 22 ||
                    now.hour.toInt() <
                        7) // Ẩn nút chấm công nếu ngoài giờ làm việc hoặc là ban giám đốc
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
      ],
      fab: buildFab(),
    );
  }

  Widget buildFab() {
    if (AppStrings.ROLE_PERMISSIONS
        .contains('Manage BoD & HR accounts')) //Giám đốc
    {
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
                                      maxLength: 15,
                                      focusNode: _maPBFocusNode,
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
                                          return 'Vui lòng nhập mã phòng ban';
                                        } else if (value.trim() != value) {
                                          return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                                        } else if (value.length > 15) {
                                          return 'Mã phòng ban không được vượt quá 15 ký tự';
                                        } else if (!value.startsWith('PB-')) {
                                          return 'Mã phòng ban phải bắt đầu bằng "PB-"';
                                        } else if (!RegExp(r'^PB-[A-Z]+$')
                                            .hasMatch(value)) {
                                          return 'Sau "PB-" phải chữ viết hoa ';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                      focusNode: _tenPBFocusNode,
                                      maxLength: 50,
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
                                        if (value.length < 4) {
                                          return 'Tên phòng ban phải có ít nhất 4 ký tự';
                                        }
                                        final nameRegex = RegExp(
                                            r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                                        if (!nameRegex.hasMatch(value)) {
                                          return 'Tên phòng ban không được chứa chữ số và ký tự đặc biệt';
                                        }
                                        if (!value.isLetter()) {
                                          return 'Tên phòng ban chỉ gồm chữ';
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
                                        Provider.of<DeparmentsViewModel>(
                                                context,
                                                listen: false)
                                            .addNewDepartment(newDepartment);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Thêm phòng ban thành công')),
                                        );
                                        Navigator.pop(context);
                                        _departmentIdController.clear();
                                        _departmentNameController.clear();
                                        initState();
                                      }
                                    },
                                    child: const Text('Tạo phòng ban'),
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
                        width: double.infinity,
                        height: 400,
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
                                      maxLength: 15,
                                      focusNode: _maCVFocusNode,
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
                                          return 'Vui lòng nhập mã chức vụ';
                                        } else if (value.trim() != value) {
                                          return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                                        } else if (value.length > 15) {
                                          return 'Mã chức vụ không được vượt quá 15 ký tự';
                                        } else if (!value.startsWith('CV-')) {
                                          return 'Mã chức vụ phải bắt đầu bằng "CV-"';
                                        } else if (!RegExp(r'^CV-[A-Z]+$')
                                            .hasMatch(value)) {
                                          return 'Sau "CV-" phải chữ viết hoa ';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: TextFormField(
                                      focusNode: _tenCVFocusNode,
                                      controller: _positionNameController,
                                      maxLength: 50,
                                      decoration: const InputDecoration(
                                        labelText: 'Tên chức vụ',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Vui lòng nhập tên phòng';
                                        }
                                        if (value.length < 4) {
                                          return 'Tên chức vụ phải có ít nhất 4 ký tự';
                                        }
                                        final nameRegex = RegExp(
                                            r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                                        if (!nameRegex.hasMatch(value)) {
                                          return 'Tên chức vụ không được chứa chữ số và ký tự đặc biệt';
                                        }
                                        if (!value.isLetter()) {
                                          return 'Tên chức vụ chỉ gồm chữ';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      _buildDepartmentDropdown('Chọn phòng ban')
                                          .p(8)
                                          .w(299),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final newPositions = Positions(
                                          departmentId:
                                              selectedDepartment!.departmentID,
                                          positionId:
                                              _positionIdController.text,
                                          positionName:
                                              _positionNameController.text,
                                        );
                                        Provider.of<PositionsViewModel>(context,
                                                listen: false)
                                            .addNewPosition(newPositions);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Thêm chức vụ thành công')),
                                        );
                                        Navigator.pop(context);
                                        _positionIdController.clear();
                                        _positionNameController.clear();
                                        initState();
                                      }
                                    },
                                    child: const Text('Thêm chức vụ'),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  )),
          // SpeedDialChild(
          //     label: "Thêm mức lương",
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute<void>(
          //             builder: (BuildContext context) => SalaryAddScreen(),
          //           ));
          //     }),
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
                label: "Thêm nghỉ phép",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            AddAbsentRequestScreen(
                          profiles: widget.profile,
                        ),
                      ));
                }),
            // SpeedDialChild(
            //     label: "Thân Nhân",
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute<void>(
            //             builder: (BuildContext context) => RelativeListScreen(
            //               profiles: widget.profile,
            //             ),
            //           ));
            //     }),
          ]);
    } else {
      return SpeedDial(
          elevation: 0,
          icon: Icons.menu,
          buttonSize: const Size(50, 50),
          children: [
            SpeedDialChild(
                label: "Thêm nghỉ phép",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            AddAbsentRequestScreen(
                          profiles: widget.profile,
                        ),
                      ));
                })
          ]);
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
            Center(
              child: Text(
                "DANH SÁCH PHÒNG BAN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Divider(),
            Consumer<DeparmentsViewModel>(builder: (context, viewModel, child) {
              if (!viewModel.fetchingData &&
                  viewModel.listDepartments.isEmpty) {
                Provider.of<DeparmentsViewModel>(context, listen: false)
                    .fetchAllDepartments();
              }
              if (viewModel.fetchingData) {
                // Hiển thị khi dữ liệu đang được tải
                return const Center(child: CircularProgressIndicator());
              } else {
                // Dữ liệu đã tải thành công
                List<Departments> departments = viewModel.listDepartments;
                // Lọc danh sách dựa trên quyền
                if (AppStrings.ROLE_PERMISSIONS
                    .contains('Manage BoD & HR accounts')) {
                  // Hiển thị toàn bộ phòng ban
                } else if (AppStrings.ROLE_PERMISSIONS
                    .contains('Manage Staffs info only')) {
                  // Loại bỏ phòng ban với ID là 'PB-GĐ'
                  departments = departments
                      .where((department) => department.departmentID != 'PB-GĐ')
                      .toList();
                }
                return CustomGridView(
                  childAspectRatio: 2,
                  dataSet: departments,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color.fromARGB(255, 243, 243, 242),
                      elevation: 1,
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
                              profiles: widget.profile,
                            ),
                          ),
                        ));
                  },
                );
              }
            }),
            const Divider(),
            _buildEmployeeStats(),
            _buildGetMembersCountGenderAndMaritalStatus(),

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
    } else {
      //GIAO DIỆN NHÂN VIÊN
      //Biểu đồ số giờ làm việc tuần này
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Consumer<TimeKeepingViewModel>(
                builder: (context, viewModel, child) {
              Provider.of<TimeKeepingViewModel>(context, listen: false)
                  .fetchWorkHours(formatDatetoJson(startOfWeek),
                      formatDatetoJson(endOfWeek), widget.profile!.profileId);
              final weekData = viewModel.weekData.entries.toList();
              return SfCartesianChart(
                title: const ChartTitle(text: 'Thống kê số giờ làm việc'),
                primaryXAxis: const CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: const NumericAxis(
                  maximum: 12,
                  interval: 2,
                ),
                series: <CartesianSeries<dynamic, dynamic>>[
                  ColumnSeries<MapEntry<String, int>, String>(
                    dataSource: weekData,
                    xValueMapper: (data, _) => data.key,
                    yValueMapper: (data, _) => data.value,
                  ),
                ],
              );
            }),
            Divider().py8(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back_rounded).onInkTap(_previousWeek),
                Text("Tuần ${formatDatetoUI(startOfWeek)} - ${formatDatetoUI(endOfWeek)}")
                    .px32(),
                const Icon(Icons.arrow_forward_rounded).onInkTap(_nextWeek),
              ],
            ).py4(),
            Consumer<TimeKeepingViewModel>(
                builder: (context, viewModel, child) {
              //Lịch sử chấm công cá nhân nhân viên
              if (!viewModel.fetchingData && viewModel.list1.isEmpty) {
                Provider.of<TimeKeepingViewModel>(context, listen: false)
                    .getProfileCheckInHistory(formatDatetoJson(startOfWeek),
                        formatDatetoJson(endOfWeek), widget.profile!.profileId);
              }
              if (viewModel.fetchingData) {
                if (viewModel.list1.isEmpty) {
                  return Center(
                      child: Column(
                    children: [
                      const Text(
                        "Chưa có dữ liệu",
                        style: TextStyle(fontSize: 16),
                      ).py16(),
                      Image.asset("assets/images/no_data.png"),
                    ],
                  ));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                List<Timekeepings> listAttendances = viewModel.list1;
                return CustomListView(
                    dataSet: listAttendances,
                    itemBuilder: (context, index) {
                      return Card(
                        color: listAttendances[index].checkout == null
                            ? Colors.red
                            : Colors.greenAccent,
                        child: Column(
                          children: [
                            Text(
                                "Ca: ${listAttendances[index].shiftId} - ${formatDatetoUI(listAttendances[index].date)} "),
                            Text(
                                "Vào: ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(listAttendances[index].checkin))} - ${listAttendances[index].checkout?.hour ?? "00"}:${listAttendances[index].checkout?.minute ?? "00"} PM"),
                            Text(
                                "Trễ: ${listAttendances[index].late?.hour ?? "0"}h${listAttendances[index].late?.minute.toInt() ?? "0"}p"),
                          ],
                        ),
                      );
                    });
              }
            })
          ],
        ),
      );
    }
  }

  Widget _buildEmployeeStats() {
    return Consumer<ProfilesViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.fetchingEmployeeStats &&
            viewModel.activeCount == 0 &&
            viewModel.quitCount == 0) {
          viewModel.fetchQuitAndActiveMembersCount();
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Biểu đồ hình tròn
              Container(
                color: Colors
                    .transparent, // Đảm bảo không có màu nền không mong muốn
                child: SfCircularChart(
                  title: ChartTitle(
                      text: 'Thống kê nhân viên'), // Tiêu đề cho biểu đồ
                  series: <CircularSeries<EmployeeStat, String>>[
                    DoughnutSeries<EmployeeStat, String>(
                      dataSource: [
                        EmployeeStat('Đang làm việc', viewModel.activeCount),
                        EmployeeStat('Đã nghỉ việc', viewModel.quitCount),
                        EmployeeStat(
                            'Chính thức', viewModel.officialContractsCount),
                        EmployeeStat(
                            'Thời hạn', viewModel.temporaryContractsCount),
                      ],
                      xValueMapper: (EmployeeStat stats, _) => stats.status,
                      yValueMapper: (EmployeeStat stats, _) => stats.count,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true, // Hiển thị nhãn dữ liệu
                        labelPosition: ChartDataLabelPosition
                            .inside, // Hiển thị nhãn bên trong vùng màu
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Màu chữ tương phản để dễ đọc
                        ),
                      ),
                      dataLabelMapper: (EmployeeStat stats, _) =>
                          '${stats.count}',
                      pointColorMapper: (EmployeeStat stats, _) {
                        if (stats.status == 'Đang làm việc') {
                          return Colors.blue;
                        } else if (stats.status == 'Đã nghỉ việc') {
                          return Colors.red;
                        } else if (stats.status == 'Chính thức') {
                          return Colors.green;
                        } else if (stats.status == 'Thời hạn') {
                          return Colors.orange;
                        } else {
                          return Colors.grey;
                        }
                      },
                      explode: false, // Bỏ hiệu ứng tách ra
                      radius: '70%', // Kích thước của vòng tròn
                      innerRadius:
                          '50%', // Vùng rỗng bên trong để tạo hình Doughnut
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(
                      enable: true), // Hiển thị tooltip khi hover qua phần tử
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text('Đang làm việc: ${viewModel.activeCount}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('Đã nghỉ việc: ${viewModel.quitCount}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8),
                        Text('Chính thức: ${viewModel.officialContractsCount}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 8),
                        Text('Thời hạn: ${viewModel.temporaryContractsCount}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGetMembersCountGenderAndMaritalStatus() {
    return Consumer<ProfilesViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.fetchingGenderStats &&
            viewModel.genderMan == 0 &&
            viewModel.genderWoman == 0 &&
            viewModel.married == 0 &&
            viewModel.unmarried == 0) {
          viewModel.getMembersCountGenderAndMaritalStatus();
        }
        return viewModel.fetchingGenderStats
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    majorGridLines: MajorGridLines(width: 0),
                  ),
                  title: const ChartTitle(
                      text: 'Thống kê giới tính và tình trạng hôn nhân'),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<dynamic, dynamic>>[
                    ColumnSeries<dynamic, dynamic>(
                      dataSource: [
                        EmployeeStat('Nam', viewModel.genderMan!),
                        EmployeeStat('Nữ', viewModel.genderWoman!),
                        EmployeeStat('Đã kết hôn', viewModel.married!),
                        EmployeeStat('Chưa kết hôn', viewModel.unmarried!),
                      ],
                      xValueMapper: (dynamic stats, _) => stats.status,
                      yValueMapper: (dynamic stats, _) => stats.count,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      pointColorMapper: (dynamic stats, _) {
                        switch (stats.status) {
                          case 'Nam':
                            return Colors.blue;
                          case 'Nữ':
                            return Colors.pink;
                          case 'Đã kết hôn':
                            return Colors.green;
                          case 'Chưa kết hôn':
                            return Colors.orange;
                          default:
                            return Colors.grey;
                        }
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _buildDepartmentDropdown(String hint) {
    return DropdownButtonFormField<Departments>(
      value: selectedDepartment,
      hint: Text(hint),
      onChanged: (Departments? newValue) {
        setState(() {
          selectedDepartment = newValue;
        });
      },
      items: departments.map((Departments department) {
        return DropdownMenuItem<Departments>(
          value: department,
          child: Text(department
              .departmentName), // assuming department has a `name` field
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
