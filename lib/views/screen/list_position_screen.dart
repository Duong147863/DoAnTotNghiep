import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/api_services/position_service.dart'; // Import service
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_position_screen.dart';
import 'package:nloffice_hrm/views/screen/info_position_screen.dart';
import 'package:provider/provider.dart';
import '../../constant/app_route.dart';
import '../custom_widgets/custom_list_view.dart';

class PositionsListScreen extends StatefulWidget {
  @override
  _PositionsListScreenState createState() => _PositionsListScreenState();
}

class _PositionsListScreenState extends State<PositionsListScreen> {
  List<Positions> positions = [];
  List<Positions> filteredPositions = [];

  Future<void> _fetchPositions() async {
    try {
      // List<Positions> fetchedPositions = await fetchPositions();
      // setState(() {
      //   positions = fetchedPositions;
      //   filteredPositions = fetchedPositions;
      // });
    } catch (error) {
      print('Error fetching positions: $error');
    }
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPositions = positions;
      } else {
        filteredPositions = positions.where((position) {
          return position.positionName!
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }
  
  void _handleAdd(Positions newPosition) {
    setState(() {
      positions.add(newPosition);
      _handleSearch('');
    });
  }
  void _handleUpdate(Positions updatedPosition) {
    setState(() {
      int index = positions.indexWhere((pos) => pos.positionId == updatedPosition.positionId);
      if (index != -1) {
        positions[index] = updatedPosition; 
      }
    });
  }
   void _handleDelete(Positions deletePosition) {
    setState(() {
      positions = positions
          .where((pos) => pos.positionId != deletePosition.positionId)
          .toList();
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
                "Positions Management",
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
            suggestions:
                positions.map((position) => position.positionName!).toList(),
            onTextChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: Consumer<PositionsViewModel>(
              builder: (context, viewModel, child) {
            if (!viewModel.fetchingData && viewModel.listPositions.isEmpty) {
              Provider.of<PositionsViewModel>(context, listen: false)
                  .fetchPositions();
            }
            if (viewModel.fetchingData) {
              // While data is being fetched
              return Center(child: CircularProgressIndicator());
            } else {
              // If data is successfully fetched
              List<Positions> positions = viewModel.listPositions;
              return CustomListView(
                dataSet: positions,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(positions[index].positionName.toString()),
                    trailing: Text(positions[index].positionId.toString()),
                    // leading: Text(accounts[index].positionId.toString()),
                     onTap: () async {
                      // Gọi màn hình thông tin phòng ban và chờ kết quả
                      final updatedPosition = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PositonInfoScreen(positions: positions[index]),
                        ),
                      );

                      // Kiểm tra xem có dữ liệu cập nhật không
                      if (updatedPosition != null) {
                        _handleUpdate(updatedPosition);
                      }
                    },
                  );
                },
              );
            }
          }),
        ),
      ],
      // fab: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddPositionScreen(onAdd: _handleAdd),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.blue,
      // ),
    );
  }
}
