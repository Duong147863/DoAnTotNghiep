import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/shared_preferences.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_button.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _TapBarState();
}

class _TapBarState extends State<LoginScreen> {
  final emailOrPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  Profiles? userProfile;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final profilesViewModel =
        Provider.of<ProfilesViewModel>(context, listen: false);
    return BasePage(
      backgroundColor: AppColor.seaShell,
      showAppBar: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logos/black_logo.png",
              width: 100,
              height: 100,
            ),
            Image.asset(
              "assets/images/male_avatar.png",
              width: 300,
              height: 260,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //Email/ Phone number text field
                  CustomTextFormField(
                    textEditingController: emailOrPhoneController,
                    prefixIcon: const Icon(Icons.person),
                    labelText: "Email hoặc Số điện thoại",
                    fillColor: AppColor.primaryDarkColor,
                    filled: true,
                    validator: (value) {
                      if (value.isEmptyOrNull) {
                        return 'Vui lòng nhập email hoặc số điện thoại của bạn';
                      } else if (isEmail(value!) == false &&
                          SPUtill.isPhoneNumber(value) == false) {
                        return 'Vui lòng nhập email hoặc số điện thoại hợp lệ';
                      }
                      return null;
                    },
                  ).py(10),
                  CustomTextFormField(
                    textEditingController: passwordController,
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
                    labelText: "Mật khẩu",
                    filled: true,
                    validator: (value) {
                      if (value.isEmptyOrNull) {
                        return 'Vui lòng nhập mật khẩu của bạn';
                      } else if (value!.length < 6) {
                        return 'Mật khẩu phải dài ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ).p(10),
            //forgot pass text
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   padding: EdgeInsets.symmetric(vertical: 0),
            //   alignment: Alignment.bottomRight,
            //   child: TextButton(
            //     onPressed: () => Navigator.of(context)
            //         .pushNamed(AppRoutes.forgotPasswordRoute),
            //     child: Text(
            //       'Forget password?',
            //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            //     ),
            //   ),
            // ),
            //Login Button
            CustomButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String emailOrPhone = emailOrPhoneController.text;
                  String password = passwordController.text;
                  try {
                    if (isEmail(emailOrPhone)) {
                      // Đăng nhập bằng email
                      userProfile = await profilesViewModel.loginEmail(
                          emailOrPhone, password);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (
                            BuildContext context,
                          ) =>
                              HomeScreen(profile: userProfile),
                        ),
                      );
                    } else if (SPUtill.isPhoneNumber(emailOrPhone)) {
                      // Đăng nhập bằng số điện thoại
                      userProfile = await profilesViewModel.loginPhone(
                          emailOrPhone, password);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              HomeScreen(profile: userProfile),
                        ),
                      );
                    } else {
                      throw Exception(
                          'Please enter a valid email or phone number');
                    }
                  } catch (e) {
                    print('Error: $e'); // In thông tin lỗi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Đăng nhập thất bại. Vui lòng kiểm tra tài khoản và mật khẩu')),
                    );
                  }
                }
              },
              title: 'Đăng nhập',
              titleStyle: TextStyle(fontSize: 20, color: Colors.white),
            ).p(10)
          ],
        ),
      ),
    );
  }
}
