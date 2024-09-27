import 'package:flutter/material.dart';
import 'package:nloffice_hrm/model/profile/profiles_model.dart';
import 'package:nloffice_hrm/model/relatives/relatives_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_relative_screen.dart';
import 'package:nloffice_hrm/services/profile_service.dart';
import 'package:nloffice_hrm/services/relative_service.dart'; 

class RelativeListScreen extends StatefulWidget {
  @override
  _RelativeListScreenState createState() => _RelativeListScreenState();
}

class _RelativeListScreenState extends State<RelativeListScreen> {
  List<Profiles> profiles = [];
  List<Relatives> relatives = [];
  List<Profiles> filteredProfiles = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Profiles> fetchedProfiles = await fetchProfile();
      List<Relatives> fetchedRelatives = await fetchRelatives();
      setState(() {
        profiles = fetchedProfiles;
        relatives = fetchedRelatives;
        filteredProfiles = fetchedProfiles; 
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
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
        title: Text('Danh sách thân nhân'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              suggestions: profiles.map((profile) => profile.profileName!).toList(),
              onTextChanged: _handleSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProfiles.length,
              itemBuilder: (context, index) {
                final profile = filteredProfiles[index];
                final relative = relatives.firstWhere(
                  (s) => s.profileId == profile.profileId,
                  orElse: () => Relatives(),
                );
                return ListTile(
                  title: Text(profile.profileName ?? ''),
                  subtitle: Text(relative.relativesName ?? 'Chưa có thông tin'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoRelativeScreen(
                          profile: profile,
                          relatives: relatives,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}