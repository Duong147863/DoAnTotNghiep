import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Top Section
            PageView(
              children: [
                Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.topRight,
                        child: CustomButton(
                          padding: EdgeInsets.only(left: 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.amber,
                          ),
                        )),
                    Text(
                      'Chào mừng bạn đến với\n NLOffice HRM dành cho\n doanh nghiệp'
                          .tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        // color: Colors.black // Ensure no underline
                      ),
                    ),
                    SizedBox(height: 350),
                    Text(
                      'NLOffice HRM\nPowered by NLOffice.vn'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Colors.black54 // Ensure no underline
                          ),
                    ),
                  ],
                ),

                // TabPageSelector(),
              ],
            ),
            // Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                backgroundcolor: Colors.blue[400],
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.loginRoute);
                },
                child: Text(
                  'Tiếp tục đăng nhập',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
