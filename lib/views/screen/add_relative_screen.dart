import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class AddRelativeScreen extends StatefulWidget {
  final Function(Relatives) onAddRelative;

  AddRelativeScreen({required this.onAddRelative});

  @override
  _AddRelativeScreenState createState() => _AddRelativeScreenState();
}

class _AddRelativeScreenState extends State<AddRelativeScreen> {
  late TextEditingController relativesNameController;
  late TextEditingController relativesPhoneController;
  late TextEditingController relativesBirthdayController;

  @override
  void initState() {
    super.initState();
    relativesNameController = TextEditingController();
    relativesPhoneController = TextEditingController();
    relativesBirthdayController = TextEditingController();
  }

  @override
  void dispose() {
    relativesNameController.dispose();
    relativesPhoneController.dispose();
    relativesBirthdayController.dispose();
    super.dispose();
  }

  // void addRelative() {
  //   final newRelative = Relatives(
  //     relativesName: relativesNameController.text,
  //     relativesPhone: relativesPhoneController.text,
  //     relativesBirthday: relativesBirthdayController.text,
  //   );
  //   widget.onAddRelative(newRelative);
  //   Navigator.pop(context);
  // }
  void addRelative() {
  // Chuyển đổi chuỗi thành DateTime
  DateTime? birthday;
  if (relativesBirthdayController.text.isNotEmpty) {
    birthday = DateTime.tryParse(relativesBirthdayController.text);
    if (birthday == null) {
      // Xử lý khi chuyển đổi không thành công (ví dụ: hiển thị thông báo lỗi)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ngày sinh không hợp lệ')),
      );
      return; // Ngừng thực hiện nếu ngày sinh không hợp lệ
    }
  }

  // final newRelative = Relatives(
  //   relativesName: relativesNameController.text,
  //   relativesPhone: relativesPhoneController.text,
  //   relativesBirthday: birthday, // Gán giá trị đã chuyển đổi
  // );
  
  // widget.onAddRelative(newRelative);
  // Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBar: AppBar(
        title: const Text('Thêm thân nhân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: addRelative,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: relativesNameController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Tên thân nhân',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: relativesPhoneController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: relativesBirthdayController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Ngày sinh',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
