import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nloffice_hrm/constant/shared_preferences.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool isChecked = false;
  int selectedIndex = 0;
  List languages = [
    {
      'name': 'English',
      'image':
          'https://t2.gstatic.com/licensed-image?q=tbn:ANd9GcQVhwOar0FyOb_mmItcTAQFv1O4k8S_ZUEAI45O7dYC2rXRUWD-nWJwOQWJS2va8krELcDtY0JEVdQabkDkEdo',
    },
    {
      'name': 'VietNam',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Flag_of_Vietnam.svg/125px-Flag_of_Vietnam.svg.png',
    }
    // {
    //   'name': 'Bangla',
    //   'image':
    //       'https://cdn.britannica.com/67/6267-004-10A21DF0/Flag-Bangladesh.jpg',
    // },
    // {
    //   'name': 'Arabic',
    //   'image':
    //       'https://cdn.britannica.com/79/5779-004-DC479508/Flag-Saudi-Arabia.jpg',
    // },
    // {
    //   'name': 'Spanish',
    //   'image':
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Bandera_de_Espa%C3%B1a.svg/1200px-Bandera_de_Espa%C3%B1a.svg.png',
    // },
  ];

  @override
  initState() {
    getSelectedLanguage();
    super.initState();
  }

  getSelectedLanguage() async {
    var selectedLanguage =
        await SPUtill.getSelectLanguage(SPUtill.keySelectLanguage);
    if (kDebugMode) {
      print("selectedLanguage Local: $selectedLanguage");
    }
    if (selectedLanguage != null) {
      setState(() {
        selectedIndex = selectedLanguage;
        if (kDebugMode) {
          print("selectedIndex sssss: $selectedLanguage");
        }
      });
    } else {
      setState(() {
        selectedIndex = 0;
        if (kDebugMode) {
          print("selectedIndex deflt: $selectedIndex");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (context) => const CustomBottomNavBar(
        //             // bottomNavigationIndex: 0
        //             )),
        //     (Route<dynamic> route) => true);
        return true;
      },
      child: BasePage(
        body: SafeArea(
          child: Stack(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Lottie.asset('assets/images/language_lottie.json',
                        height: 100, width: 100),
                    const SizedBox(
                      height: 25,
                    ),
                    Text("choose_your_preferred_language",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "please_select_your_language",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: languages.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                SPUtill.setLanguageIntValue(
                                    SPUtill.keySelectLanguage, selectedIndex);
                                if (kDebugMode) {
                                  print(selectedIndex);
                                }
                                if (selectedIndex == 0) {
                                  context.setLocale(const Locale('en', 'US'));
                                } else if (selectedIndex == 1) {
                                  context.setLocale(const Locale('vi', 'VN'));
                                }
                                getSelectedLanguage();
                              });
                            },
                            child: Row(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                    imageUrl: "${languages[index]['image']}",
                                    placeholder: (context, url) => Center(
                                      child: Image.asset(
                                          "assets/images/placeholder_image.png"),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  languages[index]['name'] ?? "",
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: selectedIndex == index ? 30 : 0,
                                  width: selectedIndex == index ? 30 : 0,
                                  child: Icon(
                                    Icons.check,
                                    size: selectedIndex == index ? 24 : 0,
                                    color: Colors.blue.withOpacity(
                                        selectedIndex == index ? 0.85 : 0),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
