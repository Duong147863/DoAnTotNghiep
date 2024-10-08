import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';

class MoreSettingScreen extends StatelessWidget {
  const MoreSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: false,
      showLeadingAction: false,
      body: ListView(
        children: [],
      ),
    );
  }
}
