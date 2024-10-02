import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/bottom_nav_controller.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      //     Switch(
      //         value: light,
      //         activeColor: Colors.yellow,
      //         inactiveThumbColor: Colors.black,
      //         thumbIcon: WidgetStatePropertyAll<Icon>(Icon(light
      //             ? Icons.light_mode_rounded
      //             : Icons.nightlight_outlined)),
      //         onChanged: (bool value) {
      //           setState(() {
      //             light = value;
      //           });
      //         }),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              // pinned: true,
              expandedHeight: 220.0,
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFF0B258A),
              shape: ContinuousRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
              ),
              flexibleSpace: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Hi, Username",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ).p(10),
                      Switch(
                          value: light,
                          activeColor: Colors.yellow,
                          inactiveThumbColor: Colors.black,
                          thumbIcon: WidgetStatePropertyAll<Icon>(Icon(light
                              ? Icons.light_mode_rounded
                              : Icons.nightlight_outlined)),
                          onChanged: (bool value) {
                            setState(() {
                              light = value;
                            });
                          }),
                    ],
                  )
                ],
              )),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(100))),
                    child: Column()),
              ],
            ),
          )
        ],
      ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Container(
      //       height: 250,
      //       width: double.infinity,
      //       padding: EdgeInsets.only(right: 20, left: 20),
      //       decoration: BoxDecoration(
      //         color: Color(0xFF0B258A),
      //         borderRadius:
      //             BorderRadius.only(bottomRight: Radius.circular(100)),
      //       ),
      //       child: Column(children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Align(
      //               alignment: Alignment.centerLeft,
      //               child: Text(
      //                 "Hi, Username",
      //                 style: TextStyle(
      //                     fontSize: 25,
      //                     color: Colors.white,
      //                     fontWeight: FontWeight.w600),
      //               ),
      //             ),
      //             Switch(
      //                 value: light,
      //                 activeColor: Colors.yellow,
      //                 inactiveThumbColor: Colors.black,
      //                 thumbIcon: WidgetStatePropertyAll<Icon>(Icon(light
      //                     ? Icons.light_mode_rounded
      //                     : Icons.nightlight_outlined)),
      //                 onChanged: (bool value) {
      //                   setState(() {
      //                     light = value;
      //                   });
      //                 }),
      // Container(
      //   height: 50,
      //   width: 50,
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(10),
      //       color: Colors.white.withOpacity(.4),
      //       border: Border.all(
      //         color: Colors.white.withOpacity(.5),
      //       ),
      //       image: DecorationImage(
      //           image: AssetImage("assets/image/male_avatar.png"))),
      // )
      //             ],
      //           ),
      //         ]),
      //       ),
      bottomNavigationBar: CustomBottomNavBar(),
      fabl: FloatingActionButtonLocation.centerDocked,
      fab: FloatingActionButton(
        child: Icon(Icons.apps_rounded),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.menuRoute);
        },
      ),
    );
  }
}
