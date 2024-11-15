import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/views/screen/qr_scan.dart';

import '../../models/profiles_model.dart';

class TimeAttendance extends StatefulWidget {
  Profiles loginUser;

  TimeAttendance({super.key, required this.loginUser});

  @override
  _TimeAttendanceState createState() => _TimeAttendanceState();
}

class _TimeAttendanceState extends State<TimeAttendance>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        showAppBar: true,
        showLeadingAction: true,
        defaultBody: true,
        appBarItemColor: AppColor.boneWhite,
        backgroundColor: AppColor.offWhite,
        appBar: AppBar(
          backgroundColor: Color(0xFF0B258A),
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            'Time Attendance',
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
                tabs: [
                  Tab(text: 'Check-in'),
                  Tab(text: 'History'),
                ],
              ),
            ),
          ),
        ),
        bodyChildren: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                QrScan(
                  user: widget.loginUser,
                ),
                HistoryTab(),
              ],
            ),
          ),
        ]);
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
    return DateFormat('MMMM yyyy')
        .format(_selectedMonth); // Định dạng hiển thị tháng và năm
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
                color: DateTime(_selectedMonth.year, _selectedMonth.month, day)
                            .weekday ==
                        7
                    ? Colors.red
                    : Colors.black,
              ),
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
