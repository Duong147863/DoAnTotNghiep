import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class EditDiplomaScreen extends StatefulWidget {
  final Diplomas diploma;

  EditDiplomaScreen({required this.diploma});

  @override
  _EditDiplomaScreenState createState() => _EditDiplomaScreenState();
}

class _EditDiplomaScreenState extends State<EditDiplomaScreen> {
  late TextEditingController profileIdController;
  late TextEditingController diplomaNameController;
  late TextEditingController diplomaIdController;

  @override
  void initState() {
    super.initState();
    diplomaNameController =
        TextEditingController(text: widget.diploma.diplomaName);
    diplomaIdController = TextEditingController(text: widget.diploma.diplomaId);
  }

  @override
  void dispose() {
    profileIdController.dispose();
    diplomaNameController.dispose();
    diplomaIdController.dispose();
    super.dispose();
  }

  void saveDiploma() {
    setState(() {
      widget.diploma.diplomaName = diplomaNameController.text;
      widget.diploma.diplomaId = diplomaIdController.text;
    });
    Navigator.pop(context, widget.diploma);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      defaultBody: true,
      showAppBar: true,
      appBar: AppBar(
        title: Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveDiploma,
          ),
        ],
      ),
      bodyChildren: [
     
      ],
    );
  }
}
