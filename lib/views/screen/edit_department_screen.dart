import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class EditDepartmentScreen extends StatefulWidget {
  final Departments department;

  EditDepartmentScreen({required this.department});

  @override
  _EditDepartmentScreenState createState() => _EditDepartmentScreenState();
}

class _EditDepartmentScreenState extends State<EditDepartmentScreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  bool status = false;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.department.departmentName);
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void saveDepartment() {
    setState(() {
      widget.department.departmentName = nameController.text;
    });
    Navigator.pop(context, widget.department);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBar: AppBar(
        title: const Text('Thông tin'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Form(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: nameController,
                              scrollPadding: const EdgeInsets.only(bottom: 150),
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                labelText: 'Tên',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: saveDepartment,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    minimumSize: const Size(
                        double.infinity, 50), // Make the button span full width
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
