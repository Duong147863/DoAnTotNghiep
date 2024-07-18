import 'package:flutter/material.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Image avatar = Image.asset('assets/images/male_avatar.png');
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline)),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.55,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: avatar.image,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    ),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30))),
                alignment: Alignment.center,
                child: UiSpacer.emptySpace(),
              ),
            ],
          ),
          // PageView to display avatar on top of everything using stack
          PageView(
            children: [
              Center(
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  alignment: Alignment.center,
                  child: avatar,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
