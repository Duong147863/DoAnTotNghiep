
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/projects_model.dart';
import 'package:nloffice_hrm/api_services/project_service.dart'; // Import service
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_project_screen.dart';

class ProjectsListScreen extends StatefulWidget {
  @override
  _ProjectsListScreenState createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  List<Projects> projects = [];
  List<Projects> filteredProjects = [];

  @override
  void initState() {
    super.initState();
    _fetchProjects(); 
  }

  Future<void> _fetchProjects() async {
    try {
      List<Projects> fetchedProjects = await fetchListData();
      setState(() {
        projects = fetchedProjects;
        filteredProjects = fetchedProjects; 
      });
    } catch (error) {
      print('Error fetching projects: $error');
    }
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProjects = projects;
      } else {
        filteredProjects = projects.where((project) {
          return project.projectName!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBar: AppBar(
        title: Text('Danh sách dự án'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              suggestions: projects.map((project) => project.projectName!).toList(),
              onTextChanged: _handleSearch,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Projects>>(
              future: fetchListData(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                 
                  filteredProjects = snapshot.data!; 
                  return CustomGridView(
                    padding: EdgeInsets.all(8.0),
                    dataSet: filteredProjects,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];
                      return ProjectCard(
                        project: project,
                      );
                    },
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                  );
                }
              },
            ),
          ),
        ],
      ),
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProjectScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}