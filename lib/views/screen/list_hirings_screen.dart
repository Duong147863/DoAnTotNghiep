import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/hirings_model.dart';
import 'package:nloffice_hrm/view_models/hirings_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/screen/add_hirings_screen.dart';
import 'package:nloffice_hrm/views/screen/info_hirings_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ListHiringsScreen extends StatefulWidget {
  const ListHiringsScreen({super.key});

  @override
  State<ListHiringsScreen> createState() => _ListHiringsScreenState();
}

class _ListHiringsScreenState extends State<ListHiringsScreen> {
  List<Hirings> hirings = [];
  List<Hirings> filteredHirings = [];
  TextEditingController _searchController =
      TextEditingController(); // Controller cho trường tìm kiếm

  @override
  void initState() {
    super.initState();
    filteredHirings = hirings; // Ban đầu hiển thị tất cả
  }

  void _handleUpdate(Hirings updatedHirings) {
    setState(() {
      int index = hirings.indexWhere(
          (hir) => hir.hiringProfileId == updatedHirings.hiringProfileId);
      if (index != -1) {
        hirings[index] = updatedHirings;
      }
    });
  }

  // Widget _buildHiringList(BuildContext context, int status) {
  //   return Consumer<HiringsViewModel>(
  //     builder: (context, viewModel, child) {
  //       if (!viewModel.fetchingData && viewModel.listHirigns.isEmpty) {
  //         Provider.of<HiringsViewModel>(context, listen: false).getAllHirings();
  //       }

  //       if (viewModel.fetchingData) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       // Lọc danh sách theo trạng thái
  //       List<Hirings> filteredHirings = viewModel.listHirigns
  //           .where((hiring) => hiring.hiringStatus == status)
  //           .toList();

  //       if (filteredHirings.isEmpty) {
  //         return const Center(
  //           child: Text("Không có dữ liệu tuyển dụng ở trạng thái này."),
  //         );
  //       }

  //       return ListView.builder(
  //         itemCount: filteredHirings.length,
  //         itemBuilder: (context, index) {
  //           final hiring = filteredHirings[index];
  //           return Card(
  //             child: ListTile(
  //               title: Text(
  //                   "Tên ứng cử viên: ${hiring.profileName} - Ngày sinh: ${DateFormat('dd/MM/yyyy').format(hiring.birthday).toString()}"),
  //               subtitle: Text(
  //                 status == -1
  //                     ? "Đã từ chối"
  //                     : status == 0
  //                         ? "Ứng viên mới"
  //                         : status == 1
  //                             ? "Phỏng vấn"
  //                             : status == 2
  //                                 ? "Đề nghị làm"
  //                                 : status == 3
  //                                     ? "Đã duyệt"
  //                                     : "",
  //                 style: TextStyle(
  //                   color: status == -1
  //                       ? Colors.red
  //                       : status == 0
  //                           ? Colors.yellow
  //                           : status == 1
  //                               ? Colors.green
  //                               : status == 2
  //                                   ? Colors.blue
  //                                   : status == 3
  //                                       ? Colors.orange
  //                                       : const Color.fromARGB(255, 0, 0, 0),
  //                 ),
  //               ),
  //             ),
  //           ).onInkTap(() async {
  //             final updatedHirings = await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => InfoHiringsScreen(hirings: hiring),
  //               ),
  //             );

  //             if (updatedHirings != null) {
  //               _handleUpdate(updatedHirings);
  //             }
  //           });
  //         },
  //       );
  //     },
  //   );
  // }
  // Lọc danh sách tuyển dụng theo trạng thái, tên và năm sinh nếu có tìm kiếm
  Widget _buildHiringList(BuildContext context, int status) {
    return Consumer<HiringsViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.fetchingData && viewModel.listHirigns.isEmpty) {
          Provider.of<HiringsViewModel>(context, listen: false).getAllHirings();
        }

        if (viewModel.fetchingData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Lọc danh sách theo trạng thái
        List<Hirings> hiringsToDisplay = viewModel.listHirigns
            .where((hiring) => hiring.hiringStatus == status)
            .toList();

        // Lọc theo tên hoặc năm sinh từ _searchController
        String query = _searchController.text;

        List<Hirings> filteredHirings = hiringsToDisplay.where((hiring) {
          // Lọc theo tên ứng viên
          bool matchesName =
              hiring.profileName.toLowerCase().contains(query.toLowerCase());

          // Lọc theo năm sinh nếu có tìm kiếm năm sinh
          bool matchesYear = false;
          if (query.isNotEmpty) {
            // Kiểm tra xem query có phải là năm sinh (chỉ chứa số)
            RegExp yearRegExp = RegExp(r'^\d{4}$');
            if (yearRegExp.hasMatch(query)) {
              String yearOfBirth = DateFormat('yyyy').format(hiring.birthday);
              matchesYear = yearOfBirth.contains(query);
            }
          }

          return matchesName || matchesYear;
        }).toList();

        if (filteredHirings.isEmpty) {
          return const Center(
            child: Text("Không có dữ liệu tuyển dụng ở trạng thái này."),
          );
        }

        return ListView.builder(
          itemCount: filteredHirings.length,
          itemBuilder: (context, index) {
            final hiring = filteredHirings[index];
            return Card(
              child: ListTile(
                title: Text(
                    "Tên ứng cử viên: ${hiring.profileName} - Ngày sinh: ${DateFormat('dd/MM/yyyy').format(hiring.birthday).toString()}"),
                subtitle: Text(
                  status == -1
                      ? "Đã từ chối"
                      : status == 0
                          ? "Ứng viên mới"
                          : status == 1
                              ? "Phỏng vấn"
                              : status == 2
                                  ? "Đề nghị làm"
                                  : status == 3
                                      ? "Đã duyệt"
                                      : "",
                  style: TextStyle(
                    color: status == -1
                        ? Colors.red
                        : status == 0
                            ? Colors.yellow
                            : status == 1
                                ? Colors.green
                                : status == 2
                                    ? Colors.blue
                                    : status == 3
                                        ? Colors.orange
                                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ).onInkTap(() async {
              final updatedHirings = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoHiringsScreen(hirings: hiring),
                ),
              );

              if (updatedHirings != null) {
                _handleUpdate(updatedHirings);
              }
            });
          },
        );
      },
    );
  }

  @override
  // Widget build(BuildContext context) {
  //   return BasePage(
  //     showAppBar: true,
  //     showLeadingAction: true,
  //     defaultBody: true,
  //     appBarItemColor: AppColor.boneWhite,
  //     backgroundColor: AppColor.primaryLightColor,
  //     appBarColor: AppColor.primaryLightColor,
  //     titletext: "Quản lý tuyển dụng",
  //     bodyChildren: [
  //       Expanded(
  //         child: DefaultTabController(
  //           length: 5,
  //           child: Column(
  //             children: [
  //               // TabBar
  //               Container(
  //                 color: AppColor.primaryLightColor,
  //                 child: const TabBar(
  //                   labelColor: Colors.white,
  //                   unselectedLabelColor: Colors.grey,
  //                   indicatorColor: Colors.white,
  //                   tabs: const [
  //                     Tab(
  //                         child: FittedBox(
  //                             child: Text(
  //                       "Ứng viên mới",
  //                       style: TextStyle(fontSize: 17),
  //                     ))),
  //                     Tab(
  //                         child: FittedBox(
  //                             child: Text("Phỏng vấn",
  //                                 style: TextStyle(fontSize: 17)))),
  //                     Tab(
  //                         child: FittedBox(
  //                             child: Text("Đề nghị làm",
  //                                 style: TextStyle(fontSize: 17)))),
  //                     Tab(
  //                         child: FittedBox(
  //                             child: Text("Đã duyệt",
  //                                 style: TextStyle(fontSize: 17)))),
  //                     Tab(
  //                         child: FittedBox(
  //                             child: Text("Đã từ chối",
  //                                 style: TextStyle(fontSize: 17)))),
  //                   ],
  //                 ),
  //               ),
  //               // TabBarView
  //               Expanded(
  //                 child: TabBarView(
  //                   children: [
  //                     _buildHiringList(context, 0), // Ứng viên mới
  //                     _buildHiringList(context, 1), // Phỏng vấn
  //                     _buildHiringList(context, 2), // Đề nghị làm
  //                     _buildHiringList(context, 3), // Đã duyệt
  //                     _buildHiringList(context, -1), // Từ chối
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //     fab: FloatingActionButton(
  //       onPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => AddHiringsScreen(),
  //           ),
  //         );
  //       },
  //       child: const Icon(Icons.add),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: true,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      appBarColor: AppColor.primaryLightColor,
      titletext: "Quản lý tuyển dụng",
      bodyChildren: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 5,
                  child: Column(
                    children: [
                      // TabBar
                      Container(
                        color: AppColor.primaryLightColor,
                        child: const TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.white,
                          tabs: [
                            Tab(child: Text("Ứng viên")),
                            Tab(child: Text("Phỏng vấn")),
                            Tab(child: Text("Đề nghị làm")),
                            Tab(child: Text("Đã duyệt")),
                            Tab(child: Text("Đã từ chối")),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: "Tìm kiếm theo tên hoặc năm sinh",
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      // TabBarView
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildHiringList(context, 0), // Ứng viên mới
                            _buildHiringList(context, 1), // Phỏng vấn
                            _buildHiringList(context, 2), // Đề nghị làm
                            _buildHiringList(context, 3), // Đã duyệt
                            _buildHiringList(context, -1), // Từ chối
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHiringsScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
