import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
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
  FocusNode _passwordOldFocusNode = FocusNode();
  FocusNode _newPasswordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _passwordVisible = false;
    bool _passwordVisible1 = false;
      bool _passwordVisible2 = false;
  @override
  void initState() {
    super.initState();

    // Focus
    _newPasswordFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_newPasswordFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _passwordOldFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_passwordOldFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _confirmPasswordFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_confirmPasswordFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    // Hủy các focus node và controller
    _passwordOldFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<ProfilesViewModel>(context, listen: false);

      await viewModel.changePassword(
        widget.profiles!.profileId, // ID nhân viên
        _oldPasswordController.text, // Mật khẩu cũ
        _newPasswordController.text, // Mật khẩu mới
        _confirmPasswordController.text, // Xác nhận mật khẩu mới
        (message) {
          // Callback để xử lý kết quả trả về
          if (message == 'Mật khẩu mới đã được cập nhật thành công.') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            viewModel.logOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.loginRoute, (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
      );
    }
  }

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
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/password.png",
                          width: 250,
                          height: 250,
                        ),
                      ).p4(),
                      CustomTextFormField(
                        maxLength: 15,
                        focusNode: _passwordOldFocusNode,
                         textEditingController: _oldPasswordController,
                        obscureText: !_passwordVisible,
                       
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        labelText: 'Mật khẩu hiện tại',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu hiện tại';
                          }
                          return null;
                        },
                      ).p8(),
                      CustomTextFormField(
                        maxLength: 15,
                        focusNode: _newPasswordFocusNode,
                        textEditingController: _newPasswordController,
                         obscureText: !_passwordVisible1,
                       
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible1
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible1 = !_passwordVisible1;
                            });
                          },
                        ),
                        labelText: 'Mật khẩu mới',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống';
                          }
                          if (value.length < 8 || value.length > 15) {
                            return 'Mật khẩu phải từ 8 đến 15 ký tự';
                          }
                          if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,15}$')
                              .hasMatch(value)) {
                            return 'Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt';
                          }
                          return null;
                        },
                      ).p8(),
                      CustomTextFormField(
                        maxLength: 15,
                        focusNode: _confirmPasswordFocusNode,
                        textEditingController: _confirmPasswordController,
                         obscureText: !_passwordVisible2,
                       
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible2 = !_passwordVisible2;
                            });
                          },
                        ),
                        labelText: 'Xác nhận mật khẩu mới',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Mật khẩu xác nhận không khớp';
                          }
                          return null;
                        },
                      ).p8(),
                      viewModel.isChangingPassword
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _updatePassword,
                              child: Text('Đổi mật khẩu'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primaryLightColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                minimumSize: Size(double.infinity, 44),
                              ),
                            ),
                    ],
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
