import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoSalariScreen extends StatefulWidget {
  final Salaries? salaries;
  const InfoSalariScreen({super.key, this.salaries});

  @override
  State<InfoSalariScreen> createState() => _InfoSalariScreenState();
}

class _InfoSalariScreenState extends State<InfoSalariScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salaryIDController = TextEditingController();
  final _salaryCoefficientController = TextEditingController();
  final _allowancesController = TextEditingController();
  final _personalTaxController = TextEditingController();
  bool _isEditing = false;
  void initState() {
    super.initState();
    if (widget.salaries != null) {
      _salaryIDController.text = widget.salaries!.salaryId;
      _salaryCoefficientController.text =
          widget.salaries!.salaryCoefficient.toString();
      _personalTaxController.text = widget.salaries!.personalTax.toString();
      _allowancesController.text = widget.salaries!.allowances.toString();
    }
  }

  void _updateSalary() async {
    if (_formKey.currentState!.validate()) {
      final updatedSalary = Salaries(
        salaryId: _salaryIDController.text,
        salaryCoefficient: double.parse(_salaryCoefficientController.text),
        allowances: double.parse(_allowancesController.text),
        personalTax: double.parse(_personalTaxController.text),
      );
      try {
        await Provider.of<SalariesViewModel>(context, listen: false)
            .updateSalary(updatedSalary);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department Updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Department: $e')),
        );
      }
    }
  }
    void _deleteSalary() async {
    try {
      await Provider.of<SalariesViewModel>(context, listen: false)
          .deleteSalary(widget.salaries!.salaryId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Salary deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Salary: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Info Salary Screen',
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
                  CustomTextFormField(
                    textEditingController: _salaryIDController,
                    labelText: 'salary_id',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_salary_id';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _salaryCoefficientController,
                    labelText: 'Salary_coefficient',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_Salary_coefficient';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _allowancesController,
                    labelText: 'allowances',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_allowances';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _personalTaxController,
                    labelText: 'personal_Tax',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_personal_Tax';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateSalary,
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
                                    'Are you sure you want to delete this position?'),
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
                                     _deleteSalary();
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
