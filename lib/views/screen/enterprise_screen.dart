import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';

class CompanyInfoPage extends StatelessWidget {
  final Enterprises? enterprises;

  CompanyInfoPage({required this.enterprises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin doanh nghiệp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              enterprises!.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              enterprises!.licenseNum,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 8),
                Text("${enterprises!.phone}"),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8),
                Text(enterprises!.email),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.web),
                SizedBox(width: 8),
                Text(enterprises!.website),
              ],
            ),
            SizedBox(height: 16),
            Text(
             enterprises!.website,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
