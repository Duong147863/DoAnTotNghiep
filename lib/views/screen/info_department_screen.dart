import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class DepartmentInfoScreen extends StatefulWidget {
  final Departments? departments;

  DepartmentInfoScreen({super.key, this.departments});

  @override
  _DepartmentInfoScreenState createState() => _DepartmentInfoScreenState();
}

class _DepartmentInfoScreenState extends State<DepartmentInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _departmentIDController = TextEditingController();
  final _departmentNameController = TextEditingController();
  bool _isEditing = false;
  void initState() {
    super.initState();
    _departmentIDController.text = widget.departments!.departmentID;
    _departmentNameController.text = widget.departments!.departmentName;
    Provider.of<ProfilesViewModel>(context, listen: false)
        .membersOfDepartment(widget.departments!.departmentID);
  }

  void _updateDepartment() async {
    if (_formKey.currentState!.validate()) {
      final updatedDeparment = Departments(
          departmentID: _departmentIDController.text,
          departmentName: _departmentNameController.text);
      try {
        await Provider.of<DeparmentsViewModel>(context, listen: false)
            .updateDepartment(updatedDeparment);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department Updated successfully!')),
        );
        Navigator.pop(context, updatedDeparment);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Department: $e')),
        );
      }
    }
  }

  void _deleteDepartment() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .deleteDepartment(widget.departments!.departmentID);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Department deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete position: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: widget.departments!.departmentName,
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  textEditingController: _departmentIDController,
                  labelText: 'Mã Phòng ban',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mã phòng ban';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ).px8(),
                SizedBox(height: 16),
                CustomTextFormField(
                  textEditingController: _departmentNameController,
                  labelText: 'Tên',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên phòng ban';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ).px8(),
                // Consumer<ProfilesViewModel>(
                //     builder: (context, viewModel, child) {
                //   // if (!viewModel.fetchingData &&
                //   //     viewModel.listMembersOfDepartment.isEmpty) {
                //   // Provider.of<ProfilesViewModel>(context, listen: false)
                //   //     .membersOfDepartment(widget.departments!.departmentID);
                //   // }
                //   // if (viewModel.fetchingData) {
                //   //   // While data is being fetched
                //   //   return Center(child: CircularProgressIndicator());
                //   // } else {
                //   // If data is successfully fetched
                //   List<Profiles> profiles = viewModel.listMembersOfDepartment;
                //   return CustomListView(
                //       dataSet: profiles,
                //       itemBuilder: (context, index) {
                //         return ListTile(
                //           leading: CircleAvatar(),
                //           title: Text(profiles[index].profileName),
                //         );
                //       });
                //   // }
                // }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<ProfilesViewModel>(
                        builder: (context, viewModel, child) {
                      if (!viewModel.fetchingData &&
                          viewModel.listMembersOfDepartment.isEmpty) {
                        Provider.of<ProfilesViewModel>(context, listen: false)
                            .membersOfDepartment(
                                widget.departments!.departmentID);
                      }
                      if (viewModel.fetchingData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        // Thêm trạng thái mở rộng cho các panel
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tổng thành viên: ${viewModel.totalMembers}'),
                            SingleChildScrollView(
                              child: ExpansionPanelList.radio(
                                expandedHeaderPadding: EdgeInsets.all(8),
                                elevation: 1,
                                children: viewModel.membersDepartment
                                    .map<ExpansionPanelRadio>((profile) =>
                                        ExpansionPanelRadio(
                                          value: profile.profileId,
                                          headerBuilder: (context, isExpanded) {
                                            return Text("Thông tin nhân viên");
                                          },
                                          body: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'ID: ${profile.profileId}'),
                                                Text(
                                                    'Tên: ${profile.profileName}'),
                                        
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.save,
                          color: const Color.fromARGB(255, 33, 243, 61)),
                      onPressed: _updateDepartment,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: _deleteDepartment,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
