import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/main.dart';
import 'package:nloffice_hrm/models/projects_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_card.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_project_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ListProjectScreen extends StatefulWidget {
  const ListProjectScreen({super.key});

  @override
  State<ListProjectScreen> createState() => _ListProjectScreenState();
}

class _ListProjectScreenState extends State<ListProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectIdController = TextEditingController();
  final _projectNameController = TextEditingController();
  List<Projects> projects = [];
  List<Projects> filteredProjects = [];
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProjects = projects;
      } else {
        filteredProjects = projects.where((pro) {
          return pro.projectName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _handleUpdate(Projects updatedProject) {
    setState(() {
      int index = projects
          .indexWhere((pro) => pro.projectId == updatedProject.projectId);
      if (index != -1) {
        projects[index] = updatedProject;
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
                  "Project Management",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFEFF8FF),
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
        bodyChildren: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              hintText: 'Tên dự án',
              suggestions: projects.map((pro) => pro.projectName).toList(),
              onTextChanged: _handleSearch,
            ),
          ),
          Expanded(
            child: Consumer<ProjectsViewModel>(
                builder: (context, viewModel, child) {
              if (!viewModel.fetchingData && viewModel.listProjects.isEmpty) {
                Provider.of<ProjectsViewModel>(context, listen: false)
                    .getAllProject();
              }
              if (viewModel.fetchingData) {
                // While data is being fetched
                return Center(child: CircularProgressIndicator());
              } else {
                // If data is successfully fetched
                List<Projects> projects = viewModel.listProjects;
                return CustomListView(
                  dataSet: projects,
                  itemBuilder: (context, index) {
                    return CustomCard(
                            title:
                                "${projects[index].projectId} - ${projects[index].projectName}",
                                
                            subttile: projects[index].projectStatus == 0
                                ? "Đang Làm"
                                : "Hoàn Thành")
                        .onInkTap(
                      () async {
                        // Gọi màn hình thông tin chức vụ và chờ kết quả
                        final updatedShift = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InfoProjectScreen(projects: projects[index]),
                          ),
                        );
                        // Kiểm tra xem có dữ liệu cập nhật không
                        if (updatedShift != null) {
                          _handleUpdate(updatedShift);
                        }
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
        fab: SpeedDial(
            elevation: 0,
            icon: Icons.menu,
            buttonSize: Size(50, 50),
            children: [
              SpeedDialChild(
                label: "Thêm dự án",
                onTap: () => showDialog<Widget>(
                  context: context,
                  builder: (context) => Dialog(
                    child: Container(
                      height: 300,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                            key: _formKey,
                            child: ListView(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: _projectIdController,
                                    decoration: InputDecoration(
                                      labelText: 'project ID',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter project ID';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    controller: _projectNameController,
                                    decoration: InputDecoration(
                                      labelText: 'project Name',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter project name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final newProject = Projects(
                                        projectId: _projectIdController.text,
                                        projectName:
                                            _projectNameController.text,
                                      );
                                      context
                                          .read<ProjectsViewModel>()
                                          .addNewProject(newProject);
                                      Navigator.pop(context);
                                      initState();
                                    }
                                  },
                                  child: Text('Add Project'),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              )
            ]));
  }
}
