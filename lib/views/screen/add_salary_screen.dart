import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        salaryCoefficient: _parseDouble(_salaryCoefficientController.text),
        allowances: _parseDouble(_allowancesController.text),
        personalTax: _parseDouble(_personalTaxController.text),
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
      titletext: 'Add Salary Screen',
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
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _salaryCoefficientController,
                    labelText: 'Salary_coefficient',
                    keyboardType: TextInputType.number, // Hiển thị bàn phím số
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Chỉ cho phép nhập số
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_Salary_coefficient';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _allowancesController,
                    keyboardType: TextInputType.number, // Hiển thị bàn phím số
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Chỉ cho phép nhập số
                    labelText: 'allowances',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_allowances';
                      }
                      return null;
                    },
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _personalTaxController,
                    keyboardType: TextInputType.number, // Hiển thị bàn phím số
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Chỉ cho phép nhập số
                    labelText: 'personal_Tax',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_personal_Tax';
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

  // Phương thức phụ để xử lý chuyển đổi từ String sang double
  double _parseDouble(String value) {
    if (value.isEmpty) return 0.0; // Nếu rỗng thì trả về giá trị mặc định
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0; // Nếu lỗi chuyển đổi, trả về giá trị mặc định
    }
  }
}
