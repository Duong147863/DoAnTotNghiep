import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      bodyChildren: [
        SizedBox(
          width: double.infinity,
          height: 585,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                direction: DismissDirection.horizontal,
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                onDismissed: (direction) {},
                key: Key(""),
                child: Text("aaaaaaaaaaa"),
              );
            },
          ),

          /// if All Tasks Done Show this Widgets
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Lottie
            FadeIn(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  "lottieURL",
                  animate: true,
                ),
              ),
            ),

            /// Bottom Texts
            FadeInUp(
              from: 30,
              child: const Text("MyString.doneAllTask"),
            ),
          ],
        ),
      ],
    );
  }
}
