import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/api_services/profile_service.dart';
import 'package:nloffice_hrm/api_services/salary_service.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_salari_sceen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/views/screen/payslipscreen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SalaryListScreen extends StatefulWidget {
  final Profiles? profiles;
  const SalaryListScreen({super.key, this.profiles});
  @override
  _SalaryListScreenState createState() => _SalaryListScreenState();
}

class _SalaryListScreenState extends State<SalaryListScreen> {
  List<Salaries> salaries = [];
  List<Salaries> filteredsalaries = [];
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
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      titletext: "List Salary Screen".tr(),
      bodyChildren: [
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
        Expanded(
          child: Consumer<SalariesViewModel>(
            builder: (context, viewModel, child) {
              if (!viewModel.fetchingData && viewModel.listSalaries.isEmpty) {
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
                            "${salaris[index].salaryId} - ${salaris[index].allowances} "),
                        subtitle: Text(
                            "Tên Nhân Viên: ${salaris[index].personalTax} - ${widget.profiles!.profileName}"),
                      ).onInkTap(
                        () async {
                          // Gọi màn hình thông tin chức vụ và chờ kết quả
                          final updatedSalary = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InfoSalariScreen(salaries: salaris[index]),
                            ),
                          );
                          // Kiểm tra xem có dữ liệu cập nhật không
                          if (updatedSalary != null) {
                            _handleUpdate(updatedSalary);
                          }
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
