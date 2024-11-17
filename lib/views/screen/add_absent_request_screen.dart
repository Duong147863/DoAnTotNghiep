import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddAbsentRequestScreen extends StatefulWidget {
  final Profiles? profiles;
  const AddAbsentRequestScreen({super.key, this.profiles});
  @override
  _AddAbsentRequestScreenState createState() => _AddAbsentRequestScreenState();
}

class _AddAbsentRequestScreenState extends State<AddAbsentRequestScreen> {
  String? selectedEmployee;
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _reasonController = TextEditingController();
  final _daysOffController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  void initState() {
    super.initState();
    _profileIDController.text = "dev-001";
  }

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newAbsents = Absents(
          profileID: _profileIDController.text,
          reason: _reasonController.text,
          from: _fromDate,
          to: _toDate,
          daysOff: _parseDouble(_daysOffController.text));
      Provider.of<AbsentsViewModel>(context, listen: false)
          .addNewAbsent(newAbsents)
          .then((_) {
        Navigator.pop(context);
      });
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                enabled: false,
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
                          _updateDayOff(); // Cập nhật lại dayoff khi chọn ngày "From"
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
                          _updateDayOff(); // Cập nhật lại dayoff khi chọn ngày "To"
                        });
                      },
                    ),
                  ),
                ],
              ).py8(),
              CustomTextFormField(
                enabled: false,
                textEditingController: _daysOffController,
                labelText: 'Dayoffs'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_dayoffs'.tr();
                  }
                  // Kiểm tra nếu số ngày nhập vào khớp với sự tính toán từ ngày "From" và "To"
                  double enteredDaysOff = _parseDouble(value);
                  if (enteredDaysOff != _calculateDaysOff()) {
                    return 'Holiday does not match the number of days between "To day" and "From day" '
                        .tr();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text('Lưu'),
                  ),
                ],
              ).py16(),
            ],
          ),
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

            // Kiểm tra ngày "To" phải lớn hơn hoặc bằng ngày "From" cộng thêm một ngày
            if (label == 'To day') {
              final fromDate = _fromDate;
              final toDate = DateTime.parse(value);

              if (toDate.isBefore(fromDate.add(Duration(days: 1)))) {
                return 'To day must be at least one day after From day'.tr();
              }
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

  // Hàm tính toán số ngày nghỉ
  double _calculateDaysOff() {
    final difference = _toDate.difference(_fromDate).inDays;
    return difference >= 0 ? difference.toDouble() : 0.0;
  }

  // Cập nhật lại giá trị "Dayoffs" sau khi chọn ngày "From" và "To"
  void _updateDayOff() {
    setState(() {
      double daysOff = _calculateDaysOff();
      _daysOffController.text = daysOff.toString();
    });
  }

  // Phương thức phụ để xử lý chuyển đổi từ String sang double
  double _parseDouble(String value) {
    if (value.isEmpty) return 0.0; // Nếu rỗng thì trả về giá trị mặc định
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0; // Nếu lỗi chuyển đổi, trả về giá trị mặc định
    }
  }
}
