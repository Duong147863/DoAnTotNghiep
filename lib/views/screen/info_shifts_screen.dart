import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/shifts_model.dart';
import 'package:nloffice_hrm/view_models/shifts_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ShiftInfoScreen extends StatefulWidget {
  final Shifts? shifts;
  const ShiftInfoScreen({super.key, this.shifts});

  @override
  State<ShiftInfoScreen> createState() => _ShiftInfoScreenState();
}

class _ShiftInfoScreenState extends State<ShiftInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shiftIdController = TextEditingController();
  final _shiftNameControler = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _shiftIdController.text = widget.shifts!.shiftId;
    _shiftNameControler.text = widget.shifts!.shiftName;
    _startTimeController.text =
        DateFormat('HH:mm').format(widget.shifts!.startTime);
    _endTimeController.text =
        DateFormat('HH:mm').format(widget.shifts!.endTime);
    _startTime=widget.shifts!.startTime;
    _endTime=widget.shifts!.endTime;
  }

  Future<void> _selectTime(BuildContext context,
      TextEditingController controller, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final selectedTime = DateTime(
        pickedTime.hour,
        pickedTime.minute,
      );

      // Đặt thời gian vào biến tương ứng và định dạng đúng khi gán vào TextEditingController
      if (isStartTime) {
        _startTime = selectedTime;
      } else {
        _endTime = selectedTime;
      }

      controller.text =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
    }
  }

  void _updateShifts() async {
    if (_formKey.currentState!.validate()) {
      final parsedStartTime =
          DateFormat("HH:mm").parse(_startTimeController.text);
      final parsedEndTime = DateFormat("HH:mm").parse(_endTimeController.text);
      final updatedShifts = Shifts(
          shiftId: _shiftIdController.text,
          shiftName: _shiftNameControler.text,
          startTime: parsedStartTime,
          endTime: parsedEndTime);
      try {
        await Provider.of<ShiftsViewModel>(context, listen: false)
            .updateShifts(updatedShifts);
        Navigator.pop(context, updatedShifts);
      } catch (e) {}
    }
  }

  void _deleteShifts() async {
    try {
      await Provider.of<ShiftsViewModel>(context, listen: false)
          .deleteShifts(widget.shifts!.shiftId);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Shifts: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titletext: 'Ca làm việc',
        showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      appBarColor: AppColor.primaryLightColor,
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
                    textEditingController: _shiftIdController,
                    labelText: 'Mã ca làm việc',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_shift_id';
                      }
                      return null;
                    },
                    enabled: false,
                  ).px8(),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    textEditingController: _shiftNameControler,
                    labelText: 'Tên',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_shift_name';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).py8(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      enabled: _isEditing,
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Bắt đầu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                      onTap: () =>
                          _selectTime(context, _startTimeController, true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select Start Time';
                        }
                        return null;
                      },
                    ).px8(),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      enabled: _isEditing,
                      controller: _endTimeController,
                      decoration: InputDecoration(
                        labelText: 'Kết thúc',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                      onTap: () =>
                          _selectTime(context, _endTimeController, false),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select End Time';
                        }
                        return null;
                      },
                    ).px8(),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateShifts,
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
                                    'Are you sure you want to delete this shifts?'),
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
                                      _deleteShifts(); // Thực hiện xóa
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
