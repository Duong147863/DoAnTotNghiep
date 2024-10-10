import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/api_services/profile_service.dart';
import 'package:nloffice_hrm/api_services/salary_service.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_salari_sceen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SalaryListScreen extends StatefulWidget {
  @override
  _SalaryListScreenState createState() => _SalaryListScreenState();
}

class _SalaryListScreenState extends State<SalaryListScreen> {
  List<Profiles> profiles = []; // Khai báo danh sách profiles
  List<Profiles> filteredProfiles = [];
  List<Salaries> salaries = []; // Khai báo danh sách salaries
  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchSalary();
  }

  Future<void> _fetchProfile() async {
    try {
      // List<Profiles> fetchedProfiles = await fetchProfile();
      // setState(() {
      //   profiles = fetchedProfiles;
      //   filteredProfiles = fetchedProfiles;
      // });
    } catch (error) {
      print('Error fetching profiles: $error');
    }
  }

  Future<void> _fetchSalary() async {
    try {
      // List<Salaries> fetchedSalaries = await fetchSalary();
      // setState(() {
      //   salaries = fetchedSalaries;
      // });
    } catch (error) {
      print('Error fetching salaries: $error');
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

  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      defaultBody: true,
      showLeadingAction: true,
      backgroundColor: AppColor.primaryLightColor,
      bodyChildren: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            suggestions:
                profiles.map((profile) => profile.profileName!).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredProfiles.length,
            itemBuilder: (context, index) {
              final profile = filteredProfiles[index];
              final salary = salaries.firstWhere(
                (s) => s.salaryId.toString() == profile.salaryId,
                orElse: () => Salaries(),
              );
              return ListTile(
                title: Text(profile.profileName ?? 'Chưa có tên'),
                subtitle: Text(
                    'Phòng: ${profile.departmentId ?? 'Chưa có phòng'}\nLương: ${salary.salary ?? 0.0}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoSalariScreen(
                        salary: salary,
                        profile: profile,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
