import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class PayrollScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      titletext: "Phiếu lương",
      appBarColor: AppColor.primaryLightColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Information
            Center(
              child: Text(
                'PHIẾU LƯƠNG 3/11/2024',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mã Số NV: Dev003', style: TextStyle(fontSize: 16)),
                Text('Tên NV: Nguyễn Bình Dương', style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chức vụ: ', style: TextStyle(fontSize: 16)),
                Text('', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 16),
            // Salary Table
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    Center(child: Text('STT', style: TextStyle(fontWeight: FontWeight.bold))),
                    Center(child: Text('Chỉ tiêu', style: TextStyle(fontWeight: FontWeight.bold))),
                    Center(child: Text('Số tiền', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                _buildTableRow(['1', 'Hệ số lương', '26']),
                _buildTableRow(['2', 'Trợ cấp', '']),
                _buildTableRow(['3', 'Thưởng', '315,000']),
                _buildTableRow(['4', 'Trừ đi', '310,500']),
                _buildTableRow(['5', 'Thuế cá nhân', '']),
                _buildTableRow(['6', 'Tiền ứng trước', '']),
                _buildTableRow(['', 'Tổng ', '625,500']),
              ],
            ),
            SizedBox(height: 16),

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('NGƯỜI LẬP', style: TextStyle(fontSize: 16)),
                Text('NGƯỜI LAO ĐỘNG', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell, textAlign: TextAlign.center),
        );
      }).toList(),
    );
  }
}
