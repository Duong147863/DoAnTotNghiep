import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/view_models/workingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoWorkingprocessHRScreen extends StatefulWidget {
  final WorkingProcesses? workingProcesses;
  const InfoWorkingprocessHRScreen({super.key, this.workingProcesses});

  @override
  State<InfoWorkingprocessHRScreen> createState() =>
      _InfoWorkingprocessHRScreenState();
}

class _InfoWorkingprocessHRScreenState
    extends State<InfoWorkingprocessHRScreen> {
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
  int _statusWorkingprocesses = 0;
  void initState() {
    super.initState();
    _statusWorkingprocesses = widget.workingProcesses!.workingprocessStatus;
    _profileIDController.text = widget.workingProcesses!.profileId;
    _workingprocessIdController.text =
        widget.workingProcesses!.workingprocessId;
    _workplaceNameController.text = widget.workingProcesses!.workplaceName;
    _workingprocessContentController.text =
        widget.workingProcesses!.workingprocessContent!;
    _startTimeController.text =
        DateFormat('dd/MM/yyyy').format(widget.workingProcesses!.startTime).toString();
    _endTimeController.text =
       DateFormat('dd/MM/yyyy').format(widget.workingProcesses!.endTime!).toString();
  }

  void _updateWorkingprocess() async {
    if (_formKey.currentState!.validate()) {
      final updatedWorkingprocess = WorkingProcesses(
          profileId: _profileIDController.text,
          workingprocessId: _workingprocessIdController.text,
          workplaceName: _workplaceNameController.text,
          workingprocessContent: _workingprocessContentController.text,
          startTime: _startTime,
          endTime: _endTimeController.text.isNotEmpty ? _endTime : null,
          workingprocessStatus: _statusWorkingprocesses);
      try {
        await Provider.of<WorkingprocessesViewModel>(context, listen: false)
            .updateWorkingprocess(updatedWorkingprocess);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workingprocess Updated successfully!')),
        );
        Navigator.pop(context, updatedWorkingprocess);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Workingprocess: $e')),
        );
      }
    }
  }

  void _deleteWorkingprocess() async {
    try {
      await Provider.of<WorkingprocessesViewModel>(context, listen: false)
          .deleteWorkingprocess(widget.workingProcesses!.workingprocessId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workingprocess deleted successfully')),
      );
      Navigator.pop(context);
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
          ? () => _selectDate(context, initialDate, onDateSelected)
          : null,
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (controller.text.isNotEmpty) {
              try {
                DateTime selectedEndTime = DateTime.parse(controller.text);
                if (selectedEndTime.isBefore(_startTime) ||
                    selectedEndTime.difference(_startTime).inDays < 30) {
                  return 'End Time phải trong trên 1 tháng kể từ Start Time';
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
      titletext: 'Workingprocesses Info HR Screen',
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                    textEditingController: _workingprocessIdController,
                    labelText: 'workingprocess ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_workingprocess_id';
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
                    textEditingController: _workplaceNameController,
                    labelText: 'workplace name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_workplace_name';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _workingprocessContentController,
                    labelText: 'workingprocess content',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_workingprocess_content';
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
                  SizedBox(height: 16),
                  AppStrings.ROLE_PERMISSIONS
                          .contains('Manage Staffs info only')
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status Workingprocess').px(8),
                            _buildDropdownField('Status Workingprocess',
                                _statusWorkingprocesses, (value) {
                              setState(() {
                                _statusWorkingprocesses = value!;
                              });
                            }).px(8),
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
