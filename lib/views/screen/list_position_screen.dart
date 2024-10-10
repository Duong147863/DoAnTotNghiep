import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/api_services/position_service.dart'; // Import service
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/add_position_screen.dart';

class PositionsListScreen extends StatefulWidget {
  @override
  _PositionsListScreenState createState() => _PositionsListScreenState();
}

class _PositionsListScreenState extends State<PositionsListScreen> {
  List<Positions> positions = [];
  List<Positions> filteredPositions = [];

  @override
  void initState() {
    super.initState();
    _fetchPositions(); // Fetch positions when the screen is initialized
  }

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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBar: AppBar(
        title: Text('Danh sách chức vụ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              suggestions:
                  positions.map((position) => position.positionName!).toList(),
              onTextChanged: _handleSearch,
            ),
          ),
        ],
      ),
      fab: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPositionScreen(onAdd: _handleAdd),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
