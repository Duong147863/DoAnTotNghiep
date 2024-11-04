import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nloffice_hrm/api_services/profile_service.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/repository/profiles_repo.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/screen/home_screen.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool doLogin = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => checkUserIsLogged());
  }

  void checkUserIsLogged() async {
    final prefs = await SharedPreferences.getInstance();
    // final services = ProfileService();
    print(prefs.getBool(AppStrings.SHARED_LOGGED));
    if (prefs.getBool(AppStrings.SHARED_LOGGED)! == false) {
      // setState(() {
      //   doLogin = true;
      // });
      // services
      //     .emailLogin(prefs.getString(AppStrings.SHARED_PASSWORD)!,
      //         prefs.getString(AppStrings.SHARED_PASSWORD)!)
      //     .then((response) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginRoute);
    } else  if (prefs.getBool(AppStrings.SHARED_LOGGED)! == true) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => HomeScreen(profile: ,),
      //   ),
      // );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage();
  }
}
