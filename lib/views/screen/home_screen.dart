import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  final Profiles? profile;

  const HomeScreen({super.key, this.profile});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _getData() {
    return [
      {
        'icon': Icons.supervisor_account,
        'text': 'employee_management'.tr(),
        'route': AppRoutes.employeeManagmentScreen
      },
      {
        'icon': Icons.currency_exchange,
        'text': 'payroll_managment'.tr(),
        'route': AppRoutes.salariListRoute,
      },
      {
        'icon': Icons.business_center_rounded,
        'text': 'department'.tr(),
        'route': AppRoutes.departmentListRoute
      },
    ];
  }

  bool light = true;

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
          child: ListView(
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
                      // CircleAvatar(
                      //   radius: 30,
                      //    backgroundImage: NetworkImage(widget.profile.profileImage),
                      // ),
                      // SizedBox(height: 8),
                      // Text(
                      //   widget.profile.profileName,
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // Text(
                      //  widget.profile.positionId.toString(),
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.white70,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text('language_setting'.tr()),
                leading: Icon(Icons.language),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.languageRoute);
                },
              ),
              ListTile(
                leading: Icon(Icons.color_lens_outlined),
                title: Text('theme_switch'.tr()),
                trailing: Switch(
                    value: light,
                    activeColor: AppColor.primaryDarkColor,
                    inactiveThumbColor: Colors.black,
                    thumbIcon: WidgetStatePropertyAll<Icon>(Icon(light
                        ? Icons.light_mode_rounded
                        : Icons.nightlight_outlined)),
                    onChanged: (bool value) {
                      setState(() {
                        light = value;
                      });
                    }),
              ),
              ListTile(
                title: Text('log_out'.tr()),
                leading: const Icon(Icons.logout),
                onTap: () {
                  profilesViewModel.logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.loginRoute, (route) => false);
                },
              ).onInkTap(() async {}),
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
                  "hello_".tr() + widget.profile!.profileName!,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFEFF8FF),
                      fontWeight: FontWeight.w600),
                ),
              ).p(10),
              IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, AppRoutes.noconnetionRoute);
                  },
                  icon: Icon(Icons.notifications))
            ],
          ),
        ),
        backgroundColor: AppColor.primaryLightColor,
        defaultBody: true,
        bodyChildren: [
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.timeAttendanceRoute);
            },
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
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
        ]);
  }
}
