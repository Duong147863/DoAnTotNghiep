import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

class AddAbsentRequestScreen extends StatefulWidget {
  @override
  _AddAbsentRequestScreenState createState() => _AddAbsentRequestScreenState();
}

class _AddAbsentRequestScreenState extends State<AddAbsentRequestScreen> {
  String? selectedEmployee;
  final _profileIDController = TextEditingController();
  final _reasonController = TextEditingController();
  final _daysOffController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      titletext: "Thêm đơn xin nghỉ việc",
      appBarColor: AppColor.primaryLightColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              textEditingController: _profileIDController,
              labelText: 'Mã nhân viên'.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_enter_profile_id'.tr();
                }
                return null;
              },
            ).py8(),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    'From day',
                    _fromDateController,
                    _fromDate,
                    (date) {
                      setState(() {
                        _fromDate = date;
                        _fromDateController.text = dateFormat.format(date);
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    'To day',
                    _toDateController,
                    _toDate,
                    (date) {
                      setState(() {
                        _toDate = date;
                        _toDateController.text = dateFormat.format(date);
                      });
                    },
                  ),
                ),
              ],
            ).py8(),
            CustomTextFormField(
              textEditingController: _daysOffController,
              labelText: 'Dayoffs'.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_enter_dayoffs'.tr();
                }
                return null;
              },
            ).py8(),
            CustomTextFormField(
              textEditingController: _reasonController,
              labelText: 'Reason'.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_enter_Reason'.tr();
                }
                return null;
              },
            ).py8(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Lưu'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Lưu & Thêm'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Hủy bỏ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ).py16(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, onDateSelected),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'please'.tr();
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
