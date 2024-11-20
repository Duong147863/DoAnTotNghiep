import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/hirings_model.dart';
import 'package:nloffice_hrm/view_models/hirings_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
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
  @override
  void initState() {
    super.initState();
    Provider.of<HiringsViewModel>(context, listen: false).getAllHirings();
  }

  final List<Hirings> hirings = [];
  List<Hirings> filteredHirings = [];
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredHirings = hirings;
      } else {
        filteredHirings = hirings.where((hir) {
          return hir.profileName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
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
                "Quản lý tuyển dụng",
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
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            hintText: '',
            suggestions: hirings.map((hir) => hir.profileName).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: Consumer<HiringsViewModel>(
            builder: (context, viewModel, child) {
              if (!viewModel.fetchingData && viewModel.listHirigns.isEmpty) {
                Provider.of<HiringsViewModel>(context, listen: false)
                    .getAllHirings();
              }
              if (viewModel.fetchingData) {
                return Center(child: CircularProgressIndicator());
              } else {
                // If data is fetched, display it
                List<Hirings> hiring = viewModel.listHirigns;
                return CustomListView(
                  dataSet: hiring,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                            "Tên ứng cử viên: ${hiring[index].profileName} - Ngày sinh: ${DateFormat('dd/MM/yyyy').format(hiring[index].birthday).toString()}"),
                        subtitle: Text(
                          hiring[index].hiringStatus == -1
                              ? "Lưu Trữ"
                              : hiring[index].hiringStatus == 0
                                  ? "Đợi Lọc"
                                  : hiring[index].hiringStatus == 1
                                      ? "Đã Liên Hệ"
                                      : hiring[index].hiringStatus == 2
                                          ? "Đã Phỏng Vấn"
                                          : "Trạng Thái Không Hợp Lệ",
                          style: TextStyle(
                            color: hiring[index].hiringStatus == -1
                                ? Colors.red
                                : hiring[index].hiringStatus == 0
                                    ? Colors.yellow
                                    : hiring[index].hiringStatus == 1
                                        ? Colors.green
                                        : hiring[index].hiringStatus == 2
                                            ? const Color.fromARGB(
                                                255, 20, 34, 158)
                                            : Colors.black,
                          ),
                        ),
                      ).onInkTap(
                        () async {
                        
                          final updatedHirings = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoHiringsScreen(
                                hirings: hiring[index],
                              ),
                            ),
                          );
                          // Kiểm tra xem có dữ liệu cập nhật không
                          if (updatedHirings != null) {
                            _handleUpdate(updatedHirings);
                          }
                        },
                      ),
                    ).py1().px4();
                  },
                );
              }
            },
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
        child: Icon(Icons.add),
      ),
    );
  }
}
