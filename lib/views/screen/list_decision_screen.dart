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
  // List<Decisions> filteredDecisions = [];
  // void _handleSearch(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       filteredDecisions = decisions;
  //     } else {
  //       filteredDecisions = decisions.where((decisions) {
  //         return decisions.decisionName!
  //             .toLowerCase()
  //             .contains(query.toLowerCase());
  //       }).toList();
  //     }
  //   });
  // }

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
      // body: Expanded(
      //     child:
      // CustomGridView(
      // dataSet: snapshot.data,
      // itemBuilder: (context, index) {
      // final decision = snapshot.data![index];
      // return DecisionCard(decision: decision);
      // },
      // ))
    );

    // return BasePage(
    //   showAppBar: true,
    //   showLeadingAction: true,
    //   body: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: CustomSearchBar(
    //           suggestions: decisions
    //               .map((decisions) => decisions.decisionName!)
    //               .toList(),
    //           onTextChanged: _handleSearch,
    //         ),
    //       ),
    //       Expanded(
    //         child: CustomGridView(
    //           dataSet: decisions,
    //           padding: EdgeInsets.all(16.0),
    //           itemBuilder: (context, index) {
    //             final decision = decisions[index];
    //             return DecisionCard(
    //               decision: decision,
    //             );
    //           },
    //           crossAxisCount: 2,
    //           childAspectRatio: 1.0,
    //           crossAxisSpacing: 2.0,
    //           mainAxisSpacing: 2.0,
    //         ),
    //       ),
    //     ],
    //   ),
    //   fab: FloatingActionButton(
    //     onPressed: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => AddDecisionScreen(),
    //         ),
    //       );
    //     },
    //     child: Icon(Icons.add),
    //     backgroundColor: Colors.blue,
    //   ),
    // );
  }
}

class DecisionCard extends StatelessWidget {
  final Decisions decision;

  DecisionCard({required this.decision});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              decision.decisionName ?? 'Tên quyết định không có',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Mã lương: ${decision.salaryId ?? 'Chưa xác định'}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Trạng thái: ${decision.decisionStatus ?? 'Chưa xác định'}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
