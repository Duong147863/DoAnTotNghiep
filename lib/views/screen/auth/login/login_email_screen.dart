import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/model/account/accounts_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_button.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:validators/validators.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class LoginEmail extends StatefulWidget {
  final String title;

  LoginEmail({Key? key, required this.title}) : super(key: key);

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              textEditingController: usernameController,
                              // scrollPadding: EdgeInsets.only(bottom: 150),
                              // style:
                              //     TextStyle(fontSize: 18, color: Colors.black),
                              // decoration: InputDecoration(
                              //   prefixIcon: Icon(Icons.email_outlined),
                              //   labelText: "Email",
                              //   border: OutlineInputBorder(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(10)),
                              //   ),
                              // ),
                              fillColor: Color(0xfff3f3f4),
                              filled: true,
                              validator: (value) {
                                if (value.isEmptyOrNull) {
                                  return 'Please enter your email';
                                } else if (isEmail(value!) == false) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ).p(20),
                            CustomTextFormField(
                              textEditingController: passwordController,
                              obscureText: !_passwordVisible,
                              prefixIcon: Icon(Icons.lock_outline),
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
                              // scrollPadding: EdgeInsets.only(bottom: 150),
                              // style:
                              //     TextStyle(fontSize: 18, color: Colors.black),
                              // decoration: InputDecoration(
                              //   border: OutlineInputBorder(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(10)),
                              //   ),
                              // ),
                              labelText: "Password",
                              filled: true,
                              fillColor: Color(0xfff3f3f4),
                              validator: (value) {
                                if (value.isEmptyOrNull) {
                                  return 'Please enter your password';
                                } else if (value!.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            _forgetPassword().py(10),
                            _logInButton(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                child: Text(
                                  'OR',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            _createAccount(),
                            SizedBox(
                              height: 20,
                            ),
                            _loginGoogle()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Future<ResponseLogin> login(String username, String password) async {
  //   final response = await http.post(
  //     Uri.parse('${AppStrings.baseUrlApi}/accounts'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'username': username,
  //       'password': password,
  //     }),
  //   );
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     final data = jsonDecode(response.body);
  //     print('Dữ liệu phản hồi: $data');
  //     if (data['account_status'] == 1) {
  //       return ResponseLogin.fromJson(data);
  //     } else {
  //       throw Exception('Tài khoản không hợp lệ hoặc bị khóa');
  //     }
  //   } else {
  //     print('Lỗi: ${response.body}');
  //     throw Exception(
  //         'Đăng nhập thất bại: ${response.statusCode} - ${response.body}');
  //   }
  // }

  Widget _logInButton() {
    return CustomButton(
      // onTap: () {
      //   if (_formKey.currentState!.validate()) {
      //     // Process the login with email and password
      //     print('Email: ${usernameController.text}');
      //     print('Password: ${passwordController.text}');
      //   } else {
      //     Navigator.of(context).pushNamed(AppRoutes.homeRoute);
      //   }
      // },
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          String username = usernameController.text;
          String password = passwordController.text;
          try {
            // final response = await login(username, password);
            // if (response.result == true) {
            //   Navigator.of(context).pushNamed(AppRoutes.homeRoute);
            // } else {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //         content: Text(
            //             'Đăng nhập không thành công: ${response.message}')),
            //   );
            // }
          } catch (e) {
            print('Error: $e'); // In thông tin lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi kết nối')),
            );
          }
        }
      },
      title: 'login'.tr(),
      titleStyle: TextStyle(fontSize: 20, color: Colors.white),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade100,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              Colors.blue,
              Color.fromARGB(255, 255, 12, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgetPassword() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 0),
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(AppRoutes.forgotPasswordRoute),
        child: Text(
          'Forget password?',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _createAccount() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'New user? ',
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(
                  text: 'Create An Account',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushNamed(AppRoutes.signupRoute);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginGoogle() {
    return CustomButton(
      onPressed: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Googlelogo.png",
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'Sign in with Google',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
