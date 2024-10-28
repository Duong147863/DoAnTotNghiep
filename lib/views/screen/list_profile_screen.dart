import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/api_services/profile_service.dart'; // Import service
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_profile_screen.dart';

class ProfileListScreen extends StatefulWidget {
  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  List<Profiles> profiles = [];
  List<Profiles> filteredProfiles = [];
  int _selectedTabIndex = 0;
  @override
  void initState() {
    super.initState();
    _fetchProfiles(); // Fetch profiles when the screen is initialized
  }

  Future<void> _fetchProfiles() async {
    try {
      // List<Profiles> fetchedProfiles = await fetchProfile();
      // setState(() {
      //   profiles = fetchedProfiles;
      //   filteredProfiles = fetchedProfiles;
      // });
    } catch (error) {
      print('Error fetching profiles: $error');
      // Optionally, show an error message to the user
    }
  }

  void _handleDelete() {
    setState(() {
      profiles =
          profiles.where((profile) => profile.profileStatus != 0).toList();
      filteredProfiles = profiles;
    });
  }

  void _handleAdd(Profiles newProfile) {
    setState(() {
      profiles.add(newProfile);
      filteredProfiles = profiles;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProfiles = profiles;
      } else {
        filteredProfiles = profiles.where((profile) {
          return profile.profileName!
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        showAppBar: true,
        showLeadingAction: true,
        defaultBody: true,
        appBarItemColor: AppColor.boneWhite,
        backgroundColor: AppColor.primaryLightColor,
        appBar: AppBar(
          backgroundColor: Color(0xFF0B258A),
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Employee List",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFEFF8FF),
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Handle search action
              },
            )
          ],
        ),
        bodyChildren: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
            ],
          ),
        ]);
  }
}
