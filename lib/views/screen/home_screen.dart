import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/empty_widget.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';
import 'package:nloffice_hrm/views/screen/add_absent_request_screen.dart';
import 'package:nloffice_hrm/views/screen/add_labor_contract_screen.dart';
import 'package:nloffice_hrm/views/screen/add_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/add_shifts_screen.dart';
import 'package:nloffice_hrm/views/screen/enterprise_screen.dart';
import 'package:nloffice_hrm/views/screen/info_enterprises_screen.dart';
import 'package:nloffice_hrm/views/screen/list_project_screen.dart';
import 'package:nloffice_hrm/views/screen/list_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/list_shifts_screen.dart';
import 'package:nloffice_hrm/views/screen/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

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
  List<Map<String, dynamic>> _getData() {
    if (AppStrings.ROLE_PERMISSIONS
        .containsAny(['Manage BoD & HR accounts', 'Manage Staffs info only'])) {
      return [
        {
          'icon': Icons.supervisor_account,
          'text': 'Quản lí nhân sự',
          'route': AppRoutes.employeeManagmentScreen
        },
        {
          'icon': Icons.currency_exchange,
          'text': 'Quản lí lương',
          'route': AppRoutes.salariListRoute,
        },
        {
          'icon': Icons.business_center_rounded,
          'text': 'Quản lí chức vụ',
          'route': AppRoutes.positionListRoute
        },
        {
          'icon': Icons.work_off_sharp,
          'text': 'Quản lí nghỉ phép',
          'route': AppRoutes.leaveRequestList
        },
      ];
    } else if (AppStrings.ROLE_PERMISSIONS
        .containsAny(['Manage your department members only'])) {
      return [
        {
          'icon': Icons.supervisor_account,
          'text': 'Quản lí phòng ban',
          'route': AppRoutes.employeeManagmentScreen
        },
      ];
    }
    return [];
  }

  bool light = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profilesViewModel = Provider.of<ProfilesViewModel>(context);
    final data = _getData();
    return BasePage(
        appBarItemColor: AppColor.boneWhite,
        showAppBar: true,
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Colors.blueAccent,
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
                              child: widget.profile!.profileImage.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(
                                          widget.profile!.profileImage),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error,
                                            size: 30, color: Colors.grey);
                                      },
                                    )
                                  : Icon(Icons.person,
                                      size: 30, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.profile!.profileName,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.profile!.positionId!.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text("Doanh nghiệp"),
                onTap: () {},
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ListTile(
                    title: Text('Đăng xuất'),
                    leading: const Icon(Icons.logout),
                    onTap: () {
                      profilesViewModel.logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.loginRoute, (route) => false);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF0B258A),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Xin chào " + widget.profile!.profileName,
                  style: TextStyle(
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
          SizedBox(height: 20),
          AppStrings.ROLE_PERMISSIONS.contains(
                  'Manage BoD & HR accounts') // KIỂM TRA QUYỀN VÀ HIỂN THỊ CHỨC NĂNG THEO QUYỀN
              ? UiSpacer.emptySpace()
              : InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.timeAttendanceRoute);
                  },
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: [Color(0xFF7B42F6), Color(0xFF1CA9F4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
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
          SizedBox(height: 20),
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
                ).onTap(() => Navigator.of(context).pushNamed(item['route']));
              }),
          Text("Công việc của bạn",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
          Divider().px12(),
          Container(
            child: CustomGridView(
                dataSet: data,
                crossAxisCount: 3,
                childAspectRatio: 2,
                itemBuilder: (context, index) {
                  return Card();
                }),
          ).p8(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      AddRelativeScreen(profile: widget.profile),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Button rounded corners
              ),
            ),
            child: Text("Add Relative",style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      RelativeListScreen(profiles: widget.profile),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Button rounded corners
              ),
            ),
            child: Text("List Relative",style: TextStyle(color: Colors.black),),
          ),
           ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      ListShiftsScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Button rounded corners
              ),
            ),
            child: Text("List Shifts Screen",style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      ListProjectScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Button rounded corners
              ),
            ),
            child: Text("List Project Screen",style: TextStyle(color: Colors.black),),
          ),
           ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      AddLaborContractScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Button rounded corners
              ),
            ),
            child: Text("Add Labor Contract Screen",style: TextStyle(color: Colors.black),),
          )
        ]);
  }
}
