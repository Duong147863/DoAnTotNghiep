import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/view_models/workingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddWorkingprocesScreen extends StatefulWidget {
  final Profiles? profiles;
  const AddWorkingprocesScreen({super.key, this.profiles});

  @override
  State<AddWorkingprocesScreen> createState() => _AddWorkingprocesScreenState();
}

class _AddWorkingprocesScreenState extends State<AddWorkingprocesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _workplaceNameController = TextEditingController();
  final _workingprocessContentController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  DateTime? birthdayEmloyment;
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _startFocusNode = FocusNode();
  FocusNode _endFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _profileIDController.text = widget.profiles!.profileId;
    birthdayEmloyment = widget.profiles!.birthday;
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
      final newWorkingprocess = WorkingProcesses(
        profileId: _profileIDController.text,
        workplaceName: _workplaceNameController.text,
        workingprocessContent: _workingprocessContentController.text,
        startTime: _startTime,
        endTime: _endTimeController.text.isNotEmpty ? _endTime : null,
      );
      Provider.of<WorkingprocessesViewModel>(context, listen: false)
          .createNewWorkingprocess(newWorkingprocess, (message) {
        if (message == 'Quá trình công tác đã được thêm thành công.') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context, newWorkingprocess); // Đóng màn hình
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      });
    }
  }

  Widget _buildDateStartTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _startTime = selectedDate;
          // Định dạng ngày theo DD/MM/YYYY và gán vào controller
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
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

  Widget _buildDateEndTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _endTime = selectedDate;
          // Định dạng ngày theo DD/MM/YYYY và gán vào controller
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          focusNode: _endFocusNode,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              try {
                DateTime selectedEndTime =
                    DateFormat('dd/MM/yyyy').parse(value);
                // Kiểm tra xem ngày có trong quá khứ hay không
                if (selectedEndTime.isAfter(DateTime.now())) {
                  return 'Ngày kết thúc không thể lớn hơn ngày hiện tại';
                }
                // Nếu ngày kết thúc sớm hơn ngày bắt đầu hoặc chênh lệch nhỏ hơn 30 ngày, thì không hợp lệ
                if (selectedEndTime.isBefore(_startTime) ||
                    selectedEndTime.difference(_startTime).inDays < 30) {
                  return 'End Time phải trong trên 1 tháng kể từ Start Time';
                }
              } catch (e) {
                return 'Định dạng ngày không hợp lệ';
              }
            }
            // Nếu không nhập ngày, cho phép để trống
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      resizeToAvoidBottomInset: true,
      appBarColor: AppColor.primaryLightColor,
      titletext: 'Thêm Quá Trình Công Tác',
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
                        return 'Tên quá trình đào tạo không hợp lệ. Vui lòng nhập đúng định dạng.';
                      }
                      if (!value.isLetter()) {
                        return 'Tên quá trình đào tạo chỉ gồm chữ';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
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
                                  "${_startTime.toLocal()}".split(' ')[0];
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDateEndTime(
                          'End Time',
                          _endTimeController,
                          _endTime,
                          (date) {
                            setState(() {
                              _endTime = date;
                              _endTimeController.text =
                                  "${_endTime.toLocal()}".split(' ')[0];
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text('Lưu'),
                    ),
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
