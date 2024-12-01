import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_salary_screen.dart';
import 'package:nloffice_hrm/views/screen/info_salari_sceen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SalaryListScreen extends StatefulWidget {
  final Profiles? profiles;
  const SalaryListScreen({super.key, this.profiles});
  @override
  _SalaryListScreenState createState() => _SalaryListScreenState();
}

class _SalaryListScreenState extends State<SalaryListScreen>
    with SingleTickerProviderStateMixin {
  List<Salaries> salaries = [];
  List<Salaries> filteredsalaries = [];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void _handleUpdate(Salaries updatedSalary) {
    setState(() {
      int index =
          salaries.indexWhere((sal) => sal.salaryId == updatedSalary.salaryId);
      if (index != -1) {
        salaries[index] = updatedSalary;
      }
    });
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredsalaries = salaries; // Show all absents if query is empty
      } else {
        filteredsalaries = salaries.where((sal) {
          return sal.salaryId
              .toLowerCase()
              .contains(query.toLowerCase()); // Filter based on reason
        }).toList();
      }
    });
  }

  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: true,
      titletext: "Quản lí lương",
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      appBarColor: AppColor.primaryLightColor,
      bodyChildren: [
        TabBar(
          controller: _tabController,
          // indicatorColor: Color(0xFF0B258A), // Màu cho đường viền của tab
          labelColor: Colors.black, // Màu cho tab đang chọn
          tabs: [
            Tab(text: 'Lương cơ bản'),
            // Tab(text: 'Bảng lương tháng'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomSearchBar(
                      suggestions: salaries
                          .map(
                            (sal) => sal.salaryId,
                          )
                          .toList(),
                      onTextChanged: _handleSearch,
                      hintText: '',
                    ),
                  ),
                  Consumer<SalariesViewModel>(
                    builder: (context, viewModel, child) {
                      if (!viewModel.fetchingData &&
                          viewModel.listSalaries.isEmpty) {
                        Provider.of<SalariesViewModel>(context, listen: false)
                            .fetchAllSalaries();
                      }
                      if (viewModel.fetchingData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        // If data is fetched, display it
                        List<Salaries> salaris = viewModel.listSalaries;
                        return CustomListView(
                          dataSet: salaris,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                    "Mã lương: ${salaris[index].salaryId} - Mức lương: ${salaris[index].salaryCoefficient.toInt()} "),
                              ).onInkTap(
                                () async {
                                  // Gọi màn hình thông tin chức vụ và chờ kết quả
                                  final updatedSalary = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoSalariScreen(
                                          salaries: salaris[index]),
                                    ),
                                  );
                                  // Kiểm tra xem có dữ liệu cập nhật không
                                  if (updatedSalary != null) {
                                    _handleUpdate(updatedSalary);
                                  }
                                },
                              ),
                            ).py1().px4();
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              // CustomListView(
              //     dataSet: [],
              //     itemBuilder: (context, index) {
              //       return Placeholder();
              //     })
            ],
          ),
        )
      ],
      fab: SpeedDial(
        children: [
          SpeedDialChild(
              label: "Mức lương mới",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SalaryAddScreen(),
                    ));
              }),
        ],
      ),
    );
  }
}
