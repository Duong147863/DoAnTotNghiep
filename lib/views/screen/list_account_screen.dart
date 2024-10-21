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
                "Employee Management",
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMenuItem('Add Employee', Icons.add_circle_outline),
            SizedBox(height: 16.0),
            _buildMenuItem('Time Attendance', Icons.access_time),
            SizedBox(height: 16.0),
            _buildMenuItem('Leave Management', Icons.calendar_today),
            SizedBox(height: 16.0),
            _buildMenuItem('Employees Overtime', Icons.access_time),
            SizedBox(height: 16.0),
            _buildMenuItem('Salary Statement', Icons.attach_money),
            SizedBox(height: 16.0),
            _buildMenuItem('Reference', Icons.folder),
          ],
        ),
      ),
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
        ]
        );
  }
  Widget _buildMenuItem(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
