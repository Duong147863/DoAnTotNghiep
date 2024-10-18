import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/api_services/diploma_service.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_diploma_screen.dart';

class DiplomaListScreen extends StatefulWidget {
  @override
  _DiplomaListScreenState createState() => _DiplomaListScreenState();
}

class _DiplomaListScreenState extends State<DiplomaListScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBar: AppBar(
        title: Text('Danh sách bằng cấp'),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: CustomSearchBar(
          //     suggestions:
          //         profiles.map((profile) => profile.profileName!).toList(),
          //     onTextChanged: _handleSearch,
          //   ),
          // ),
        ],
      ),
    );
  }
}
