import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoAbsentScreen extends StatefulWidget {
  final Absents? absents;
  const InfoAbsentScreen({super.key, this.absents});

  @override
  State<InfoAbsentScreen> createState() => _InfoAbsentScreenState();
}

class _InfoAbsentScreenState extends State<InfoAbsentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _reasonController = TextEditingController();
  final _daysOffController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  int _statusAbsent = 0;
  bool _isEditing = false;
  @override
  void initState() {
    super.initState();
    _profileIDController.text = widget.absents!.profileID;
    _reasonController.text = widget.absents!.reason!;
    _fromDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.absents!.from).toString();
    _toDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.absents!.to!).toString();
    _daysOffController.text = widget.absents!.daysOff.toString();
    _statusAbsent = widget.absents!.status;
    _fromDate = widget.absents!.from;
    _toDate = widget.absents!.to!;
  }

  void _updateAbsent() async {
    if (_formKey.currentState!.validate()) {
      if (!AppStrings.ROLE_PERMISSIONS.containsAny(['Manage Staffs info only', 'Manage BoD & HR accounts'])) {
          _statusAbsent = 0; 
      } 
      final updateAbents = Absents(
          profileID: _profileIDController.text,
          reason: _reasonController.text,
          from: _fromDate,
          to: _toDateController.text.isNotEmpty ? _toDate : null,
          daysOff: _parseDouble(_daysOffController.text),
          ID: widget.absents!.ID,
          status: _statusAbsent);
      try {
        await Provider.of<AbsentsViewModel>(context, listen: false)
            .updateAbents(updateAbents);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Absent Updated successfully!')),
        );
        Navigator.pop(context, updateAbents);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Absent: $e')),
        );
      }
    }
  }

  void _deleteAbsents() async {
    try {
      final asbentId = widget.absents!.ID;

      if (asbentId != null) {
        await Provider.of<AbsentsViewModel>(context, listen: false)
            .deleteAbents(asbentId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Relative deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Relative ID is null. Cannot delete relative.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Relative: $e')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      titletext: "Sửa hoặc duyệt đơn xin nghỉ việc",
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
                enabled: _isEditing,
                textEditingController: _reasonController,
                labelText: 'Reason'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_Reason'.tr();
                  }
                  return null;
                },
              ).py8(),
                AppStrings.ROLE_PERMISSIONS
                          .containsAny(['Manage Staffs info only', 'Manage BoD & HR accounts'])
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status Absents').px(8),
                        _buildDropdownField(
                          'Status Absents',
                          _statusAbsent,
                          (value) {
                            setState(() {
                              _statusAbsent = value!;
                            });
                          },
                        ).px(8),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.save,
                        color: const Color.fromARGB(255, 33, 243, 61)),
                    onPressed: _updateAbsent,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text(
                                'Are you sure you want to delete this absent?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng dialog
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng dialog
                                  _deleteAbsents(); // Thực hiện xóa
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: _isEditing
          ? () => _selectDate(context, initialDate, onDateSelected)
          : null,
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

  Widget _buildDropdownField(
      String label, int currentValue, Function(int?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: currentValue,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: [
          DropdownMenuItem(value: -1, child: Text('Từ Chối Duyệt')),
          DropdownMenuItem(value: 0, child: Text('Đợi Duyệt')),
          DropdownMenuItem(value: 1, child: Text('Đã Duyệt')),
        ],
        onChanged: _isEditing ? onChanged : null,
        validator: (value) =>
            value == null ? 'Please select a status project' : null,
      ),
    );
  }
}
