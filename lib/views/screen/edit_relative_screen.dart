import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/model/relatives/relatives_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class EditRelativeScreen extends StatefulWidget {
  final Relatives relative;

  EditRelativeScreen({required this.relative});

  @override
  _EditRelativeScreenState createState() => _EditRelativeScreenState();
}

class _EditRelativeScreenState extends State<EditRelativeScreen> {
  late TextEditingController relativesNameController;
  late TextEditingController relativesPhoneController;
  late TextEditingController relativesBirthdayController;

  @override
  void initState() {
    super.initState();
    relativesNameController =
        TextEditingController(text: widget.relative.relativesName);
    relativesPhoneController =
        TextEditingController(text: widget.relative.relativesPhone);
    //  relativesBirthdayController =
    //     TextEditingController(text: widget.relative.relativesBirthday);
    relativesBirthdayController = TextEditingController(
    text: widget.relative.relativesBirthday != null
        ? DateFormat('dd/MM/yyyy').format(widget.relative.relativesBirthday!)
        : ''
);
  }

  @override
  void dispose() {
    relativesNameController.dispose();
    relativesPhoneController.dispose();
    relativesBirthdayController.dispose();
    super.dispose();
  }
  void saveRelative() {
    setState(() {
      widget.relative.relativesName = relativesNameController.text;
      widget.relative.relativesPhone = relativesPhoneController.text;
      // widget.relative.relativesBirthday = relativesBirthdayController.text;
      widget.relative.relativesBirthday = DateTime.tryParse(relativesBirthdayController.text);
    });
    Navigator.pop(context, widget.relative);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBar: AppBar(
        title: Text('Thân nhân'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveRelative,
          ),
        ],
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
                              controller: relativesNameController,
                              scrollPadding: EdgeInsets.only(bottom: 150),
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Tên thân nhân',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: relativesPhoneController,
                              scrollPadding: EdgeInsets.only(bottom: 150),
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Số điện thoại',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: relativesBirthdayController,
                              scrollPadding: EdgeInsets.only(bottom: 150),
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                labelText: 'Ngày sinh',
                                border: OutlineInputBorder(
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
              ],
            ),
          ),
        );
      }),
    );
  }
}
