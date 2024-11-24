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
  int status = 0; // Mặc định là 0
  @override
  void initState() {
    super.initState();
    _profileIDController.text = widget.profiles!.profileId;
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
      // if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
      //   status = 1;
      // }
      final newWorkingprocess = WorkingProcesses(
          profileId: _profileIDController.text,
          workplaceName: _workplaceNameController.text,
          workingprocessContent: _workingprocessContentController.text,
          startTime: _startTime,
          endTime: _endTimeController.text.isNotEmpty ? _endTime : null,
          // workingprocessStatus: status
          );
      Provider.of<WorkingprocessesViewModel>(context, listen: false)
          .createNewWorkingprocess(newWorkingprocess)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workingprocesses added successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Workingprocesses')),
        );
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
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập ngày bắt đầu';
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
        });
      }),
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
            validator: (value) {
          if (controller.text.isEmpty) {
            return null;
          }
          try {
            DateTime selectedEndTime = DateTime.parse(controller.text);
            if (selectedEndTime.isBefore(_startTime) ||
                selectedEndTime.difference(_startTime).inDays < 30) {
              return 'End Time phải trên 1 tháng kể từ Start Time';
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Add Workingproces Screen',
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
                    textEditingController: _workplaceNameController,
                    labelText: 'workplace name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_workplace_name';
                      }
                      final nameRegex = RegExp(
                          r"^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯàáâãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẵẳặẵÉẾỀỂỆỄêềễệéệëẺỆĩíịỉòỏọụủūýỳỵỷỹ\s]+$");
                      if (!nameRegex.hasMatch(value)) {
                        return 'Không được chứa ký tự đặc biệt';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _workingprocessContentController,
                    labelText: 'workingprocess content',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_workingprocess_content';
                      }
                      final nameRegex = RegExp(
                          r"^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯàáâãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẵẳặẵÉẾỀỂỆỄêềễệéệëẺỆĩíịỉòỏọụủūýỳỵỷỹ\s]+$");
                      if (!nameRegex.hasMatch(value)) {
                        return 'Không được chứa ký tự đặc biệt';
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
                      child: Text('Save'),
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
