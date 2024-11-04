import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class DepartmentInfoScreen extends StatelessWidget {
  final Departments? departments;
  DepartmentInfoScreen({super.key, this.departments});
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'department_info'.tr(),
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Department members list
                Consumer<ProfilesViewModel>(
                    builder: (context, viewModel, child) {
                  if (!viewModel.fetchingData &&
                      viewModel.listMembersOfDepartment.isEmpty) {
                    Provider.of<ProfilesViewModel>(context, listen: false)
                        .membersOfDepartment(departments!.departmentID);
                  }
                  if (viewModel.fetchingData) {
                    // While data is being fetched
                    return Center(child: CircularProgressIndicator());
                  } else {
                    // If data is successfully fetched
                    List<Profiles> members = viewModel.listMembersOfDepartment;
                    return CustomListView(
                      dataSet: members,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(members[index].profileName!),
                          leading: Text(members[index].profileId!),
                          onTap: () {},
                        );
                      },
                    );
                  }
                }),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           EditDepartmentScreen(department: department),
                    //     ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
