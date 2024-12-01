import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/getSalarySlip.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
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
  List<Getsalaryslip> getsalaryslip = [];
  Getsalaryslip? selectedGetsalaryslip;
  void initState() {
    super.initState();
    if (widget.salaries != null) {
      _salaryIDController.text = widget.salaries!.salaryId;
      _salaryCoefficientController.text =
          widget.salaries!.salaryCoefficient.toString();
      _personalTaxController.text = widget.salaries!.personalTax.toString();
      _allowancesController.text = widget.salaries!.allowances.toString();
      _loadSalary();
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

  void _loadSalary() async {
    try {
      await Provider.of<SalariesViewModel>(context, listen: false)
          .getSalaryDetails(widget.salaries!.salaryId);
      getsalaryslip = Provider.of<SalariesViewModel>(context, listen: false)
          .GetsalaryslipList;
      setState(() {
        if (getsalaryslip.isNotEmpty) {
          selectedGetsalaryslip = getsalaryslip.firstWhere(
            (get) => get.salaryId == widget.salaries!.salaryId,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Assignments $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'Thông tin mức lương',
      showLeadingAction: true,
      appBarColor: AppColor.primaryLightColor,
      appBarItemColor: AppColor.offWhite,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  textEditingController: _salaryIDController,
                  labelText: 'Mã lương',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ).px8(),
                SizedBox(height: 16),
                CustomTextFormField(
                  textEditingController: _salaryCoefficientController,
                  labelText: 'Lương cơ bản',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ).px8(),
                SizedBox(height: 16),
                CustomTextFormField(
                  textEditingController: _allowancesController,
                  labelText: 'Phụ cấp',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ).px8(),
                SizedBox(height: 16),
                CustomTextFormField(
                  textEditingController: _personalTaxController,
                  labelText: 'Thuế',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_personal_Tax';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ).px8(),
                _buildSalaryList(),
                SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     IconButton(
                //       icon: Icon(Icons.save,
                //           color: const Color.fromARGB(255, 33, 243, 61)),
                //       onPressed: _updateSalary,
                //     ),
                //     IconButton(
                //       icon: Icon(Icons.edit, color: Colors.blue),
                //       onPressed: () {
                //         setState(() {
                //           _isEditing = true;
                //         });
                //       },
                //     ),
                //     IconButton(
                //       icon: Icon(Icons.delete, color: Colors.red),
                //       onPressed: () {
                //         showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               title: Text('Confirm Delete'),
                //               content: Text(
                //                   'Are you sure you want to delete this position?'),
                //               actions: [
                //                 TextButton(
                //                   onPressed: () {
                //                     Navigator.of(context).pop(); // Đóng dialog
                //                   },
                //                   child: Text('Cancel'),
                //                 ),
                //                 TextButton(
                //                   onPressed: () {
                //                     Navigator.of(context).pop(); // Đóng dialog
                //                     _deleteSalary();
                //                   },
                //                   child: Text('Delete'),
                //                 ),
                //               ],
                //             );
                //           },
                //         );
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalaryList() {
    if (getsalaryslip.isEmpty) {
      return Center(
        child: Text(
          "Không có thông tin lương nhân viên nào",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    }

    return ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            getsalaryslip[index].isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
              isExpanded: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: Text(
                      'Nhân sự hiện đang giữ mức lương',
                      style: TextStyle(fontSize: 16),
                    )
                    // Icon(Icons.monetization_on,
                    //     color: const Color.fromARGB(255, 68, 218, 255)),
                    );
              },
              body: CustomListView(
                dataSet: getsalaryslip,
                itemBuilder: (context, index) {
                  return Card(
                    // elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chi tiết:",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          SizedBox(height: 10),
                          Text(
                              "Tên nhân viên: ${getsalaryslip[index].profileName}",
                              style: TextStyle(fontSize: 16)),
                          Text(
                              "Tên chức vụ: ${getsalaryslip[index].positionName}",
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ))
        ]
        // getsalaryslip.map((process) {
        //   return ExpansionPanel(
        // headerBuilder: (BuildContext context, bool isExpanded) {
        //   return ListTile(
        //     contentPadding:
        //         EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        //     leading: Icon(Icons.monetization_on,
        //         color: const Color.fromARGB(255, 68, 218, 255)),
        //   );
        // },
        //     body: Padding(
        //       padding: const EdgeInsets.all(16.0),
        //       child:
        //     ),
        //     isExpanded: process.isExpanded,
        //   );
        // }).toList(),
        );
  }
}
