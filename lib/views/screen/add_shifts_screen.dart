import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/shifts_model.dart';
import 'package:nloffice_hrm/view_models/shifts_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AddShiftsScreen extends StatefulWidget {
  const AddShiftsScreen({super.key});

  @override
  State<AddShiftsScreen> createState() => _AddShiftsScreenState();
}

class _AddShiftsScreenState extends State<AddShiftsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shiftIdController = TextEditingController();
  final _shiftNameControler = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  @override
  void dispose() {
    _shiftIdController.dispose();
    _shiftNameControler.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context,
      TextEditingController controller, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final selectedTime = DateTime(
        // DateTime.now().year,
        // DateTime.now().month,
        // DateTime.now().day,
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newShifts = Shifts(
        shiftId: _shiftIdController.text,
        shiftName: _shiftNameControler.text,
        startTime: DateTime.parse("1970-01-01 ${_startTimeController.text}:00"),
        endTime: DateTime.parse("1970-01-01 ${_endTimeController.text}:00"),
      );
      Provider.of<ShiftsViewModel>(context, listen: false)
          .addShifts(newShifts)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shifts added successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Shifts: $error')),
        );
      });
    }
  }

  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      titletext: "Tạo ca làm",
      appBarColor: AppColor.primaryLightColor,
      showLeadingAction: true,
      appBarItemColor: Colors.white,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.asset("assets/images/addShifts.png"),
              TextFormField(
                controller: _shiftIdController,
                decoration: InputDecoration(
                  labelText: 'Mã ca làm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
              ).py8(),
              TextFormField(
                controller: _shiftNameControler,
                decoration: InputDecoration(
                  labelText: 'Tên ca làm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
              ).py8(),
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(
                  labelText: 'Giờ vào',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _startTimeController, true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
              ).py8(),
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(
                  labelText: 'Giờ ra',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(context, _endTimeController, false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
              ).py8(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Tạo ca'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
