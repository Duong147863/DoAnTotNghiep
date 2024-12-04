import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class TimeAttendanceTable extends StatefulWidget {
  final Profiles? user;
  TimeAttendanceTable({super.key, this.user});

  @override
  State<TimeAttendanceTable> createState() => _TimeAttendanceTableState();
}

class _TimeAttendanceTableState extends State<TimeAttendanceTable>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var listFilterTimeTypes = ["Ngày", "Tuần", "Tháng"];
  String selectedType = "Ngày";
  TextEditingController _searchController =
      TextEditingController(); // Controller cho trường tìm kiếm
  String searchQuery = ""; // Biến lưu trữ giá trị tìm kiếm
  DateTime now = DateTime.now();
  DateTime startOfWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime endOfWeek =
      DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));
// Lấy ngày đầu và cuối tháng này
  DateTime startOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
          .subtract(Duration(days: 1));
  String formatDatetoJson(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);
  String formatDatetoUI(DateTime? date) =>
      date == null ? "Không có dữ liệu" : DateFormat('dd/MM/yyyy').format(date);

  void _previousWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(Duration(days: 7));
      endOfWeek = endOfWeek.subtract(Duration(days: 7));
      _loadWeekData();
    });
  }

  void _nextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(Duration(days: 7));
      endOfWeek = endOfWeek.add(Duration(days: 7));
      _loadWeekData();
    });
  }

  // Hàm giảm 1 ngày
  void goToPreviousDay() {
    setState(() {
      now = now.subtract(Duration(days: 1));
      _loadDateData();
    });
  }

  // Hàm tăng 1 ngày
  void goToNextDay() {
    setState(() {
      now = now.add(Duration(days: 1));
      _loadDateData();
    });
  }

  // Hàm giảm 1 tháng
  void goToPreviousMonth() {
    setState(() {
      int newMonth = now.month - 1;
      int newYear = now.year;
      if (newMonth == 0) {
        newMonth = 12; // Quay lại tháng 12
        newYear--; // Giảm năm
      }
      now = DateTime(newYear, newMonth, 1);
      _loadMonthData();
    });
  }

  // Hàm tăng 1 tháng
  void goToNextMonth() {
    setState(() {
      int newMonth = now.month + 1;
      int newYear = now.year;
      if (newMonth == 13) {
        newMonth = 1; // Chuyển sang tháng 1
        newYear++; // Tăng năm
      }
      now = DateTime(newYear, newMonth, 1);
      _loadMonthData();
    });
  }

  void _loadDateData() {
    widget.user!.roleID == 3
        ? {
// gọi hàm load dữ liệu theo phòng ban
          }
        : Provider.of<TimeKeepingViewModel>(context, listen: false)
            .getAllCheckInHistory(formatDatetoJson(now), formatDatetoJson(now));
  }

  void _loadWeekData() {
    widget.user!.roleID == 3
        ? {
// gọi hàm load dữ liệu theo phòng ban
          }
        : Provider.of<TimeKeepingViewModel>(context, listen: false)
            .getAllCheckInHistory(
                formatDatetoJson(startOfWeek), formatDatetoJson(endOfWeek));
  }

  void _loadMonthData() {
    widget.user!.roleID == 3
        ? {
// gọi hàm load dữ liệu theo phòng ban
          }
        : Provider.of<TimeKeepingViewModel>(context, listen: false)
            .getAllCheckInHistory(
                formatDatetoJson(DateTime(now.year, now.month, 1)),
                formatDatetoJson(DateTime(now.year, now.month + 1, 1)));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadWeekData();
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
                DropdownButtonFormField<String>(
                  hint: const Text("Lọc theo"),
                  value: selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                      selectedType == "Ngày"
                          ? {_loadDateData()}
                          : selectedType == "Tuần"
                              ? {_loadWeekData()}
                              : {_loadMonthData()};
                    });
                  },
                  items: listFilterTimeTypes.map((String dep) {
                    return DropdownMenuItem<String>(
                      value: dep,
                      child:
                          Text(dep), // assuming department has a `name` field
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return '';
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ).p12().wTwoThird(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: selectedType == "Ngày"
                      ? [
                          Icon(Icons.arrow_back_rounded)
                              .onInkTap(goToPreviousDay),
                          Text("${DateFormat.EEEE().format(now)}, ${formatDatetoUI(now)}")
                              .px32(),
                          Icon(Icons.arrow_forward_rounded)
                              .onInkTap(goToNextDay),
                        ]
                      : selectedType == "Tuần"
                          ? [
                              Icon(Icons.arrow_back_rounded)
                                  .onInkTap(_previousWeek),
                              Text("Tuần ${formatDatetoUI(startOfWeek)} - ${formatDatetoUI(endOfWeek)}")
                                  .px32(),
                              Icon(Icons.arrow_forward_rounded)
                                  .onInkTap(_nextWeek),
                            ]
                          : [
                              Icon(Icons.arrow_back_rounded)
                                  .onInkTap(goToPreviousMonth),
                              Text("Tháng ${now.month}/${now.year}").px32(),
                              Icon(Icons.arrow_forward_rounded)
                                  .onInkTap(goToNextMonth),
                            ],
                ).p12(),
                // Thêm trường tìm kiếm
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextField(
                //     controller: _searchController,
                //     decoration: InputDecoration(
                //       labelText: "Tìm kiếm theo Mã NV",
                //       border: OutlineInputBorder(),
                //       prefixIcon: Icon(Icons.search),
                //     ),
                //     onChanged: (value) {
                //       setState(() {
                //         searchQuery = value; // Cập nhật giá trị tìm kiếm
                //       });
                //     },
                //   ),
                // ),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Đang làm việc"),
                    Tab(text: "Đi trễ"),
                    Tab(text: "Tăng ca"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContent(context, "working"),
                      _buildTabContent(context, "late"),
                      _buildTabContent(context, "overtime"),
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

  Widget _buildTabContent(BuildContext context, String type) {
    return Consumer<TimeKeepingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.fetchingData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Timekeepings> dataList;
        if (type == "working") {
          // Lọc ra những nhân viên đang làm việc, tức là không có "late" (chưa trễ)
          dataList =
              viewModel.listAll.where((item) => item.late == null).toList();
        } else if (type == "late") {
          dataList =
              viewModel.listAll.where((item) => item.late != null).toList();
        } else if (type == "overtime") {
          dataList = viewModel.listAll
              .where((item) =>
                  (DateFormat('EEEE').format(item.date) == "Saturday" ||
                      DateFormat('EEEE').format(item.date) == "Sunday"))
              .toList();
        } else {
          dataList = viewModel.listAll
              .where((item) => item.leavingSoon != null)
              .toList();
        }

        if (dataList.isEmpty) {
          return const Center(child: Text("Không có dữ liệu."));
        } else {
          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final item = dataList[index];

              // Format thời gian checkin và checkout
              String checkinTime = DateFormat('HH:mm:ss').format(item.checkin);
              String checkoutTime = item.checkout != null
                  ? DateFormat('HH:mm:ss').format(item.checkout!)
                  : "Không có dữ liệu";

              return Card(
                child: ListTile(
                  title: Text("Nhân viên: ${item.profileId}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${DateFormat('EEEE, dd/MM/yyyy').format(item.date.toUtc())}"),
                      type == "working"
                          ? Text(
                              "Thời gian vào: $checkinTime - ra: $checkoutTime")
                          : type == "late"
                              ? Text(
                                  item.late != null
                                      ? "Trễ: ${DateFormat('HH:mm').format(item.late!)} phút"
                                      : "Trễ: Không có dữ liệu",
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text("Tăng ca: ${item.date.toUtc()}",
                                  style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
