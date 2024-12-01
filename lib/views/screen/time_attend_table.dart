import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/displayvideo/v2.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/roles_model.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/view_models/roles_view_models.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_absent_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class TimeAttendanceTable extends StatefulWidget {
  Profiles? profiles;

  TimeAttendanceTable({super.key, this.profiles});

  @override
  State<TimeAttendanceTable> createState() => _TimeAttendanceTableState();
}

class _TimeAttendanceTableState extends State<TimeAttendanceTable> {
  List<Timekeepings> absents = [];
  List<Timekeepings> filteredAbsents = [];
  List<Roles> roles = [];
  Roles? selectedRoles;

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

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAbsents = absents; // Show all absents if query is empty
      } else {
        filteredAbsents = absents;
      }
    });
  }

  void _handleUpdate(Timekeepings updatedAbsent) {
    setState(() {
      int index = absents.indexWhere(
          (abs) => abs.timekeepingId == updatedAbsent.timekeepingId);
      if (index != -1) {
        absents[index] = updatedAbsent;
      }
    });
  }

  void _loadRoles() async {
    try {
      await Provider.of<RolesViewModels>(context, listen: false).getAllRoles();
      List<Roles> allRoles =
          Provider.of<RolesViewModels>(context, listen: false).listRoles;
      if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
        roles = allRoles
            .where((role) => [1, 2, 3, 4, 5].contains(role.roleID))
            .toList();
      } else if (AppStrings.ROLE_PERMISSIONS
          .contains('Manage Staffs info only')) {
        roles = allRoles
            .where((role) => [1, 2, 3, 4].contains(role.roleID))
            .toList();
      } else {
        roles = [];
      }

      setState(() {
        if (roles.isNotEmpty) {
          selectedRoles = roles.firstWhere(
            (rol) => rol.roleID == widget.profiles!.roleID,
          );
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Roles $error')),
      );
    }
  }

  // Hàm chuyển sang tuần trước
  void _previousWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(Duration(days: 7));
      endOfWeek = endOfWeek.subtract(Duration(days: 7));
      Provider.of<TimeKeepingViewModel>(context, listen: false)
          .getLateEmployees(
              formatDatetoJson(startOfWeek), formatDatetoJson(endOfWeek));
    });
  }

  // Hàm chuyển sang tuần tiếp theo
  void _nextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(Duration(days: 7));
      endOfWeek = endOfWeek.add(Duration(days: 7));
      Provider.of<TimeKeepingViewModel>(context, listen: false)
          .getLateEmployees(
              formatDatetoJson(startOfWeek), formatDatetoJson(endOfWeek));
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
      appBarColor: AppColor.primaryLightColor,
      titletext: "Quản lí chấm công",
      bodyChildren: [
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back_rounded)
                        .onInkTap(_previousWeek),
                    Text("Tuần ${formatDatetoUI(startOfWeek)} - ${formatDatetoUI(endOfWeek)}")
                        .px32(),
                    const Icon(Icons.arrow_forward_rounded).onInkTap(_nextWeek),
                  ],
                ).p12(),
                // TabBar
                TabBar(
                  // indicatorColor: AppColor.primaryColor,
                  // labelColor: Colors.white,
                  // unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: "Đang làm việc"),
                    Tab(text: "Đi trễ"),
                    Tab(text: "Tăng ca"),
                  ],
                ),
                // TabBarView
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [],
                      ),
                      //DANH SÁCH ĐI TRỄ
                      Column(
                        children: [
                          Consumer<TimeKeepingViewModel>(
                            builder: (context, viewModel, child) {
                              // Tải dữ liệu nếu cần
                              if (!viewModel.fetchingData &&
                                  viewModel.listLate.isEmpty) {
                                Provider.of<TimeKeepingViewModel>(context,
                                        listen: false)
                                    .getLateEmployees(
                                        formatDatetoJson(startOfWeek),
                                        formatDatetoJson(endOfWeek));
                              }
                              // Hiển thị trạng thái đang tải
                              if (viewModel.fetchingData) {
                                if (viewModel.listLate.isEmpty) {
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
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              } else {
                                // Danh sách các nhân viên đi trễ
                                List<Timekeepings> listLate =
                                    viewModel.listLate;
                                return CustomListView(
                                    dataSet: listLate,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(viewModel
                                            .listLate[index].profileId),
                                      );
                                    });
                              }
                            },
                          )
                        ],
                      ),
                      //DANH SÁCH TĂNG CA
                      Column(
                        children: [
                          // Consumer<TimeKeepingViewModel>(
                          //   builder: (context, viewModel, child) {
                          //     // Tải dữ liệu nếu cần
                          //     if (!viewModel.fetchingData &&
                          //         viewModel.listAll.isEmpty) {
                          //       // Provider.of<TimeKeepingViewModel>(context,
                          //       //         listen: false)
                          //       //     .;
                          //     }
                          //     // Hiển thị trạng thái đang tải
                          //     if (viewModel.fetchingData) {
                          //       return const Center(
                          //           child: CircularProgressIndicator());
                          //     }
                          //     // Kiểm tra danh sách rỗng
                          //     if (viewModel.listLate.isEmpty) {
                          //       if (viewModel.listLate.isEmpty) {
                          //         return Center(
                          //             child: Column(
                          //           children: [
                          //             const Text(
                          //               "Chưa có dữ liệu",
                          //               style: TextStyle(fontSize: 16),
                          //             ).py16(),
                          //             Image.asset("assets/images/no_data.png"),
                          //           ],
                          //         ));
                          //       } else {
                          //         return const Center(
                          //             child: CircularProgressIndicator());
                          //       }
                          //     }
                          //     // Danh sách các đi trễ
                          //     return CustomListView(
                          //         dataSet: viewModel.listLate,
                          //         itemBuilder: (context, index) {
                          //           return ListTile(
                          //             title: Text(
                          //                 "${viewModel.listLate[index].profileId}"),
                          //           );
                          //         });
                          //   },
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // // Hàm tạo danh sách theo trạng thái
  Widget _buildAbsentList(BuildContext context, int status) {
    return Consumer<TimeKeepingViewModel>(
      builder: (context, viewModel, child) {
        // Tải dữ liệu nếu cần
        if (!viewModel.fetchingData && viewModel.listAll.isEmpty) {
          Provider.of<TimeKeepingViewModel>(context, listen: false)
              .getAllCheckInHistory(
                  formatDatetoJson(startOfMonth), formatDatetoJson(endOfMonth));
        }

        // Hiển thị trạng thái đang tải
        if (viewModel.fetchingData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Lọc danh sách theo trạng thái
        List<Timekeepings> filteredAbsents = viewModel.listAll
            .where((timecheck) => timecheck.late == null)
            .toList();

        // Kiểm tra danh sách rỗng
        if (filteredAbsents.isEmpty) {
          return const Center(
            child: Text("Không có đơn nghỉ ở trạng thái này."),
          );
        }

        // Danh sách các đơn nghỉ việc
        return ListView.builder(
          itemCount: filteredAbsents.length,
          itemBuilder: (context, index) {
            final absent = filteredAbsents[index];
            return Card(
              child: ListTile(),
            ).onInkTap(() async {
              if (status == 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Đã duyệt. Không thể chỉnh sửa!")),
                );
                return;
              }
            });
          },
        );
      },
    );
  }
}
