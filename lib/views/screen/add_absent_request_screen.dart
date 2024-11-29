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
  final _profilenameController = TextEditingController();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  FocusNode _endFocusNode = FocusNode();
  FocusNode _startFocusNode = FocusNode();
  FocusNode _reasonFocusNode = FocusNode();
  int statusAbsent = 0;
  void initState() {
    super.initState();
    _profileIDController.text = widget.profiles!.profileId;
    _profilenameController.text = widget.profiles!.profileName;
    // Focus
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newAbsents = Absents(
          profileID: _profileIDController.text,
          reason: _reasonController.text,
          from: _fromDate,
          to: _toDateController.text.isNotEmpty ? _toDate : null,
          daysOff: _parseDouble(_daysOffController.text),
          status: statusAbsent);
      Provider.of<AbsentsViewModel>(context, listen: false)
          .addNewAbsent(newAbsents, (message) {
        if (message == 'Đơn nghỉ phép đã được tạo thành công.') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context, newAbsents); // Đóng màn hình
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
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
      titletext: "Thêm đơn xin nghỉ phép",
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
                              DateFormat('dd/MM/yyyy').format(_toDate);
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
    final difference = _toDate.difference(_fromDate).inDays;

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
}
