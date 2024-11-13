import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/view_models/workingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_labor_contract_screen.dart';
import 'package:nloffice_hrm/views/screen/info_workingprocesses_emloyee_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ListWorkingprocessEmloyeeScreen extends StatefulWidget {
  final Profiles? profiles;
  const ListWorkingprocessEmloyeeScreen({super.key, this.profiles});

  @override
  State<ListWorkingprocessEmloyeeScreen> createState() =>
      _ListWorkingprocessEmloyeeScreenState();
}

class _ListWorkingprocessEmloyeeScreenState extends State<ListWorkingprocessEmloyeeScreen> {
  List<WorkingProcesses> workingProcesses = [];
  List<WorkingProcesses> filteredworkingProcesses = [];
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredworkingProcesses = workingProcesses;
      } else {
        filteredworkingProcesses = workingProcesses.where((wro) {
          return wro.workplaceName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _handleUpdate(WorkingProcesses updatedWorkingProcesses) {
    setState(() {
      int index = workingProcesses.indexWhere(
          (wor) => wor.profileId == updatedWorkingProcesses.profileId);
      if (index != -1) {
        workingProcesses[index] = updatedWorkingProcesses;
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
                "List WorkingProcess Screen",
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
            hintText: 'Name',
            suggestions: workingProcesses.map((wor) => wor.profileId).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: Consumer<WorkingprocessesViewModel>(
              builder: (context, viewModel, child) {
            if (!viewModel.fetchingData &&
                viewModel.listWorkingProcess.isEmpty) {
              Provider.of<WorkingprocessesViewModel>(context, listen: false)
                  .fetchWorkingProcess(widget.profiles!.profileId);
            }
            if (viewModel.fetchingData) {
              // While data is being fetched
              return Center(child: CircularProgressIndicator());
            } else {
              // If data is successfully fetched
              List<WorkingProcesses> workingProcesses =
                  viewModel.listWorkingProcess;
              return CustomListView(
                dataSet: workingProcesses,
                itemBuilder: (context, index) {
                  return CustomCard(
                    title:
                        "${workingProcesses[index].profileId} - ${workingProcesses[index].workingprocessId}",
                    subttile: workingProcesses[index].workingprocessStatus == -1
                        ? "Từ Chối Duyệt"
                        : workingProcesses[index].workingprocessStatus == 0
                            ? "Đợi Duyệt"
                            : workingProcesses[index].workingprocessStatus == 1
                                ? "Đã Duyệt"
                                : "Trạng Thái Không Hợp Lệ",
                    subttile1: workingProcesses[index].workingprocessStatus ==
                            -1
                        ? "Từ Chối Duyệt"
                        : workingProcesses[index].workingprocessStatus == 0
                            ? "Đợi Duyệt"
                            : workingProcesses[index].workingprocessStatus == 1
                                ? "Đã Duyệt"
                                : "Trạng Thái Không Hợp Lệ",
                  ).onInkTap(
                    () async {
                      if (workingProcesses[index].workingprocessStatus == 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Đã duyệt. Không thể chỉnh sửa!")),
                        );
                        return; 
                      }
                      final updatedWorkingProcesses = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoWorkingprocessesEmloyeeScreen(
                            workingProcesses: workingProcesses[index],
                          ),
                        ),
                      );

                      // Kiểm tra xem có dữ liệu cập nhật không
                      if (updatedWorkingProcesses != null) {
                        _handleUpdate(updatedWorkingProcesses);
                      }
                    },
                  );
                },
              );
            }
          }),
        ),
      ],
    );
  }
}
