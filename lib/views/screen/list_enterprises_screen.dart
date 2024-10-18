import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/api_services/enterprise_service.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_enterprises_screen.dart';

class EnterprisesListScreen extends StatefulWidget {
  @override
  _EnterprisesListScreenState createState() => _EnterprisesListScreenState();
}

class _EnterprisesListScreenState extends State<EnterprisesListScreen> {
  List<Enterprises> enterprisesList = [];
  List<Enterprises> filteredEnterprisesList = [];

  @override
  void initState() {
    super.initState();
    _fetchEnterprises(); // Fetch enterprises when the screen is initialized
  }

  Future<void> _fetchEnterprises() async {
    try {
      List<Enterprises> fetchedEnterprises = await fetchListData();
      setState(() {
        enterprisesList = fetchedEnterprises;
        filteredEnterprisesList =
            fetchedEnterprises; // Initialize filtered list
      });
    } catch (error) {
      print('Error fetching enterprises: $error');
      // Optionally, show an error message to the user
    }
  }

  void _addEnterprise(Enterprises newEnterprise) {
    setState(() {
      enterprisesList.add(newEnterprise);
      _handleSearch(''); // Reapply search to update filtered enterprises list
    });
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEnterprisesList = enterprisesList;
      } else {
        filteredEnterprisesList = enterprisesList.where((enterprise) {
          return enterprise.name!.toLowerCase().contains(query.toLowerCase()) ||
              enterprise.licenseNum!
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
      backgroundColor: AppColor.primaryLightColor,
      bodyChildren: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            suggestions:
                enterprisesList.map((enterprise) => enterprise.name!).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Enterprises>>(
            future: fetchListData(), // Load data using the fetch function
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView.builder(
                  itemCount: filteredEnterprisesList.length,
                  itemBuilder: (context, index) {
                    final enterprise = filteredEnterprisesList[index];
                    return ListTile(
                      title: Text(enterprise.name ?? ''),
                      subtitle: Text(enterprise.phone ?? ''),
                      onTap: () {},
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
      // fabl: FloatingActionButtonLocation.endDocked,
      // fab: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddEnterpriseScreen(onAdd: _addEnterprise),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.blue,
      // ),
    );
  }
}
