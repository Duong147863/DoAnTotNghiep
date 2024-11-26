import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:provider/provider.dart'; // Để sử dụng ChangeNotifierProvider

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
            titletext: 'Đổi mật khẩu',
            showLeadingAction: true,
            appBarItemColor: AppColor.offWhite,
            appBarColor: AppColor.primaryLightColor,
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/password.png",
                        width: 300,
                        height: 300,
                      ),
                    ),
                    CustomTextFormField(
                      textEditingController: _oldPasswordController,
                      labelText: 'Mật khẩu hiện tại',
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
                      labelText: 'Mật khẩu mới',
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
                      labelText: 'Nhập lại mật khẩu mới',
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
                    viewModel.isChangingPassword
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                child: Text("Thay đổi"),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Xác nhận'),
                                          content: Text(
                                              'Bạn có chắc chắn muốn đổi mật khẩu?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Huỷ'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await viewModel.changePassword(
                                                  widget.profiles?.profileId
                                                          .toString() ??
                                                      '',
                                                  _oldPasswordController.text,
                                                  _newPasswordController.text,
                                                  _confirmPasswordController
                                                      .text,
                                                );
                                                if (!viewModel
                                                    .isChangingPassword) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Password changed successfully')));
                                                  Navigator.of(context)
                                                      .pop(); // Quay lại trang trước
                                                }
                                              },
                                              child: Text('Lưu'),
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
          );
        },
      ),
    );
  }
}
