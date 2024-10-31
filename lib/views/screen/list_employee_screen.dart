import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:provider/provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      titletext: "your_employees".tr(),
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: true,
      backgroundColor: AppColor.primaryLightColor,
      bodyChildren: [
        Consumer<ProfilesViewModel>(builder: (context, viewModel, child) {
          if (!viewModel.fetchingData && viewModel.listProfiles.isEmpty) {
            Provider.of<ProfilesViewModel>(context, listen: false)
                .fetchAllProfiles();
          }
          if (viewModel.fetchingData) {
            // While data is being fetched
            return Center(child: CircularProgressIndicator());
          } else {
            // If data is successfully fetched
            List<Profiles> profiles = viewModel.listProfiles;
            return CustomListView(
              dataSet: profiles,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(profiles[index].profileName),
                  leading: CircleAvatar(),
                  onTap: () {},
                );
              },
            );
          }
        }),
      ],
      fab: SpeedDial(
        
      ),
    );
  }
}
