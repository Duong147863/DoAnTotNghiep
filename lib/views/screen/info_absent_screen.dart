import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoAbsentScreen extends StatefulWidget {
  final Absents? absents;
  final Profiles? profile;
  const InfoAbsentScreen({super.key, this.absents, this.profile});

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
  final _nameController = TextEditingController();
  DateTime _fromDate = DateTime.now();
  DateTime? _toDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  int? _statusAbsent;
  bool _isEditing = false;
  int? idAbsent;
  FocusNode _endFocusNode = FocusNode();
  FocusNode _startFocusNode = FocusNode();
  FocusNode _reasonFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    idAbsent = widget.absents!.ID;
    _profileIDController.text = widget.absents!.profileID;
    _reasonController.text = widget.absents!.reason!;
    _fromDateController.text =
        DateFormat('dd/MM/yyyy').format(widget.absents!.from).toString();
    _fromDate = widget.absents!.from;
    // _toDateController.text =
    //     DateFormat('dd/MM/yyyy').format(widget.absents!.to!).toString();
    // _toDate = widget.absents!.to!;
    // Kiểm tra nếu `to` là null
if (widget.absents!.to != null) {
  _toDateController.text = DateFormat('dd/MM/yyyy').format(widget.absents!.to!).toString();
  _toDate = widget.absents!.to!;
} else {
  // Nếu `to` là null, có thể để trống hoặc gán giá trị mặc định
  _toDateController.text = '';
  _toDate = null;  // Có thể để `_toDate` là null nếu cần
}
    _daysOffController.text = widget.absents!.daysOff.toString();
    _statusAbsent = widget.absents!.status;
    _endFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_endFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _reasonFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_reasonFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _startFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_startFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  void _updateAbsent() async {
    if (_formKey.currentState!.validate()) {
      final updateAbents = Absents(
          ID: idAbsent,
          profileID: _profileIDController.text,
          reason: _reasonController.text,
          from: _fromDate,
          to: _toDateController.text.isNotEmpty ? _toDate : null,
          daysOff: _parseDouble(_daysOffController.text),
          status: _statusAbsent!);
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
          SnackBar(content: Text('Deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot delete.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1960),
      lastDate: DateTime(2100),
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
      titletext: "Duyệt và Cập Nhật Đơn Nghỉ Việc",
      appBarColor: AppColor.primaryLightColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  ).px8().w(150),
                  AppStrings.ROLE_PERMISSIONS.containsAny([
                    'Manage Staffs info only',
                    'Manage BoD & HR accounts'
                  ])
                      ? _buildDropdownField(
                          'Duyệt đơn',
                          _statusAbsent!,
                          (value) {
                            setState(() {
                              _statusAbsent = value!;
                            });
                          },
                        ).w(220)
                      : SizedBox.shrink(),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDateFrom(
                      'Từ ngày',
                      _fromDateController,
                      _fromDate,
                      (date) {
                        setState(() {
                          _fromDate = date;
                          _fromDateController.text =
                              DateFormat('dd/MM/yyyy').format(_fromDate);
                          _updateDayOff(); // Cập nhật lại dayoff khi chọn ngày "From"
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDateToWithClearButton(
                      'Đến ngày',
                      _toDateController,
                      _toDate,
                      (date) {
                        setState(() {
                          _toDate = date!;
                          _toDateController.text =
                              DateFormat('dd/MM/yyyy').format(_toDate!);
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
                labelText: 'Ngày nghỉ'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống'.tr();
                  }

                  // Kiểm tra số ngày nghỉ tối đa 12 ngày
                  double enteredDaysOff = _parseDouble(value);
                  if (enteredDaysOff > 12) {
                    return 'Số ngày nghỉ không được vượt quá 12 ngày';
                  }

                  // Kiểm tra nếu số ngày nhập vào khớp với sự tính toán từ ngày "From" và "To"
                  double calculatedDaysOff = _calculateDaysOff();

                  // So sánh số ngày nghỉ nhập vào với số ngày được tính toán
                  if (enteredDaysOff != calculatedDaysOff) {
                    return 'Ngày nghỉ không khớp với số ngày giữa "Từ ngày" và "Đến ngày" '
                        .tr();
                  }
                  return null;
                },
              ).py8(),
              CustomTextFormField(
                maxLength: 255,
                focusNode: _reasonFocusNode,
                textEditingController: _reasonController,
                labelText: 'Lý do',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng không để trống';
                  }
                  // Kiểm tra không có khoảng trắng ở cuối tên
                  if (value.trim() != value) {
                    return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                  }
                  if (value.length < 10) {
                    return 'Lý do phải có ít nhất 10 ký tự';
                  }
                  // Regex kiểm tra ký tự đặc biệt
                  final nameRegex = RegExp(
                      r"^[a-zA-ZÂÃÈÉÊÙÚỦĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẨẫấậẫầãèéêìíòóôõùúăđĩũảơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽỈẹêềứỨếểễệẾỀỂỆỄìỉĩịỊÌIÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỔỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s0-9\-/:]+$");
                  if (!nameRegex.hasMatch(value)) {
                    return 'Lý do không hợp lệ. Vui lòng nhập đúng định dạng.';
                  }
                  if (!value.isLetter()) {
                    return 'Lý do chỉ gồm chữ';
                  }
                  return null;
                },
              ).px8(),

              SizedBox(height: 16),
             Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    // Nút Lưu chỉ hiển thị khi không phải status = -1
    if (widget.absents!.status != -1) 
      IconButton(
        icon: Icon(Icons.save, color: const Color.fromARGB(255, 33, 243, 61)),
        onPressed: _updateAbsent,
      ),
    
    // Nút Chỉnh sửa chỉ hiển thị khi không phải status = -1
    if (widget.absents!.status != -1)
      IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: () {
          setState(() {
            _isEditing = true;
          });
        },
      ),

    // Nút Xóa luôn hiển thị
    IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Delete'),
              content: Text('Are you sure you want to delete this absent?'),
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
)

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateFrom(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _fromDate = selectedDate; // Cập nhật giá trị
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          focusNode: _startFocusNode,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập ngày bắt đầu hợp đồng';
            }
            try {
              DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(value);

              // Kiểm tra ngày không được trong quá khứ
              if (selectedDate
                  .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                return 'Ngày bắt đầu không được trong quá khứ';
              }
            } catch (e) {
              return 'Định dạng ngày không hợp lệ';
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

  Widget _buildDateToWithClearButton(
      String label,
      TextEditingController controller,
      DateTime? initialDate,
      Function(DateTime?) onDateSelected) {
    return Row(
      children: [
        // Trường nhập ngày với GestureDetector
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(
              context,
              initialDate ?? DateTime.now(),
              (selectedDate) {
                onDateSelected(selectedDate);
                setState(() {
                  _toDate = selectedDate;
                  controller.text = selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate)
                      : "Hiện tại";
                });
              },
            ),
            child: AbsorbPointer(
              child: TextFormField(
                focusNode: _endFocusNode,
                readOnly: true,
                style: TextStyle(color: Colors.black),
                controller: controller,
                validator: (value) {},
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8), // Khoảng cách giữa TextField và nút
        // Nút xóa
        IconButton(
          onPressed: () {
            setState(() {
              _toDateController.clear(); // Xóa nội dung TextFormField
              _toDate =
                  _fromDate; // Đặt lại ngày "toDate" bằng ngày "fromDate" hoặc giá trị mặc định
              _updateDayOff(); // Cập nhật lại số ngày nghỉ
            });
          },
          icon: Icon(Icons.clear, color: Colors.red),
          tooltip: 'Xóa nội dung',
        )
      ],
    );
  }

  double _calculateDaysOff() {
    if (_toDateController.text.isEmpty) {
      return 1.0; // Mặc định số ngày nghỉ là 1 nếu "To" trống
    }
    final difference = _toDate!.difference(_fromDate).inDays;

    // Loại trừ thứ 7 và Chủ nhật khỏi số ngày nghỉ
    int daysOff = 0;
    for (int i = 0; i <= difference; i++) {
      final currentDate = _fromDate.add(Duration(days: i));
      // Kiểm tra xem ngày hiện tại có phải là thứ 7 (6) hoặc Chủ nhật (7)
      if (currentDate.weekday != DateTime.saturday &&
          currentDate.weekday != DateTime.sunday) {
        daysOff++;
      }
    }

    return daysOff.toDouble();
  }

  void _updateDayOff() {
    setState(() {
      double daysOff = _calculateDaysOff();
      _daysOffController.text =
          daysOff.toStringAsFixed(0); // Làm tròn thành số nguyên
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
