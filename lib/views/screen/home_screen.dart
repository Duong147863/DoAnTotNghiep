import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _getData() {
    return [
      {
        'icon': Icons.supervisor_account,
        'text': 'employee_management'.tr(),
        'route': AppRoutes.profileListRoute
      },
      // {
      //   'icon': Icons.groups_rounded,
      //   'text': 'Phòng ban',
      //   'route': AppRoutes.departmentListRoute
      // },
      {
        'icon': Icons.currency_exchange,
        'text': 'payroll_managment'.tr(),
        'route': AppRoutes.salariListRoute,
      },
      // {
      //   'icon': Icons.menu_book_outlined,
      //   'text': 'Bằng cấp',
      //   'route': AppRoutes.diplomaListRoute
      // },
      // {
      //   'icon': Icons.supervisor_account,
      //   'text': 'Thân nhân',
      //   'route': AppRoutes.relativeListRoute
      // },
      {
        'icon': Icons.home_work_rounded,
        'text': 'your_enterprise'.tr(),
        'route': AppRoutes.enterpriseListRoute
      },
      {
        'icon': Icons.business_center_rounded,
        'text': 'Dự án',
        'route': AppRoutes.projectListRoute
      },
      // {
      //   'icon': Icons.assignment_ind_rounded,
      //   'text': 'Chức vụ',
      //   'route': AppRoutes.ponsitionListRoute
      // },
      // {
      //   'icon': Icons.description_rounded,
      //   'text': 'Quyết định',
      //   'route': AppRoutes.decisionListRoute
      // },
    ];
  }

  bool light = true;
  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [],
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
              leading: Icon(Icons.logout),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.loginRoute);
              },
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
                "Hi, Username",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFEFF8FF),
                    fontWeight: FontWeight.w600),
              ),
            ).p(10),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
          ],
        ),
      ),
      backgroundColor: AppColor.primaryLightColor,
      defaultBody: true,
      bodyChildren: [CustomGridView(
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
          Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMenuItem('Client Management', Icons.add_circle_outline),
            SizedBox(height: 16.0),
            _buildMenuItem('NOC/Ex Certificate', Icons.access_time),
            SizedBox(height: 16.0),
            _buildMenuItem('Notice Board', Icons.access_time),
            SizedBox(height: 16.0),
            _buildMenuItem('Award', Icons.folder),
          ],
        ),
      ),]
          
    );
  }
  Widget _buildMenuItem(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
