import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/view_models/workingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoWorkingprocessScreen extends StatefulWidget {
  final WorkingProcesses? workingProcesses;
  final Profiles? profiles;
  final Function(int) onDelete;
  const InfoWorkingprocessScreen({
    super.key,
    this.workingProcesses,
    this.profiles,
    required this.onDelete,
  });

  @override
  State<InfoWorkingprocessScreen> createState() =>
      _InfoWorkingprocessScreenState();
}

class _InfoWorkingprocessScreenState extends State<InfoWorkingprocessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _workingprocessIdController = TextEditingController();
  final _workplaceNameController = TextEditingController();
  final _workingprocessContentController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  bool _isEditing = false;
  DateTime? birthdayEmloyment;
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _startFocusNode = FocusNode();
  FocusNode _endFocusNode = FocusNode();
  void initState() {
    super.initState();
    _profileIDController.text = widget.workingProcesses!.profileId;
    birthdayEmloyment = widget.profiles!.birthday;
    _workingprocessIdController.text =
        widget.workingProcesses!.workingprocessId.toString();
    _workplaceNameController.text = widget.workingProcesses!.workplaceName;
    _workingprocessContentController.text =
        widget.workingProcesses!.workingprocessContent!;
    _startTimeController.text = DateFormat('dd/MM/yyyy')
        .format(widget.workingProcesses!.startTime)
        .toString();
    if (widget.workingProcesses!.endTime == null) {
      _endTimeController.text = "Hiện tại";
    } else {
      _endTimeController.text = DateFormat('dd/MM/yyyy')
          .format(widget.workingProcesses!.endTime!)
          .toString();
      _endTime = widget.workingProcesses!.endTime!;
    }
    _startTime = widget.workingProcesses!.startTime;
    // Focus
    _nameFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_nameFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _contentFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_contentFocusNode.hasFocus) {
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
    // Focus

    _endFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_endFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  void _updateWorkingprocess() async {
    if (_formKey.currentState!.validate()) {
      final updatedWorkingprocess = WorkingProcesses(
        profileId: _profileIDController.text,
        workingprocessId: int.tryParse(_workingprocessIdController.text),
        workplaceName: _workplaceNameController.text,
        workingprocessContent: _workingprocessContentController.text,
        startTime: _startTime,
        endTime: (_endTimeController.text.isEmpty ||
                _endTimeController.text == "Hiện tại")
            ? null
            : _endTime,
      );
      await Provider.of<WorkingprocessesViewModel>(context, listen: false)
          .updateWorkingprocess(updatedWorkingprocess, (message) {
        if (message == 'Quá trình công tác đã được cập nhật thành công!') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context, updatedWorkingprocess);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      });
    }
  }

  void _deleteWorkingprocess() async {
    try {
      final workingid = widget.workingProcesses!.workingprocessId;
      if (workingid != null) {
        await Provider.of<WorkingprocessesViewModel>(context, listen: false)
            .deleteWorkingprocess(workingid);
        widget.onDelete(workingid);
        Navigator.pop(context); // Trở về màn hình trước
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa quá trình công tác thành công')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Workingprocess: $e')),
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

  Widget _buildDateStartTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: _isEditing
          ? () => _selectDate(context, initialDate, (selectedDate) {
                onDateSelected(selectedDate);
                setState(() {
                  _startTime = selectedDate;
                  // Định dạng ngày theo DD/MM/YYYY và gán vào controller
                  controller.text =
                      DateFormat('dd/MM/yyyy').format(selectedDate);
                });
              })
          : null,
      child: AbsorbPointer(
        child: TextFormField(
          focusNode: _startFocusNode,
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nhập ngày bắt đầu';
            }

            // Parse ngày theo định dạng nhập
            DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(value);

            // Kiểm tra ngày bắt đầu là quá khứ
            if (selectedDate.isAfter(DateTime.now())) {
              return 'Ngày bắt đầu phải là ngày trong quá khứ';
            }

            // Kiểm tra ngày sinh và tính tuổi
            if (birthdayEmloyment != null) {
              int ageAtStartTime = selectedDate.year - birthdayEmloyment!.year;
              if (selectedDate.month < birthdayEmloyment!.month ||
                  (selectedDate.month == birthdayEmloyment!.month &&
                      selectedDate.day < birthdayEmloyment!.day)) {
                ageAtStartTime--;
              }

              if (ageAtStartTime < 6) {
                return 'Nhân viên phải trên 6 tuổi tại thời điểm bắt đầu';
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

  Widget _buildDateEndTimeWithClearButton(
      String label,
      TextEditingController controller,
      DateTime? initialDate,
      Function(DateTime?) onDateSelected) {
    return Row(
      children: [
        // Trường nhập ngày với GestureDetector
        Expanded(
          child: GestureDetector(
            onTap: _isEditing
                ? () => _selectDate(
                      context,
                      initialDate ?? DateTime.now(),
                      (selectedDate) {
                        onDateSelected(selectedDate);
                        setState(() {
                          _endTime = selectedDate;
                          controller.text = selectedDate != null
                              ? DateFormat('dd/MM/yyyy').format(selectedDate)
                              : "Hiện tại";
                        });
                      },
                    )
                : null,
            child: AbsorbPointer(
              child: TextFormField(
                focusNode: _endFocusNode,
                readOnly: true,
                style: TextStyle(color: Colors.black),
                controller: controller,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      value != "Hiện tại") {
                    try {
                      DateTime selectedEndTime =
                          DateFormat('dd/MM/yyyy').parse(value);
                      if (selectedEndTime.isAfter(DateTime.now())) {
                        return 'Ngày kết thúc không thể lớn hơn ngày hiện tại';
                      }
                      if (selectedEndTime.isBefore(_startTime) ||
                          selectedEndTime.difference(_startTime).inDays < 30) {
                        return 'End Time phải trên 1 tháng kể từ Start Time';
                      }
                    } catch (e) {
                      return 'Định dạng ngày không hợp lệ';
                    }
                  }
                  return null; // Cho phép để trống hoặc "Hiện tại"
                },
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
          onPressed: _isEditing
              ? () {
                  setState(() {
                    controller.clear(); // Xóa nội dung TextFormField
                  });
                }
              : null,
          icon: Icon(Icons.clear, color: Colors.red),
          tooltip: 'Xóa nội dung',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Cập Nhật Quá Trình Công Tác',
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      resizeToAvoidBottomInset: true,
      appBarColor: AppColor.primaryLightColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: false,
                    textEditingController: _profileIDController,
                    labelText: 'Mã nhân viên',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được bỏ trống';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    maxLength: 255,
                    focusNode: _nameFocusNode,
                    textEditingController: _workplaceNameController,
                    labelText: 'Tên quá trình công tác',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng không để trống';
                      }
                      // Kiểm tra không có khoảng trắng ở cuối tên
                      if (value.trim() != value) {
                        return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                      }
                      if (value.length < 10) {
                        return 'Tên quá trình đào tạo phải có ít nhất 10 ký tự';
                      }
                      // Regex kiểm tra ký tự đặc biệt
                      final nameRegex = RegExp(
                          r"^[a-zA-ZÂÃÈÉÊÙÚỦĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẨẫấậẫầãèéêìíòóôõùúăđĩũảơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽỈẹêềứỨếểễệẾỀỂỆỄìỉĩịỊÌIÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỔỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s0-9\-/:]+$");
                      if (!nameRegex.hasMatch(value)) {
                        return 'Tên quá trình công tác không hợp lệ. Vui lòng nhập đúng định dạng.';
                      }
                      if (!value.isLetter()) {
                        return 'Tên quá trình công tác chỉ gồm chữ';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    maxLength: 255,
                    focusNode: _contentFocusNode,
                    maxLines: null,
                    textEditingController: _workingprocessContentController,
                    labelText: 'Nội dung quá trình công tác',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng không để trống';
                      }
                      // Kiểm tra không có khoảng trắng ở cuối tên
                      if (value.trim() != value) {
                        return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                      }
                      if (value.length < 10) {
                        return 'Nội dung phải có ít nhất 10 ký tự';
                      }
                      final nameRegex = RegExp(
                          r"^[a-zA-ZÂÃÈÉÊÙÚỦĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẨẫấậẫầãèéêìíòóôõùúăđĩũảơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽỈẹêềứỨếểễệẾỀỂỆỄìỉĩịỊÌIÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỔỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s0-9\-/:]+$");
                      if (!nameRegex.hasMatch(value)) {
                        return 'Nội dung không hợp lệ. Vui lòng nhập đúng định dạng.';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateStartTime(
                          'Start Time',
                          _startTimeController,
                          _startTime,
                          (date) {
                            setState(() {
                              _startTime = date;
                              _startTimeController.text =
                                  DateFormat('dd/MM/yyyy').format(_startTime);
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDateEndTimeWithClearButton(
                          'End Time',
                          _endTimeController,
                          _endTime,
                          (date) {
                            setState(() {
                              _endTime = date!;
                              _endTimeController.text =
                                  DateFormat('dd/MM/yyyy').format(_endTime);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateWorkingprocess,
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
                                    'Are you sure you want to delete this workingprocess?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Đóng dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Đóng dialog
                                      _deleteWorkingprocess(); // Thực hiện xóa
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
        ),
      ),
    );
  }
}
