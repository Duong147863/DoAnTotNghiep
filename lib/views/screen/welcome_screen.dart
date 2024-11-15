import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:velocity_x/velocity_x.dart';

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
    if (AppStrings.TOKEN.trim().isNotEmptyAndNotNull) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginRoute);
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: Center(
        child: Image.asset(
          "assets/images/logos/black_logo.png",
          height: 280,
          width: 280,
        ),
      ),
    );
  }
}
