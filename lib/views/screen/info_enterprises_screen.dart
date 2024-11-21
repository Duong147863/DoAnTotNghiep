import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/screen/edit_enterprises_screen.dart';
import 'package:provider/provider.dart';

class InfoEnterpriseScreen extends StatefulWidget {
  @override
  State<InfoEnterpriseScreen> createState() => _InfoEnterpriseScreenState();
}

class _InfoEnterpriseScreenState extends State<InfoEnterpriseScreen> {
  Enterprises? enterprise;

  @override
  void initState() {
    Provider.of<EnterprisesViewModel>(context, listen: false)
        .fetchAllEnterprises();
    enterprise =
        Provider.of<EnterprisesViewModel>(context, listen: false).enterprises;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      appBarColor: AppColor.primaryLightColor,
      appBarItemColor: Colors.white,
      backgroundColor: Colors.white,
      titletext: "Thông tin doanh nghiệp",
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Center(
                  child: Text(
                    enterprise!.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                InfoTile(
                  icon: Icons.business,
                  label: 'Mã số giấy phép',
                  value: enterprise!.licenseNum,
                ),
                InfoTile(
                  icon: Icons.email,
                  label: 'Địa chỉ',
                  value: enterprise!.address!,
                ),
                InfoTile(
                  icon: Icons.email,
                  label: 'Email',
                  value: enterprise!.email!,
                ),
                InfoTile(
                  icon: Icons.phone,
                  label: 'Điện thoại',
                  value: enterprise!.phone!,
                ),
                InfoTile(
                  icon: Icons.calendar_today,
                  label: 'Ngày thành lập',
                  value: enterprise?.assignDate != null
                      ? _formatDate(enterprise!.assignDate)
                      : 'Không có',
                ),
                InfoTile(
                  icon: Icons.phone,
                  label: 'Website',
                  value: enterprise!.website!,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Handle the edit action
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEnterpriseScreen(),
                        ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(4, '0')}';
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this enterprise?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // onDelete();
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ],
        );
      },
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.brown),
            SizedBox(width: 16),
            Text('$label: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Expanded(
                child: Text(
              maxLines: 2,
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ),
    );
  }
}
