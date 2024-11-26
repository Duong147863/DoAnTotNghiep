import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/view_models/shifts_view_model.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/views/screen/qr_scan.dart';
import 'package:provider/provider.dart';

import '../../models/profiles_model.dart';
import '../../models/shifts_model.dart';

class TimeAttendance extends StatefulWidget {
  Profiles loginUser;
  TimeAttendance({super.key, required this.loginUser});
  @override
  _TimeAttendanceState createState() => _TimeAttendanceState();
}

class _TimeAttendanceState extends State<TimeAttendance>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Shifts? currentShift;
  List<Timekeepings> list = [];
  @override
  void initState() {
    super.initState();
    getShiftAuto();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Future<void> dispose() async {
    _tabController.dispose();
    super.dispose();
  }

  void getShiftAuto() async {
    await Provider.of<ShiftsViewModel>(context, listen: false).getAllShifts();
    List<Shifts> allShifts =
        Provider.of<ShiftsViewModel>(context, listen: false).listShifts;
    DateTime now = DateTime.now();
    // Duyệt qua tất cả các ca làm việc
    for (var shift in allShifts) {
      if (now.isAfter(shift.startTime) && now.isBefore(shift.endTime)) {
        setState(() {
          currentShift = shift;
        });
        break; // Nếu đã tìm thấy ca làm việc hiện tại, dừng lại
      }
      // Nếu không có ca nào khớp, chọn ca tiếp theo
      if (currentShift == null) {
        if (now.isBefore(shift.startTime)) {
          setState(() {
            currentShift = shift;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      // defaultBody: true,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.offWhite,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B258A),
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Chấm công',
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Color(0xFF0B258A), // Màu cho đường viền của tab
              labelColor: Colors.black, // Màu cho tab đang chọn
              tabs: const [
                Tab(text: 'Quét QR'),
                Tab(text: 'Lịch sử chấm công'),
              ],
            ),
          ),
        ),
      ),
      body: Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            Consumer<ShiftsViewModel>(builder: (context, viewModel, child) {
              getShiftAuto();
              if (currentShift == null) {
                getShiftAuto();
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else
                return QrScan(
                  user: widget.loginUser,
                  currentShift: currentShift ?? currentShift!,
                );
            }),
            HistoryTab(),
            // Consumer<TimeKeepingViewModel>(
            //     builder: (context, viewModel, child) {
            //   if (viewModel.list1.isEmpty && !viewModel.fetchingData) {
            //     Provider.of<TimeKeepingViewModel>(context, listen: false)
            //         .getProfileCheckInHistory(widget.loginUser.profileId);
            //   }
            //   if (viewModel.fetchingData) {
            //     return const Center(child: CircularProgressIndicator());
            //   } else
            //     return ExpansionPanelList(
            //       elevation: 1,
            //       expandedHeaderPadding: EdgeInsets.all(0),
            //       expansionCallback: (int index, bool isExpanded) {
            //         setState(() {
            //           list[index].isExpanded = isExpanded;
            //         });
            //       },
            //       children: list.map((time) {
            //         return ExpansionPanel(
            //             headerBuilder: (BuildContext context, bool isExpanded) {
            //               return ListTile(
            //                 contentPadding: EdgeInsets.symmetric(
            //                     vertical: 10, horizontal: 16),
            //                 leading: Icon(Icons.school,
            //                     color: const Color.fromARGB(255, 183, 255, 68)),
            //                 title: Text(
            //                   time.profileId,
            //                   style: TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.bold),
            //                 ),
            //               );
            //             },
            //             body: Center());
            //       }).toList(),
            //     );
            // })
          ],
        ),
      ),
    );
  }
}

class HistoryTab extends StatefulWidget {
  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  DateTime _selectedMonth = DateTime.now(); // Biến lưu trữ tháng hiện tại

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
      );
    });
  }

  String get _monthYearText {
    return "Tháng ${DateFormat('MM/yyyy').format(_selectedMonth)}"; // Định dạng hiển thị tháng và năm
  }

  List<TableRow> _buildCalendar() {
    // Lấy ngày đầu và cuối của tháng hiện tại
    int daysInMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    int firstDayOfWeek =
        DateTime(_selectedMonth.year, _selectedMonth.month, 1).weekday;

    List<TableRow> rows = [];

    // Hàng tiêu đề các ngày trong tuần
    rows.add(
      TableRow(
        children: List.generate(
          7,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                index == 6 ? 'CN' : 'Thứ ${index + 2}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );

    // Hàng chứa các ngày trong tháng
    List<Widget> dayWidgets = [];
    for (int i = 1; i < firstDayOfWeek; i++) {
      dayWidgets.add(Container()); // Ô trống trước ngày đầu tiên của tháng
    }
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                  fontWeight:
                      DateTime(_selectedMonth.year, _selectedMonth.month, day)
                                  .weekday ==
                              7
                          ? FontWeight.bold
                          : FontWeight.normal),
            ),
          ),
        ),
      );
      if ((dayWidgets.length % 7) == 0) {
        rows.add(TableRow(children: dayWidgets));
        dayWidgets = [];
      }
    }
    if (dayWidgets.isNotEmpty) {
      while (dayWidgets.length < 7) {
        dayWidgets.add(Container()); // Ô trống sau ngày cuối cùng của tháng
      }
      rows.add(TableRow(children: dayWidgets));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Tiêu đề tháng với nút điều hướng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousMonth, // Chuyển về tháng trước
              ),
              Text(
                _monthYearText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextMonth, // Chuyển sang tháng tiếp theo
              ),
            ],
          ),
          SizedBox(height: 10),
          Table(
            border: TableBorder.all(),
            children: _buildCalendar(),
          ),
        ],
      ),
    );
  }
}
