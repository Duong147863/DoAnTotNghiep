import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/shared_preferences.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_button.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:validators/validators.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgePasswordScreen extends StatelessWidget {
  const ForgePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailOrPhoneController = TextEditingController();
    return DefaultTabController(
      length: 2,
      child: BasePage(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColor.seaShell,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Forgot password",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Enter to retrieve password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ).p(20),
            //Email/ Phone number text field
            CustomTextFormField(
              textEditingController: emailOrPhoneController,
              prefixIcon: const Icon(Icons.person),
              labelText: "Email or Phone number",
              fillColor: AppColor.primaryDarkColor,
              filled: true,
              validator: (value) {
                if (value.isEmptyOrNull) {
                  return 'Please enter your email or phone number';
                } else if (isEmail(value!) == false &&
                    SPUtill.isPhoneNumber(value) == false) {
                  return 'Please enter a valid email or phone number';
                }
                return null;
              },
            ).p(10),
            //Submit button
            CustomButton(
              title: 'send'.tr(),
              titleStyle: TextStyle(fontSize: 20, color: Colors.white),
            ).p(10)
          ],
        ),
      ),
    );
  }
}
