import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:provider/provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen ({super.key});

  @override
  State<EmployeeListScreen>createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen > {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      bodyChildren: [
        Consumer<ProfilesViewModel>(builder: (context, viewModel,
          child) {
            if (!viewModel.fetchingData && viewModel.listProfiles.isEmpty) {
              // Provider.of<ProfilesViewModel>(context, listen: false)
              //     .fetchAdminAccounts();
            }
            if (viewModel.fetchingData) {
              // While data is being fetched
              return CircularProgressIndicator();
            } else {
              // If data is successfully fetched
              List<Profiles> accounts = viewModel.listProfiles;
              return CustomListView(
                dataSet: accounts,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(accounts[index].email.toString()),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profileRoute);
                    },
                  );
                },
              );
            }
          })]
    );
  }
}




