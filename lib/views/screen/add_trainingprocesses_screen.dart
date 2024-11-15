import 'package:flutter/material.dart';
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
  final _trainingprocessesIdController = TextEditingController();
  final _trainingprocessesNameController = TextEditingController();
  final _trainingprocessesContentController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  int status = 0; // Mặc định là 0
  void initState() {
    super.initState();
    _profileIDController.text = widget.profiles!.profileId;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
        status = 1;
      }
      final newTrainingprocesses = Trainingprocesses(
          profileId: _profileIDController.text,
          trainingprocessesId: _trainingprocessesIdController.text,
          trainingprocessesName: _trainingprocessesNameController.text,
          trainingprocessesContent: _trainingprocessesContentController.text,
          startTime: _startTime,
          endTime: _endTimeController.text.isNotEmpty ? _endTime : null,
          trainingprocessesStatus: status);
      Provider.of<TrainingprocessesViewModel>(context, listen: false)
          .createTrainingProcesses(newTrainingprocesses)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trainingprocesses added successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Trainingprocesses: $error')),
        );
      });
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
      onTap: () => _selectDate(context, initialDate, onDateSelected),
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
      titletext: 'Add TrainingProcesses Screen',
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
