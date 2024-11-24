import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class PositonInfoScreen extends StatefulWidget {
  final Positions? positions;
  const PositonInfoScreen({super.key, this.positions});

  @override
  State<PositonInfoScreen> createState() => _PositonInfoScreenState();
}

class _PositonInfoScreenState extends State<PositonInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _positionIDController = TextEditingController();
  final _positionNameController = TextEditingController();
  bool _isEditing = false;
  void initState() {
    super.initState();
    _positionIDController.text = widget.positions!.positionId;
    _positionNameController.text = widget.positions!.positionName;
  }

  void _updatePosition() async {
    if (_formKey.currentState!.validate()) {
      final updatedPosition = Positions(
        departmentId: "",
          positionId: _positionIDController.text,
          positionName: _positionNameController.text);
      try {
        await Provider.of<PositionsViewModel>(context, listen: false)
            .updatePosition(updatedPosition);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department Updated successfully!')),
        );
        Navigator.pop(context, updatedPosition);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update Department: $e')),
        );
      }
    }
  }

  void _deletePosition() async {
    try {
      await Provider.of<PositionsViewModel>(context, listen: false)
          .deletePosition(widget.positions!.positionId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Position deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete position: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: 'position_info',
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
                    textEditingController: _positionIDController,
                    labelText: 'position_id',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_position_id';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _positionNameController,
                    labelText: 'position_name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_position_name';
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
                        onPressed: _updatePosition,
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
                                      _deletePosition(); // Thực hiện xóa
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
