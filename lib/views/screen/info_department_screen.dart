import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/projects_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/profile_screen.dart';
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
  List<Profiles> profile = [];
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
        // Navigator.pop(context, updatedDeparment);
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

  void _handleUpdateProfile(Profiles updatedProfile) {
    setState(() {
      int index = profile
          .indexWhere((pro) => pro.profileId == updatedProfile.profileId);
      if (index != -1) {
        profile[index] = updatedProfile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_departmentIDController.text);
    print(_departmentNameController.text);
    return BasePage(
      showAppBar: true,
      titletext: widget.departments!.departmentName,
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
      appBarColor: AppColor.primaryLightColor,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomTextFormField(
                  textEditingController: _departmentIDController,
                  labelText: 'Mã Phòng ban',
                  enabled: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mã phòng ban';
                    }
                    return null;
                  },
                ).w(150).p4(),
                CustomTextFormField(
                  textEditingController: _departmentNameController,
                  labelText: 'Tên phòng ban',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên phòng';
                    }
                    final nameRegex = RegExp(
                        r"^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàảạáâãèéêìíòóôõùúủũuụĂĐĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặÈÉẺẼẸÊềếểễnệjiíìỉĩịÒÓỎÕỌôỒỐỔỖỘơỜỚỞỠỢÙÚỦŨỤƯưừứửữựýỳỷỹỵạọấầẩẫậ\s]+$");
                    if (!nameRegex.hasMatch(value)) {
                      return 'Tên phòng ban không được chứa chữ số và ký tự đặc biệt';
                    }
                    if (!value.isLetter()) {
                      return 'Tên phòng ban chỉ gồm chữ';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ).w(245).p4(),
              ],
            ),
            Consumer<ProfilesViewModel>(builder: (context, viewModel, child) {
              if (!viewModel.fetchingData &&
                  viewModel.listMembersOfDepartment.isEmpty) {
                Provider.of<ProfilesViewModel>(context, listen: false)
                    .membersOfDepartment(widget.departments!.departmentID);
              }
              if (viewModel.fetchingData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List<Profiles> listMembers = viewModel.listMembersOfDepartment;
                return CustomListView(
                    dataSet: listMembers,
                    itemBuilder: (context, index) {
                      return CustomCard(
                          title: Row(
                            children: [
                              CircleAvatar().px8(),
                              Text(
                                "${listMembers[index].profileId} - ${listMembers[index].profileName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subttile: Container(
                            child: Column(
                              children: [],
                            ),
                          )).p8().onTap(() async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(profile: listMembers[index]),
                          ),
                        ).then((updatedProfile) {
                          if (updatedProfile != null) {
                            _handleUpdateProfile(
                                updatedProfile); // Cập nhật lại thông tin
                          }
                        });
                      });
                    });
              }
            }),
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
    );
  }
}
