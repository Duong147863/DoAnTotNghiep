import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SalaryAddScreen extends StatefulWidget {
  const SalaryAddScreen({super.key});

  @override
  State<SalaryAddScreen> createState() => _SalaryAddScreenState();
}

class _SalaryAddScreenState extends State<SalaryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salaryIDController = TextEditingController();
  final _salaryCoefficientController = TextEditingController();
  final _allowancesController = TextEditingController();
  final _personalTaxController = TextEditingController();
  @override
  void dispose() {
    _salaryIDController.dispose();
    _salaryCoefficientController.dispose();
    _allowancesController.dispose();
    _personalTaxController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newSalary = Salaries(
        salaryId: _salaryIDController.text,
        salaryCoefficient: double.parse(_salaryCoefficientController.text),
        allowances: double.parse(_allowancesController.text),
        personalTax: double.parse(_personalTaxController.text),
      );
      Provider.of<SalariesViewModel>(context, listen: false)
          .addSalary(newSalary)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile added successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add profile: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Add Salary Screen'.tr(),
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
                    labelText: 'salary_id'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_salary_id'.tr();
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _salaryCoefficientController,
                    labelText: 'Salary_coefficient'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_Salary_coefficient'.tr();
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _allowancesController,
                    labelText: 'allowances'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_allowances'.tr();
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _personalTaxController,
                    labelText: 'personal_Tax'.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_personal_Tax'.tr();
                      }
                      return null;
                    },
                  ).px8(),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _submit,
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
