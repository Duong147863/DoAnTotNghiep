import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/roles_model.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/view_models/roles_view_models.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_absent_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ListAbsentScreen extends StatefulWidget {
  Profiles? profiles;

  ListAbsentScreen({super.key, this.profiles});

  @override
  State<ListAbsentScreen> createState() => _ListAbsentScreenState();
}

class _ListAbsentScreenState extends State<ListAbsentScreen> {
  List<Absents> absents = [];
  List<Absents> filteredAbsents = [];
  List<Roles> roles = [];
  Roles? selectedRoles;
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAbsents = absents; // Show all absents if query is empty
      } else {
        filteredAbsents = absents.where((absent) {
          return absent.reason!
              .toLowerCase()
              .contains(query.toLowerCase()); // Filter based on reason
        }).toList();
      }
    });
  }

  void _handleUpdate(Absents updatedAbsent) {
    setState(() {
      int index = absents.indexWhere((abs) => abs.ID == updatedAbsent.ID);
      if (index != -1) {
        absents[index] = updatedAbsent;
      }
    });
  }
  void _loadRoles() async {
    try {
      await Provider.of<RolesViewModels>(context, listen: false).getAllRoles();
      List<Roles> allRoles =
          Provider.of<RolesViewModels>(context, listen: false).listRoles;
      if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
        roles = allRoles
            .where((role) => [1, 2, 3, 4, 5].contains(role.roleID))
            .toList();
      } else if (AppStrings.ROLE_PERMISSIONS
          .contains('Manage Staffs info only')) {
        roles = allRoles
            .where((role) => [1, 2, 3, 4].contains(role.roleID))
            .toList();
      } else {
        roles = [];
      }

      setState(() {
        if (roles.isNotEmpty) {
          selectedRoles = roles.firstWhere(
            (rol) => rol.roleID == widget.profiles!.roleID,
          );
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Roles $error')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    //   return BasePage(
    //   showAppBar: true,
    //   showLeadingAction: true,
    //   defaultBody: true,
    //   appBarItemColor: AppColor.boneWhite,
    //   backgroundColor: AppColor.primaryLightColor,
    //   appBarColor: AppColor.primaryLightColor,
    //   titletext: "Nghỉ phép",
    //   bodyChildren: [
    //     Expanded(
    //       child: SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: CustomSearchBar(
    //                 suggestions: absents
    //                     .map((absent) => absent.profileID)
    //                     .toList(),
    //                 onTextChanged: _handleSearch,
    //                 hintText: '',
    //               ),
    //             ),
    //             AppStrings.ROLE_PERMISSIONS.containsAny([
    //                   'Manage Staffs info only',
    //                   'Manage BoD & HR accounts'
    //                 ])
    //             ? Consumer<AbsentsViewModel>(
    //               builder: (context, viewModel, child) {
    //                 // Fetch data if not already loaded
    //                 if (!viewModel.fetchingData && viewModel.listAbsents.isEmpty) {
    //                   Provider.of<AbsentsViewModel>(context, listen: false)
    //                       .fetchAllAbsents();
    //                 }
    //                 // Show loading indicator while fetching data
    //                 if (viewModel.fetchingData) {
    //                   return Center(child: CircularProgressIndicator());
    //                 } else {
    //                   List<Absents> absents = viewModel.listAbsents;
    //                   return ListView.builder(
    //                     shrinkWrap: true, // Important for nested scrolling
    //                     physics: NeverScrollableScrollPhysics(), // Prevent inner scroll
    //                     itemCount: absents.length,
    //                     itemBuilder: (context, index) {
    //                       return Card(
    //                         child: ListTile(
    //                           title: Text("${absents[index].profileID}"),
    //                           subtitle: Text(
    //                             absents[index].status == -1
    //                                 ? "Từ Chối Duyệt"
    //                                 : absents[index].status == 0
    //                                     ? "Đợi Duyệt"
    //                                     : absents[index].status == 1
    //                                         ? "Đã Duyệt"
    //                                         : "Trạng Thái Không Hợp Lệ",
    //                             style: TextStyle(
    //                               color: absents[index].status == -1
    //                                   ? Colors.red
    //                                   : absents[index].status == 0
    //                                       ? Colors.yellow
    //                                       : absents[index].status == 1
    //                                           ? Colors.green
    //                                           : Colors.black,
    //                             ),
    //                           ),
    //                         ),
    //                       ).onInkTap(() async {
    //                         if (absents[index].status == 1) {
    //                           ScaffoldMessenger.of(context).showSnackBar(
    //                             SnackBar(
    //                               content: Text("Đã duyệt. Không thể chỉnh sửa!"),
    //                             ),
    //                           );
    //                           return;
    //                         }
    //                         final updatedAbsent = await Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) => InfoAbsentScreen(
    //                               absents: absents[index],
    //                             ),
    //                           ),
    //                         );

    //                         // Kiểm tra xem có dữ liệu cập nhật không
    //                         if (updatedAbsent != null) {
    //                           _handleUpdate(updatedAbsent);
    //                         }
    //                       });
    //                     },
    //                   );
    //                 }
    //               },
    //             ):
    //             Consumer<AbsentsViewModel>(
    //               builder: (context, viewModel, child) {
    //                 // Fetch data if not already loaded
    //                 if (!viewModel.fetchingData && viewModel.listAbsents.isEmpty) {
    //                   Provider.of<AbsentsViewModel>(context, listen: false)
    //                       .getPersonalAbsents(widget.profiles!.profileId);
    //                 }
    //                 // Show loading indicator while fetching data
    //                 if (viewModel.fetchingData) {
    //                   return Center(child: CircularProgressIndicator());
    //                 } else {
    //                   List<Absents> absents = viewModel.listAbsents;
    //                   return ListView.builder(
    //                     shrinkWrap: true, // Important for nested scrolling
    //                     physics: NeverScrollableScrollPhysics(), // Prevent inner scroll
    //                     itemCount: absents.length,
    //                     itemBuilder: (context, index) {
    //                       return Card(
    //                         child: ListTile(
    //                           title: Text("${absents[index].profileID}"),
    //                           subtitle: Text(
    //                             absents[index].status == -1
    //                                 ? "Từ Chối Duyệt"
    //                                 : absents[index].status == 0
    //                                     ? "Đợi Duyệt"
    //                                     : absents[index].status == 1
    //                                         ? "Đã Duyệt"
    //                                         : "Trạng Thái Không Hợp Lệ",
    //                             style: TextStyle(
    //                               color: absents[index].status == -1
    //                                   ? Colors.red
    //                                   : absents[index].status == 0
    //                                       ? Colors.yellow
    //                                       : absents[index].status == 1
    //                                           ? Colors.green
    //                                           : Colors.black,
    //                             ),
    //                           ),
    //                         ),
    //                       ).onInkTap(() async {
    //                         if (absents[index].status == 1) {
    //                           ScaffoldMessenger.of(context).showSnackBar(
    //                             SnackBar(
    //                               content: Text("Đã duyệt. Không thể chỉnh sửa!"),
    //                             ),
    //                           );
    //                           return;
    //                         }
    //                         final updatedAbsent = await Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) => InfoAbsentScreen(
    //                               absents: absents[index],
    //                             ),
    //                           ),
    //                         );

    //                         // Kiểm tra xem có dữ liệu cập nhật không
    //                         if (updatedAbsent != null) {
    //                           _handleUpdate(updatedAbsent);
    //                         }
    //                       });
    //                     },
    //                   );
    //                 }
    //               },
    //             ),

    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: true,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      appBarColor: AppColor.primaryLightColor,
      titletext: "Nghỉ phép",
      bodyChildren: [
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // TabBar
                Container(
                  color: AppColor.primaryLightColor,
                  child: TabBar(
                    // indicatorColor: AppColor.primaryColor,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "Đợi Duyệt"),
                      Tab(text: "Đã Duyệt"),
                      Tab(text: "Từ Chối"),
                    ],
                  ),
                ),
                // TabBarView
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tab "Đợi Duyệt"
                      _buildAbsentList(context, 0),
                      // Tab "Đã Duyệt"
                      _buildAbsentList(context, 1),
                      // Tab "Từ Chối"
                      _buildAbsentList(context, -1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // // Hàm tạo danh sách theo trạng thái
  // Widget _buildAbsentList(BuildContext context, int status) {
  //   return Consumer<AbsentsViewModel>(
  //     builder: (context, viewModel, child) {
  //       // Tải dữ liệu nếu cần
  //       if (!viewModel.fetchingData && viewModel.listAbsents.isEmpty) {
  //         Provider.of<AbsentsViewModel>(context, listen: false)
  //             .fetchAllAbsents();
  //       }

  //       // Hiển thị trạng thái đang tải
  //       if (viewModel.fetchingData) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       // Lọc danh sách theo trạng thái
  //       List<Absents> filteredAbsents = viewModel.listAbsents
  //           .where((absent) => absent.status == status)
  //           .toList();

  //       // Kiểm tra danh sách rỗng
  //       if (filteredAbsents.isEmpty) {
  //         return const Center(
  //           child: Text("Không có đơn nghỉ ở trạng thái này."),
  //         );
  //       }

  //       // Danh sách các đơn nghỉ việc
  //       return ListView.builder(
  //         itemCount: filteredAbsents.length,
  //         itemBuilder: (context, index) {
  //           final absent = filteredAbsents[index];
  //           return Card(
  //             child: ListTile(
  //               title: Text("${absent.profileID}"),
  //               subtitle: Text(
  //                 status == -1
  //                     ? "Từ Chối Duyệt"
  //                     : status == 0
  //                         ? "Đợi Duyệt"
  //                         : "Đã Duyệt",
  //                 style: TextStyle(
  //                   color: status == -1
  //                       ? Colors.red
  //                       : status == 0
  //                           ? Colors.yellow
  //                           : Colors.green,
  //                 ),
  //               ),
  //             ),
  //           ).onInkTap(() async {
  //             if (status == 1) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                     content: Text("Đã duyệt. Không thể chỉnh sửa!")),
  //               );
  //               return;
  //             }
  //             final updatedAbsent = await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => InfoAbsentScreen(
  //                   absents: absent,
  //                   profile: widget.profiles,
  //                 ),
  //               ),
  //             );
  //             if (updatedAbsent != null) {
  //               _handleUpdate(updatedAbsent);
  //             }
  //           });
  //         },
  //       );
  //     },
  //   );
  // }
   // // Hàm tạo danh sách theo trạng thái
  Widget _buildAbsentList(BuildContext context, int status) {
    return Consumer<AbsentsViewModel>(
      builder: (context, viewModel, child) {
        // Tải dữ liệu nếu cần
        if (!viewModel.fetchingData && viewModel.listAbsents.isEmpty) {
          Provider.of<AbsentsViewModel>(context, listen: false)
              .getAllAbsentsbyRole(widget.profiles!.profileId);
        }

        // Hiển thị trạng thái đang tải
        if (viewModel.fetchingData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Lọc danh sách theo trạng thái
        List<Absents> filteredAbsents = viewModel.listAbsents
            .where((absent) => absent.status == status)
            .toList();

        // Kiểm tra danh sách rỗng
        if (filteredAbsents.isEmpty) {
          return const Center(
            child: Text("Không có đơn nghỉ ở trạng thái này."),
          );
        }

        // Danh sách các đơn nghỉ việc
        return ListView.builder(
          itemCount: filteredAbsents.length,
          itemBuilder: (context, index) {
            final absent = filteredAbsents[index];
            return Card(
              child: ListTile(
                title: Text("${absent.profileID}"),
                subtitle: Text(
                  status == -1
                      ? "Từ Chối Duyệt"
                      : status == 0
                          ? "Đợi Duyệt"
                          : "Đã Duyệt",
                  style: TextStyle(
                    color: status == -1
                        ? Colors.red
                        : status == 0
                            ? Colors.yellow
                            : Colors.green,
                  ),
                ),
              ),
            ).onInkTap(() async {
              if (status == 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Đã duyệt. Không thể chỉnh sửa!")),
                );
                return;
              }
              final updatedAbsent = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoAbsentScreen(
                    absents: absent,
                    profile: widget.profiles,
                  ),
                ),
              );
              if (updatedAbsent != null) {
                _handleUpdate(updatedAbsent);
              }
            });
          },
        );
      },
    );
  }

}
