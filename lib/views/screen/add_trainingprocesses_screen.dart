import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';
import 'package:nloffice_hrm/view_models/trainingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddTrainingprocessesScreen extends StatefulWidget {
  final Profiles? profiles;
  const AddTrainingprocessesScreen({super.key, this.profiles});

  @override
  State<AddTrainingprocessesScreen> createState() =>
      _AddTrainingprocessesScreenState();
}

class _AddTrainingprocessesScreenState
    extends State<AddTrainingprocessesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _trainingprocessesNameController = TextEditingController();
  final _trainingprocessesContentController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime? birthdayEmloyment;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _startFocusNode = FocusNode();
  FocusNode _endFocusNode = FocusNode();
  void initState() {
    super.initState();
    birthdayEmloyment = widget.profiles!.birthday;
    _profileIDController.text = widget.profiles!.profileId;
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newTrainingprocesses = Trainingprocesses(
        profileId: _profileIDController.text,
        trainingprocessesName: _trainingprocessesNameController.text,
        trainingprocessesContent: _trainingprocessesContentController.text,
        startTime: _startTime,
        endTime: _endTimeController.text.isNotEmpty ? _endTime : null,
      );
      // Gọi phương thức createTrainingProcesses
      Provider.of<TrainingprocessesViewModel>(context, listen: false)
          .createTrainingProcesses(newTrainingprocesses, (message) {
        if (message == 'Quá trình đào tạo đã được thêm thành công.') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context, newTrainingprocesses); // Đóng màn hình
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      });
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
              return 'Ngày bắt đầu phải là\nngày trong quá khứ';
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
                return 'Nhân viên phải trên 6\ntuổi tại thời điểm bắt đầu';
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
    DateTime initialDate,
    Function(DateTime?) onDateSelected) {
  return Row(
    children: [
      // Trường nhập ngày với GestureDetector
      Expanded(
        child: GestureDetector(
          onTap: () => _selectDate(
            context,
            initialDate,
            (selectedDate) {
              onDateSelected(selectedDate);
              setState(() {
                _endTime = selectedDate;
                controller.text = selectedDate != null
                    ? DateFormat('dd/MM/yyyy').format(selectedDate)
                    : '';
              });
            },
          ),
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
                    // Kiểm tra ngày có lớn hơn hiện tại hay không
                    if (selectedEndTime.isAfter(DateTime.now())) {
                      return 'Ngày kết thúc\nkhông thể lớn\nhơn ngày hiện tại';
                    }
                    // Kiểm tra khoảng thời gian giữa ngày kết thúc và ngày bắt đầu
                    if (selectedEndTime.isBefore(_startTime) ||
                        selectedEndTime.difference(_startTime).inDays < 30) {
                      return 'Thời gian kết\nthúc phải trên 1\ntháng kể từ\nthời gian bắt đầu';
                    }
                  } catch (e) {
                    return 'Định dạng ngày không hợp lệ';
                  }
                }
                return null; // Không có lỗi
              },
              decoration: InputDecoration(
                labelText: label,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ),
      SizedBox(width: 8), // Khoảng cách giữa TextField và nút xóa
      // Nút xóa
      IconButton(
        onPressed: () {
          setState(() {
            controller.clear(); // Xóa nội dung của TextFormField
         
          });
        },
        icon: Icon(Icons.clear, color: Colors.red),
        tooltip: 'Xóa ngày',
      ),
    ],
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
      titletext: 'Thêm Quá Trình Đạo Tạo',
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
                    textEditingController: _trainingprocessesNameController,
                    labelText: 'Tên quá trình đào tạo',
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
                          r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                      if (!nameRegex.hasMatch(value)) {
                        return 'Tên quá trình đào tạo không hợp lệ. Vui lòng nhập\nđúng định dạng.';
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
                    textEditingController: _trainingprocessesContentController,
                    labelText: 'Nội dung quá trình đào tạo',
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
                          r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s0-9\-/:]+$");
                      if (!nameRegex.hasMatch(value)) {
                        return 'Nội dung không hợp lệ. Vui lòng nhập\nđúng định dạng.';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateStartTime(
                          'Bắt đầu',
                          _startTimeController,
                          _startTime,
                          (date) {
                            setState(() {
                              _startTime = date;
                              // Định dạng ngày theo DD/MM/YYYY
                              _startTimeController.text =
                                  DateFormat('dd/MM/yyyy').format(date);
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDateEndTimeWithClearButton(
                          'Kết thúc',
                          _endTimeController,
                          _endTime,
                          (date) {
                            setState(() {
                              _endTime = date!;
                              // Định dạng ngày theo DD/MM/YYYY
                              _endTimeController.text =
                                  DateFormat('dd/MM/yyyy').format(date);
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
