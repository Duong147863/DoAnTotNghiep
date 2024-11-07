import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/screen/add_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/edit_relative_screen.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';

class InfoRelativeScreen extends StatefulWidget {
  final Profiles profile;
  final List<Relatives> relatives;

  InfoRelativeScreen({
    required this.profile,
    required this.relatives,
  });

  @override
  _InfoRelativeScreenState createState() => _InfoRelativeScreenState();
}

class _InfoRelativeScreenState extends State<InfoRelativeScreen> {
  List<Relatives> relatives = [];
  List<Relatives> filteredRelatives = [];

  @override
  void initState() {
    super.initState();
    relatives = widget.relatives;
    filteredRelatives = relatives;
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRelatives = relatives;
      } else {
        filteredRelatives = relatives.where((relative) {
          return relative.relativesName!
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
      appBar: AppBar(
        title: Text('Thông tin thân nhân'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tìm kiếm thân nhân
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomSearchBar(
                hintText: 'Tìm kiếm thân nhân',
                suggestions: relatives.map((relative) => relative.relativesName!).toList(),
                onTextChanged: _handleSearch,
              ),
            ),
            
            // Hiển thị danh sách thân nhân
            Expanded(
              child: CustomListView(
                dataSet: filteredRelatives,
                itemBuilder: (context, index) {
                  final relative = filteredRelatives[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thân nhân ${index + 1}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      InfoTile(
                        icon: Icons.person,
                        label: 'Tên',
                        value: relative.relativesName ?? 'Unknown',
                      ),
                      InfoTile(
                        icon: Icons.phone,
                        label: 'Số điện thoại',
                        value: relative.relativesPhone ?? 'Unknown',
                      ),
                      InfoTile(
                        icon: Icons.cake,
                        label: 'Ngày sinh',
                        value: relative.relativesBirthday != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(relative.relativesBirthday!)
                            : 'Unknown',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditRelativeScreen(
                                    relative: relative,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
            
            // Nút thêm thân nhân
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRelativeScreen(),
                  ),
                );
              },
              child: Text('Add Relative'),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown),
          SizedBox(width: 16),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
