import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class Screen_Dot extends StatefulWidget {
  const Screen_Dot({super.key});

  @override
  State<Screen_Dot> createState() => _Screen_DotState();
}

class _Screen_DotState extends State<Screen_Dot> {
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
                "Shaidul Islam Details",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFEFF8FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      bodyChildren: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWorkingHoursSection(),
              SizedBox(height: 16.0),
              _buildAttendanceSection(),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Delete'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildWorkingHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Hours',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              '6 30 m',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        _buildWorkingHoursChart(),
      ],
    );
  }

  Widget _buildWorkingHoursChart() {
    // Implement the working hours chart here
    return Container();
  }

  Widget _buildAttendanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            _buildAttendanceItem('Present', 13, Colors.green),
            SizedBox(width: 8.0),
            _buildAttendanceItem('Absent', 0, Colors.red),
            SizedBox(width: 8.0),
            _buildAttendanceItem('Holiday', 3, Colors.blue),
            SizedBox(width: 8.0),
            _buildAttendanceItem('Half Day', 4, Colors.orange),
            SizedBox(width: 8.0),
            _buildAttendanceItem('Week Off', 4, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceItem(String title, int count, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 4.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}