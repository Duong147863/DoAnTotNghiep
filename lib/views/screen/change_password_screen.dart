import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:provider/provider.dart';  // Để sử dụng ChangeNotifierProvider

class ChangePasswordScreen extends StatefulWidget {
  final Profiles? profiles;
  const ChangePasswordScreen({super.key, this.profiles});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfilesViewModel(),
      child: Consumer<ProfilesViewModel>(
        builder: (context, viewModel, child) {
          return BasePage(
            showAppBar: true,
            titletext: 'Change Password',
            showLeadingAction: true,
            appBarItemColor: AppColor.offWhite,
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          textEditingController: _oldPasswordController,
                          labelText: 'Old Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your old password';
                            }
                            return null;
                          },
                        ).px8(),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          textEditingController: _newPasswordController,
                          labelText: 'New Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            return null;
                          },
                        ).px8(),
                        SizedBox(height: 16),
                        CustomTextFormField(
                          textEditingController: _confirmPasswordController,
                          labelText: 'Confirm New Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ).px8(),
                        Spacer(),
                        viewModel.isChangingPassword
                            ? Center(child: CircularProgressIndicator()) 
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.save, color: const Color.fromARGB(255, 54, 244, 95)),
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirm Change'),
                                              content: Text('Are you sure you want to change your password?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    await viewModel.changePassword(
                                                      widget.profiles?.profileId.toString() ?? '',
                                                      _oldPasswordController.text,
                                                      _newPasswordController.text,
                                                      _confirmPasswordController.text,
                                                    );
                                                    if (!viewModel.isChangingPassword) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Password changed successfully')));
                                                      Navigator.of(context).pop();  // Quay lại trang trước
                                                    }
                                                  },
                                                  child: Text('Change'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
