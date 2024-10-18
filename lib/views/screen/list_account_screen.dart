import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:provider/provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  // late Future<Accounts> futureAccount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        showAppBar: true,
        showLeadingAction: true,
        defaultBody: true,
        appBarItemColor: AppColor.boneWhite,
        // title: "Accounts List",
        backgroundColor: AppColor.primaryLightColor,
        bodyChildren: [
          // Consumer<AccountsViewModel>(builder: (context, viewModel, child) {
          //   if (!viewModel.fetchingData && viewModel.listAccounts.isEmpty) {
          //     // Provider.of<AccountsViewModel>(context, listen: false)
          //     //     .fetchAdminAccounts();
          //   }
          //   if (viewModel.fetchingData) {
          //     // While data is being fetched
          //     return CircularProgressIndicator();
          //   } else {
          //     // If data is successfully fetched
          //     List<Accounts> accounts = viewModel.listAccounts;
          //     return CustomListView(
          //       dataSet: accounts,
          //       itemBuilder: (context, index) {
          //         return ListTile(
          //           title: Text(accounts[index].email_or_phone.toString()),
          //           onTap: () {
          //             Navigator.pushNamed(context, AppRoutes.profileRoute);
          //           },
          //         );
          //       },
          //     );
          //   }
          // }),
        ]);
  }
}
