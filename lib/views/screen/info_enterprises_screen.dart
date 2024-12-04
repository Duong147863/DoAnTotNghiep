import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  print("licenseNum: ${enterprise!.licenseNum ?? 'Không có dữ liệu'}");
// print("name: ${enterprise!.name ?? 'Không có dữ liệu'}");
// print("address: ${enterprise!.address ?? 'Không có dữ liệu'}");
// print("email: ${enterprise!.email ?? 'Không có dữ liệu'}");
// print("assignDate: ${enterprise!.assignDate ?? 'Không có dữ liệu'}");
// print("phone: ${enterprise!.phone ?? 'Không có dữ liệu'}");
// print("website: ${enterprise!.website ?? 'Không có dữ liệu'}");
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      appBarColor: AppColor.primaryLightColor,
      appBarItemColor: Colors.white,
      backgroundColor: Colors.white,
      titletext: "Thông tin doanh nghiệp",
      actions: [
        _isEditing
            ? IconButton(
                enableFeedback: true,
                onPressed: () {
                  // Tắt nút sau khi nhấn
                  setState(() {
                    _isEditing = false;
                  });
                  // Thực hiện hành động
                }, // Nếu nút không được bật, sẽ không thực hiện hành động
                icon: Icon(Icons.save, color: Colors.white),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true; // Chuyển đổi chế độ chỉnh sửa
                  });
                },
                icon: Icon(Icons.edit))
      ],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<EnterprisesViewModel>(
                builder: (context, viewModel, child) {
              if (!viewModel.fetchingData && viewModel.enterprises == null) {
                Provider.of<EnterprisesViewModel>(context, listen: false)
                    .fetchAllEnterprises();
              }
              if (viewModel.fetchingData) {
                // While data is being fetched
                return const Center(child: CircularProgressIndicator());
              } else {
                Enterprises enterprise = viewModel.enterprises!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        enterprise!.name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
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
                      value: enterprise!.address,
                    ),
                    InfoTile(
                      icon: Icons.email,
                      label: 'Email',
                      value: enterprise!.email,
                    ),
                    InfoTile(
                      icon: Icons.phone,
                      label: 'Điện thoại',
                      value: enterprise!.phone,
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
                      value: enterprise!.website,
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(4, '0')}';
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
