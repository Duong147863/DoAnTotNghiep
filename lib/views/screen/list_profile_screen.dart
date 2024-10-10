import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/api_services/profile_service.dart'; // Import service
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_profile_screen.dart';
import 'package:nloffice_hrm/views/screen/info_profile_screen.dart';

class ProfileListScreen extends StatefulWidget {
  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  List<Profiles> profiles = [];
  List<Profiles> filteredProfiles = [];

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
      appBar: AppBar(
        title: Text('Danh sách nhân viên'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              suggestions:
                  profiles.map((profile) => profile.profileName!).toList(),
              onTextChanged: _handleSearch,
            ),
          ),
        ],
      ),
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProfilePage(onAdd: _handleAdd),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
