import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: true,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      appBarColor: AppColor.primaryLightColor,
      titletext: "Nghỉ phép",
      bodyChildren: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            suggestions: absents
                .map(
                  (absent) => absent.profileID,
                )
                .toList(),
            onTextChanged: _handleSearch,
            hintText: '',
          ),
        ),
        Expanded(
          child: Consumer<AbsentsViewModel>(
            builder: (context, viewModel, child) {
              // Fetch data if not already loaded
              if (!viewModel.fetchingData && viewModel.listAbsents.isEmpty) {
                Provider.of<AbsentsViewModel>(context, listen: false)
                    .fetchAllAbsents();
              }
              // Show loading indicator while fetching data
              if (viewModel.fetchingData) {
                return Center(child: CircularProgressIndicator());
              } else {
                // If data is fetched, display it
                List<Absents> absents = viewModel.listAbsents;
                return CustomListView(
                  dataSet: absents,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          Text(
                              "Từ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(absents[index].from.toLocal())} - đến ${MaterialLocalizations.of(context).formatMediumDate(absents[index].from)} ")
                        ],
                      ),
                    ).p8();
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
