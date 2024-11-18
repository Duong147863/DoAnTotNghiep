import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/models/decisions_model.dart';
import 'package:nloffice_hrm/api_services/decision_service.dart';
import 'package:nloffice_hrm/view_models/decisions_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_grid_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_decision_screen.dart';
import 'package:provider/provider.dart';

class DecisionsListScreen extends StatefulWidget {
  @override
  State<DecisionsListScreen> createState() => _DecisionsListScreenState();
}

class _DecisionsListScreenState extends State<DecisionsListScreen> {
  final List<Decisions> decisions = [];
  List<Decisions> filteredDecisions = [];
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDecisions = decisions;
      } else {
        filteredDecisions = decisions.where((decisions) {
          return decisions.decisionName!
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      bodyChildren: [
        Consumer<DecisionsViewModel>(builder: (context, viewModel, child) {
          if (viewModel.fetchingData) {
            return CircularProgressIndicator(); // While data is being fetched
          } else {
            // If data is successfully fetched
            List<Decisions> decisions = viewModel.listDecisions;
            return CustomListView(
              dataSet: decisions,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(decisions[index].decisionName.toString()),
                  onTap: () {
                    // Navigator.pushNamed(context, AppRoutes.decisionListRoute);
                  },
                );
              },
            );
          }
        })
      ],
    );
  }
}
