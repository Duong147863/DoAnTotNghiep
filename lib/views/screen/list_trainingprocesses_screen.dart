import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';
import 'package:nloffice_hrm/view_models/trainingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_trainingprocesses_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
class ListTrainingprocessesScreen extends StatefulWidget {
  final Profiles? profiles;
  const ListTrainingprocessesScreen({super.key,this.profiles});

  @override
  State<ListTrainingprocessesScreen> createState() => _ListTrainingprocessesScreenState();
}

class _ListTrainingprocessesScreenState extends State<ListTrainingprocessesScreen> {
  List<Trainingprocesses> trainingprocesses = [];
  List<Trainingprocesses> filteredTrainingprocesses = [];
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTrainingprocesses = trainingprocesses;
      } else {
        filteredTrainingprocesses = trainingprocesses.where((tra) {
          return tra.trainingprocessesName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _handleUpdate(Trainingprocesses updatedTrainingprocesses) {
    setState(() {
      int index = trainingprocesses.indexWhere(
          (tra) => tra.trainingprocessesId == updatedTrainingprocesses.trainingprocessesId);
      if (index != -1) {
        trainingprocesses[index] = updatedTrainingprocesses;
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
                "List TrainningProcesses Screen",
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
            suggestions: trainingprocesses.map((tra) => tra.profileId).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: Consumer<TrainingprocessesViewModel>(
              builder: (context, viewModel, child) {
            if (!viewModel.fetchingData &&
                viewModel.listTrainingprocesses.isEmpty) {
              Provider.of<TrainingprocessesViewModel>(context, listen: false)
                  .getTrainingProcessesOf(widget.profiles!.profileId);
            }
            if (viewModel.fetchingData) {
              // While data is being fetched
              return Center(child: CircularProgressIndicator());
            } else {
              // If data is successfully fetched
              List<Trainingprocesses> trainingPro =
                  viewModel.listTrainingprocesses;
              return CustomListView(
                dataSet: trainingPro,
                itemBuilder: (context, index) {
                 return Card(
                    child: ListTile(
                      title: Text(
                          "${trainingPro[index].profileId} - ${trainingPro[index].trainingprocessesId}"),
                      subtitle: Text(
                        trainingPro[index].trainingprocessesStatus == -1
                            ? "Từ Chối Duyệt"
                            : trainingPro[index].trainingprocessesStatus == 0
                                ? "Đợi Duyệt"
                                : trainingPro[index].trainingprocessesStatus ==
                                        1
                                    ? "Đã Duyệt"
                                    : "Trạng Thái Không Hợp Lệ",
                        style: TextStyle(
                          color: trainingPro[index].trainingprocessesStatus ==
                                  -1
                              ? Colors.red
                              : trainingPro[index].trainingprocessesStatus == 0
                                  ? Colors.yellow
                                  : trainingPro[index]
                                              .trainingprocessesStatus ==
                                          1
                                      ? Colors.green
                                      : Colors
                                          .black,
                        ),
                      ),
                    ),
                  ).onInkTap(
                    () async {
                      if (trainingPro[index].trainingprocessesStatus == 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Đã duyệt. Không thể chỉnh sửa!")),
                        );
                        return; 
                      }
                      final updatedWorkingProcesses = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoTrainingprocessesScreen(
                            trainingprocesses: trainingPro[index],
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