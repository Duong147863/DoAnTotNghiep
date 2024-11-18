import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/insurance_model.dart';
import 'package:nloffice_hrm/view_models/insurance_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoInsuranceScreen extends StatefulWidget {
  final Insurance? insurance;
  const InfoInsuranceScreen({super.key, this.insurance});

  @override
  State<InfoInsuranceScreen> createState() => _InfoInsuranceScreenState();
}

class _InfoInsuranceScreenState extends State<InfoInsuranceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _insuranceTypeNameController = TextEditingController();
  final _insurancePercentController = TextEditingController();
  final _insuranceIdController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _startTimeController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
   bool _isEditing = false;
  void initState() {
    super.initState();
    _profileIDController.text = widget.insurance!.profileId;
    _insuranceIdController.text=widget.insurance!.insuranceId;
    _insuranceTypeNameController.text=widget.insurance!.insuranceTypeName;
    _insurancePercentController.text=widget.insurance!.insurancePercent.toString();
    _startTimeController.text=DateFormat('dd/MM/yyyy').format(widget.insurance!.startTime).toString();
    _endTimeController.text=DateFormat('dd/MM/yyyy').format(widget.insurance!.endTime).toString(); 
  }

  @override
  double _parseDouble(String value) {
    if (value.isEmpty) return 0.0; // Nếu rỗng thì trả về giá trị mặc định
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0; // Nếu lỗi chuyển đổi, trả về giá trị mặc định
    }
  }
   void _updateInsurance() async {
    if (_formKey.currentState!.validate()) {
      final updatedInsurance = Insurance(
          profileId: _profileIDController.text,
          insuranceId: _insuranceIdController.text,
          insuranceTypeName: _insuranceTypeNameController.text,
          insurancePercent: _parseDouble(_insurancePercentController.text),
          startTime: _startTime,
          endTime: _endTime);

      try {
        await Provider.of<InsuranceViewModel>(context, listen: false)
            .updateInsurances(updatedInsurance);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Insurance Updated successfully!')),
        );
        Navigator.pop(context, updatedInsurance);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Insurance: $e')),
        );
      }
    }
  }

  void _deleteDiploma() async {
    try {
      await Provider.of<InsuranceViewModel>(context, listen: false)
          .deleteInsurances(widget.insurance!.insuranceId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insurance deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Insurance: $e')),
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
      onTap:_isEditing? () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _startTime = selectedDate;
        });
      }):null,
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
      onTap:_isEditing? () => _selectDate(context, initialDate, onDateSelected):null,
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

  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Info Insurance Screen',
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
                    textEditingController: _insuranceIdController,
                    labelText: 'Insurance ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_Insurance_ID';
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
                    textEditingController: _insuranceTypeNameController,
                    labelText: 'Insurance Type Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_insurance_type_name';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _insurancePercentController,
                    labelText: 'Insurance Percent',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_insurance_percent';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateInsurance,
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
                                    'Are you sure you want to delete this insurance?'),
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
                                      _deleteDiploma();
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
