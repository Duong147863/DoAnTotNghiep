import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';
import 'package:nloffice_hrm/view_models/trainingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoTrainingprocessesScreen extends StatefulWidget {
  final Trainingprocesses? trainingprocesses;
  const InfoTrainingprocessesScreen({super.key, this.trainingprocesses});

  @override
  State<InfoTrainingprocessesScreen> createState() =>
      _InfoTrainingprocessesScreenState();
}

class _InfoTrainingprocessesScreenState
    extends State<InfoTrainingprocessesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _trainingprocessesIdController = TextEditingController();
  final _trainingprocessesNameController = TextEditingController();
  final _trainingprocessesContentController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  bool _isEditing = false;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  int _statusTrainingProcesses = 0;
  @override
  void initState() {
    super.initState();
    _profileIDController.text = widget.trainingprocesses!.profileId;
    _trainingprocessesIdController.text =
        widget.trainingprocesses!.trainingprocessesId!;
    _trainingprocessesNameController.text =
        widget.trainingprocesses!.trainingprocessesName;
    _trainingprocessesContentController.text =
        widget.trainingprocesses!.trainingprocessesContent;
    _startTimeController.text = DateFormat('dd/MM/yyyy')
        .format(widget.trainingprocesses!.startTime)
        .toString();
    _endTimeController.text = DateFormat('dd/MM/yyyy')
        .format(widget.trainingprocesses!.endTime!)
        .toString();
    _startTime = widget.trainingprocesses!.startTime;
    _endTime = widget.trainingprocesses!.endTime!;
  }

  void _updateTrainingProcesses() async {
    
    if (_formKey.currentState!.validate()) {
        if (!AppStrings.ROLE_PERMISSIONS.containsAny(['Manage Staffs info only', 'Manage BoD & HR accounts'])) {
          _statusTrainingProcesses = 0; // Gán 0 nếu không có quyền
      } 
      final updateTrainingProcesses = Trainingprocesses(
          profileId: _profileIDController.text,
          trainingprocessesId: _trainingprocessesIdController.text,
          trainingprocessesName: _trainingprocessesNameController.text,
          trainingprocessesContent: _trainingprocessesContentController.text,
          startTime: _startTime,
          endTime: _endTimeController.text.isNotEmpty ? _endTime : null,
      );
      try {
        await Provider.of<TrainingprocessesViewModel>(context, listen: false)
            .updateTrainingProcesses(updateTrainingProcesses);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('TrainingProcesses Updated successfully!')),
        );
        Navigator.pop(context, updateTrainingProcesses);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update TrainingProcesses: $e')),
        );
      }
    }
  }

  void _deleteTrainingProcesses() async {
    try {
      await Provider.of<TrainingprocessesViewModel>(context, listen: false)
          .deleteTrainingProcesses(
              widget.trainingprocesses!.trainingprocessesId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TrainingProcesses deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete TrainingProcesses: $e')),
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

  Widget _buildDateStartTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: _isEditing
          ? () => _selectDate(context, initialDate, (selectedDate) {
                onDateSelected(selectedDate);
                setState(() {
                  _startTime = selectedDate;
                });
              })
          : null,
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
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
    onTap: _isEditing
        ? () => _selectDate(context, initialDate, (selectedDate) {
            onDateSelected(selectedDate);
            setState(() {
              _endTime = selectedDate;
              _endTimeController.text =
                  DateFormat('dd/MM/yyyy').format(_endTime);
            });
          })
        : null,
    child: AbsorbPointer(
      child: TextFormField(
        readOnly: true,
        style: TextStyle(color: Colors.black),
        controller: controller,
        validator: (value) {
          if (controller.text.isNotEmpty) {
            try {
              // Kiểm tra nếu giá trị controller.text có thể chuyển đổi thành DateTime
              DateTime selectedEndTime = DateFormat('dd/MM/yyyy')
                  .parseStrict(controller.text); // Chuyển đổi ngày theo định dạng 'dd/MM/yyyy'

              // Kiểm tra xem selectedEndTime có phải sau _startTime ít nhất 30 ngày không
              if (selectedEndTime.isBefore(_startTime)) {
                return 'End Time phải sau Start Time';
              }

              // Kiểm tra sự khác biệt giữa selectedEndTime và _startTime phải lớn hơn 30 ngày
              if (selectedEndTime.difference(_startTime).inDays <= 30) {
                return 'End Time phải lớn hơn 30 ngày kể từ Start Time';
              }
            } catch (e) {
              return 'Định dạng ngày không hợp lệ';
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
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Thông tin quá trình đào tạo',
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
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
                    textEditingController: _trainingprocessesIdController,
                    labelText: 'trainingprocesses ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_trainingprocesses_id';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: false,
                    textEditingController: _profileIDController,
                    labelText: 'profile ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_profile_ID';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _trainingprocessesNameController,
                    labelText: 'trainingprocesses name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_trainingprocesses_name';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _trainingprocessesContentController,
                    labelText: 'trainingprocesses content',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_trainingprocesses_content';
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
                        child: _buildDateEndTime(
                          'End Time',
                          _endTimeController,
                          _endTime,
                          (date) {
                            setState(() {
                              _endTime = date;
                              _endTimeController.text =
                                  DateFormat('dd/MM/yyyy').format(_endTime);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  AppStrings.ROLE_PERMISSIONS
                          .containsAny(['Manage Staffs info only', 'Manage BoD & HR accounts'])
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status TrainingProcesses').px(8),
                            _buildDropdownField(
                              'Status Status TrainingProcesses',
                              _statusTrainingProcesses,
                              (value) {
                                setState(() {
                                  _statusTrainingProcesses = value!;
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
                        onPressed: _updateTrainingProcesses,
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
                                    'Are you sure you want to delete this trainingprocesses?'),
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
                                      _deleteTrainingProcesses(); // Thực hiện xóa
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
            value == null ? 'Please select a Trạng thái' : null,
      ),
    );
  }
}
