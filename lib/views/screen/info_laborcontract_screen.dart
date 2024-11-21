import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoLaborcontractScreen extends StatefulWidget {
  final LaborContracts? laborContracts;
  const InfoLaborcontractScreen({super.key, this.laborContracts});

  @override
  State<InfoLaborcontractScreen> createState() =>
      _InfoLaborcontractScreenState();
}

class _InfoLaborcontractScreenState extends State<InfoLaborcontractScreen> {
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
  bool _isEditing = false;
  void initState() {
    super.initState();
    _laborContractIDController.text = widget.laborContracts!.laborContractId;
    _startTimeController.text = DateFormat('dd/MM/yyyy').format(widget.laborContracts!.startTime).toString();
    _endTimeController.text = widget.laborContracts!.endTime == null
        ? "Hiện tại"
        : DateFormat('dd/MM/yyyy').format(widget.laborContracts!.endTime!).toString();
    _laborContractImageBase64 = widget.laborContracts!.image;
   Provider.of<DeparmentsViewModel>(context, listen: false)
          .fetchAllDepartments();
     departments = Provider.of<DeparmentsViewModel>(context, listen: false)
            .listDepartments;
        if (departments.isNotEmpty) {
          selectedDepartment = departments.firstWhere(
            (dep) => dep.departmentID == widget.laborContracts!.departmentId,
          );
        }
      Provider.of<EnterprisesViewModel>(context, listen: false)
          .fetchAllEnterprises();
      enterprises =
          Provider.of<EnterprisesViewModel>(context, listen: false).enterprises;
  }

  void _updateLaborContract() async {
    if (_formKey.currentState!.validate()) {
      DateTime? endTimeToUpdate;
      if (_endTimeController.text == "Hiện tại") {
        endTimeToUpdate = null;
      } else {
        endTimeToUpdate =
            _endTime; // Nếu có ngày tháng thì dùng giá trị của _endTime
      }
      final updatedLaborContract = LaborContracts(
          laborContractId: _laborContractIDController.text,
          startTime: _startTime,
          endTime: endTimeToUpdate, 
          enterpriseId: 0,
          image: _laborContractImageBase64 ?? "",
          departmentId: selectedDepartment!.departmentID);

      try {
        await Provider.of<LaborContactsViewModel>(context, listen: false)
            .updateLaborContact(updatedLaborContract);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('LaborContracts Updated successfully!')),
        );
        Navigator.pop(context, updatedLaborContract);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update LaborContracts: $e')),
        );
      }
    }
  }

  void _deleteLaborContract() async {
    try {
      await Provider.of<LaborContactsViewModel>(context, listen: false)
          .deleteLaborContact(widget.laborContracts!.laborContractId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('LaborContracts deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete LaborContracts: $e')),
      );
    }
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
      titletext: 'Sửa hợp đồng lao động',
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
                    enabled: false,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateLaborContract,
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
                                    'Are you sure you want to delete this laborcontact?'),
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
                                      _deleteLaborContract();
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

  Widget _buildDateStartTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: _isEditing
          ? () => _selectDate(context, initialDate, (selectedDate) {
                onDateSelected(selectedDate);
                setState(() {
                  _startTime = selectedDate; // Cập nhật lại _startTime khi chọn
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
          // Nếu giá trị là "Hiện tại", bỏ qua kiểm tra định dạng ngày
          if (controller.text == "Hiện tại") {
            return null; // Không cần kiểm tra
          }

          // Nếu có giá trị nhập vào
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
      onChanged: _isEditing
          ? (Departments? newValue) {
              setState(() {
                selectedDepartment = newValue;
              });
            }
          : null,
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
      onTap: _isEditing ? () async {} : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an enterprise';
        }
        return null;
      },
    );
  }
}
