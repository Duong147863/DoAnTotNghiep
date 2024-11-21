import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddLaborContractScreen extends StatefulWidget {
  const AddLaborContractScreen({super.key});

  @override
  State<AddLaborContractScreen> createState() => _AddLaborContractScreenState();
}

class _AddLaborContractScreenState extends State<AddLaborContractScreen> {
  final _formKey = GlobalKey<FormState>();
  final _laborContractIDController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _enterpriseController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  List<Departments> departments = [];
  Departments? selectedDepartment;
  Enterprises? enterprises;
  Enterprises? selectedEnterprises;
  String? _laborContractImageBase64;
  @override
  void initState() {
    super.initState();
    _loadDepartments();
    _loadEnterpriseID();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (imageFile != null) {
      File file = File(imageFile.path);
      String base64String = await AppStrings.ImagetoBase64(file);
      setState(() {
        _laborContractImageBase64 = base64String;
      });
    }
  }

  void _loadDepartments() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .fetchAllDepartments();
      setState(() {
        departments = Provider.of<DeparmentsViewModel>(context, listen: false)
            .listDepartments;
      });
    } catch (error) {
      print('Error loading departments: $error');
    }
  }

  void _loadEnterpriseID() async {
    try {
      await Provider.of<EnterprisesViewModel>(context, listen: false)
          .fetchAllEnterprises();
      enterprises =
          Provider.of<EnterprisesViewModel>(context, listen: false).enterprises;
      setState(() {});
    } catch (error) {
      print('Error loading enterprises: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load enterprises')),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newLaborContact = LaborContracts(
        laborContractId: _laborContractIDController.text,
        startTime: _startTime,
        endTime: _endTimeController.text.isNotEmpty
            ? _endTime
            : null, // Nếu End Time trống, truyền null
        enterpriseId: 0,
        image: _laborContractImageBase64 ?? "",
        departmentId: selectedDepartment!.departmentID,
      );
      Provider.of<LaborContactsViewModel>(context, listen: false)
          .addNewLaborContact(newLaborContact)
          .then((_) {
        Navigator.pop(context,newLaborContact);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo thành công!')),
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBarColor: AppColor.primaryLightColor,
      titletext: 'Tạo hợp đồng lao động',
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          image: _laborContractImageBase64 != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                      base64Decode(_laborContractImageBase64!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _laborContractImageBase64 == null
                            ? Icon(Icons.add_a_photo, size: 50)
                            : null,
                      ),
                    ),
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _laborContractIDController,
                    labelText: 'Mã hợp đồng',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_labor_contract_id';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     Text('Enterprises').px8(),
                  //     Expanded(
                  //         child: _buildEnterprisesTextFormField(
                  //             'Choose Enterprises')),
                  //   ],
                  // ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Phòng').px8(),
                      Expanded(
                          child: _buildDepartmentDropdown('Choose Department')),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateStartTime(
                          'Thời hạn hợp đồng từ:',
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
                          'Đến',
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
                      onPressed: () {
                        _submit();
                      },
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

  Widget _buildDateStartTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _startTime = selectedDate; // Cập nhật lại _startTime khi chọn
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
            // Không cần kiểm tra endTime nếu nó để trống
            if (controller.text.isNotEmpty) {
              try {
                DateTime selectedEndTime = DateTime.parse(controller.text);

                // Kiểm tra nếu End Time nằm trong vòng một tháng từ Start Time
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

  Widget _buildDepartmentDropdown(String hint) {
    return DropdownButtonFormField<Departments>(
      value: selectedDepartment,
      hint: Text(hint),
      onChanged: (Departments? newValue) {
        setState(() {
          selectedDepartment = newValue;
        });
      },
      items: departments.map((Departments department) {
        return DropdownMenuItem<Departments>(
          value: department,
          child: Text(department.departmentName),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null) {
          return 'Vui lòng chọn phòng ban';
        }
        return null;
      },
    );
  }

  Widget _buildEnterprisesTextFormField(String hint) {
    return TextFormField(
      controller: _enterpriseController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () async {},
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an enterprise';
        }
        return null;
      },
    );
  }
}
