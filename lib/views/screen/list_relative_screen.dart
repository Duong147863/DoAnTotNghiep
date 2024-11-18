import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_relative_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class RelativeListScreen extends StatefulWidget {
  final Profiles? profiles;
  const RelativeListScreen({super.key, this.profiles});
  @override
  _RelativeListScreenState createState() => _RelativeListScreenState();
}

class _RelativeListScreenState extends State<RelativeListScreen> {
  List<Relatives> relatives = [];
  List<Relatives> filteredRelatives = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchData();
  // }

  // Future<void> _fetchData() async {
  //   try {
  //     // List<Profiles> fetchedProfiles = await fetchProfile();
  //     // List<Relatives> fetchedRelatives = await fetchRelatives();
  //     // setState(() {
  //     //   profiles = fetchedProfiles;
  //     //   relatives = fetchedRelatives;
  //     //   filteredProfiles = fetchedProfiles;
  //     // });
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //   }
  // }

  void _handleUpdate(Relatives updatedRelative) {
    setState(() {
      int index = relatives
          .indexWhere((rela) => rela.profileId == updatedRelative.profileId);
      if (index != -1) {
        relatives[index] = updatedRelative;
      }
    });
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRelatives = relatives; // Show all absents if query is empty
      } else {
        filteredRelatives = relatives.where((relative) {
          return relative.profileId!
              .toLowerCase()
              .contains(query.toLowerCase()); // Filter based on reason
        }).toList();
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
      appBarColor: AppColor.primaryLightColor,
      titletext: "Thân nhân nhân viên".tr(),
      bodyChildren: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            suggestions: relatives
                .map(
                  (relative) => relative.profileId,
                )
                .toList(),
            onTextChanged: _handleSearch,
            hintText: '',
          ),
        ),
        Expanded(
          child: Consumer<RelativesViewModel>(
            builder: (context, viewModel, child) {
              if (!viewModel.fetchingData && viewModel.listRelatives.isEmpty) {
                Provider.of<RelativesViewModel>(context, listen: false)
                    .fetchAllRelatives(widget.profiles!.profileId);
              }
              if (viewModel.fetchingData) {
                return Center(child: CircularProgressIndicator());
              } else {
                // If data is fetched, display it
                List<Relatives> relatives = viewModel.listRelatives;
                return CustomListView(
                  dataSet: relatives,
                  itemBuilder: (context, index) {
                    return CustomCard(
                      title: Text(
                        "${relatives[index].profileId}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subttile: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Tên Thân Nhân: ${relatives[index].relativesName}"),
                          Text("Quan hệ: ${relatives[index].relationship}"),
                          Text("Liên hệ: ${relatives[index].relativesPhone}"),
                        ],
                      ),
                    ).p8().onInkTap(
                      () async {
                        // Gọi màn hình thông tin chức vụ và chờ kết quả
                        final updatedPosition = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InfoRelativeScreen(profile: relatives[index]),
                          ),
                        );

                        // Kiểm tra xem có dữ liệu cập nhật không
                        if (updatedPosition != null) {
                          _handleUpdate(updatedPosition);
                        }
                      },
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
