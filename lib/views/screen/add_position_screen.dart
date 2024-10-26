import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class AddPositionScreen extends StatefulWidget {
  @override
  _AddPositionScreenState createState() => _AddPositionScreenState();
}

class _AddPositionScreenState extends State<AddPositionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _positionIdController = TextEditingController();
  final _positionNameController = TextEditingController();
  final _enterpriseIdController = TextEditingController();

  @override
  void dispose() {
    _positionIdController.dispose();
    _positionNameController.dispose();
    _enterpriseIdController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newPosition = Positions(
        positionId: _positionIdController.text,
        positionName: _positionNameController.text,
      );
      Provider.of<PositionsViewModel>(context, listen: false)
          .addNewPosition(newPosition)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Position added successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add position: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBar: AppBar(
        title: Text('add_new_position'.tr()),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextFormField(
                  textEditingController: _positionIdController,
                  labelText: 'position_id'.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_position_id'.tr();
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextFormField(
                  textEditingController: _positionNameController,
                  labelText: 'position_name'.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_position_name'.tr();
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text('add_new_position'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
