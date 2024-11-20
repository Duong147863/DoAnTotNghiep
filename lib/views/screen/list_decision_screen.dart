import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/models/decisions_model.dart';
import 'package:nloffice_hrm/api_services/decision_service.dart';
import 'package:nloffice_hrm/view_models/decisions_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_decision_screen.dart';
import 'package:nloffice_hrm/views/screen/info_decision_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class DecisionsListScreen extends StatefulWidget {
  @override
  State<DecisionsListScreen> createState() => _DecisionsListScreenState();
}

class _DecisionsListScreenState extends State<DecisionsListScreen> {
  final List<Decisions> decisions = [];
  List<Decisions> filteredDecisions = [];
  void initState() {
    super.initState();
    Provider.of<DecisionsViewModel>(context, listen: false).getAllDecisions();
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDecisions = decisions;
      } else {
        filteredDecisions = decisions.where((decisions) {
          return decisions.decisionName
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _handleUpdate(Decisions updatedDecision) {
    setState(() {
      int index = decisions
          .indexWhere((dec) => dec.decisionId == updatedDecision.decisionId);
      if (index != -1) {
        decisions[index] = updatedDecision;
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
                "Quản lí quyết định",
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
            hintText: '',
            suggestions: decisions.map((dec) => dec.decisionName).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: Consumer<DecisionsViewModel>(
            builder: (context, viewModel, child) {
              if (!viewModel.fetchingData && viewModel.listDecisions.isEmpty) {
                Provider.of<DecisionsViewModel>(context, listen: false)
                    .getAllDecisions();
              }
              if (viewModel.fetchingData) {
                return Center(child: CircularProgressIndicator());
              } else {
                // If data is fetched, display it
                List<Decisions> decision = viewModel.listDecisions;
                return CustomListView(
                  dataSet: decision,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                            "Tên quyết định: ${decision[index].decisionName} - Tên: ${decision[index].profileName} "),
                        subtitle: Text(
                            "Ngày tháng năm ${DateFormat('dd/MM/yyyy').format(decision[index].assignDate).toString()}"),
                      ).onInkTap(
                        () async {
                          final updatedDecision = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoDecisionScreen(
                                  decisions: decision[index]),
                            ),
                          );
                          // Kiểm tra xem có dữ liệu cập nhật không
                          if (updatedDecision != null) {
                            _handleUpdate(updatedDecision);
                          }
                        },
                      ),
                    ).py1().px4();
                  },
                );
              }
            },
          ),
        ),
      ],
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDecisionScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
