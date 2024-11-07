import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        'icon': Icons.add_circle_outline,
        'text': 'Thêm nhân viên'.tr(),
        'route': AppRoutes.addprofileRoute
      },
      {
        'icon': Icons.supervisor_account,
        'text': 'Danh sách nhân viên'.tr(),
        'route': AppRoutes.employeeListRoute
      },
      {
        'icon': Icons.calendar_month_outlined,
        'text': 'Nghỉ phép'.tr(),
        'route': AppRoutes.leaveRequestList
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
                CustomGridView(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    dataSet: data,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Card(
                        color: Color.fromARGB(255, 243, 243, 242),
                        elevation: 1,
                        margin: EdgeInsets.all(13),
                        child: Wrap(
                          clipBehavior: Clip.antiAlias,
                          direction: Axis.vertical,
                          children: [
                            Icon(item['icon'], size: 16),
                            Text(
                              item['text'],
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ).p(13),
                      ).onTap(
                          () => Navigator.of(context).pushNamed(item['route']));
                    }),
              ],
            ),
          ),
        ]);
  }
}
