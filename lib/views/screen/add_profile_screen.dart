import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:provider/provider.dart';

class AddProfilePage extends StatefulWidget {
  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _profileNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _identifiNumController = TextEditingController();
  final _idLicenseDayController = TextEditingController();
  final _nationController = TextEditingController();
  final _temporaryAddressController = TextEditingController();
  final _currentAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  
  DateTime _birthday = DateTime.now();
  DateTime _idLicenseDay = DateTime.now();
  int _permission = 0;
  bool _gender = false; // Assuming `false` is Male, `true` is Female

  @override
  void dispose() {
    _profileNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _birthdayController.dispose();
    _placeOfBirthController.dispose();
    _identifiNumController.dispose();
    _idLicenseDayController.dispose();
    _nationController.dispose();
    _temporaryAddressController.dispose();
    _currentAddressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newProfile = Profiles(
        profileName: _profileNameController.text,
        profileStatus: 1,
        phone: _phoneController.text,
        email: _emailController.text,
        departmentId: _departmentController.text,
        birthday: _birthday,
        temporary_address: _temporaryAddressController.text,
        current_address: _currentAddressController.text,
        identifiNum: _identifiNumController.text,
        idLicenseDay: _idLicenseDay,
        password: _passwordController.text,
        place_of_birth: _placeOfBirthController.text,
        nation: _nationController.text,
        permission: _permission,
        gender: _gender,
      );

      Provider.of<ProfilesViewModel>(context, listen: false)
          .addProfile(newProfile)
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

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: true,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.primaryLightColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B258A),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add Employment',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFEFF8FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bodyChildren: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildTextField(_profileNameController, 'Tên nhân viên',
                      'Please enter profile name'),
                  _buildDateField('Ngày sinh', _birthdayController, _birthday,
                      (date) {
                    setState(() {
                      _birthday = date;
                      _birthdayController.text =
                          "${_birthday.toLocal()}".split(' ')[0];
                    });
                  }),
                  _buildDropdownField('Chọn giới tính', _gender, (value) {
                    setState(() {
                      _gender = value!;
                    });
                  }),
                  _buildTextField(_placeOfBirthController, 'Nơi Sinh',
                      'Please enter place of birth'),
                  _buildTextField(_identifiNumController, 'Căn Cước Công Dân',
                      'Please enter identification number'),
                  _buildDateField(
                      'Ngày cấp cccd', _idLicenseDayController, _idLicenseDay,
                      (date) {
                    setState(() {
                      _idLicenseDay = date;
                      _idLicenseDayController.text =
                          "${_idLicenseDay.toLocal()}".split(' ')[0];
                    });
                  }),
                  _buildTextField(
                      _nationController, 'Quê Quán', 'Please enter nation'),
                  _buildTextField(_temporaryAddressController, 'Tạm trú',
                      'Please enter temporary address'),
                  _buildTextField(_currentAddressController, 'Thường trú',
                      'Please enter current address'),
                  _buildTextField(_phoneController, 'Số Điện Thoại',
                      'Please enter phone number',
                      keyboardType: TextInputType.number),
                  _buildTextField(
                      _emailController, 'Email', 'Please enter email'),
                  _buildTextField(_departmentController, 'Công ty',
                      'Please enter department'),
                  _buildTextField(
                      _passwordController, 'Password', 'Please enter password'),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Thêm nhân viên'),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String validationMsg,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? validationMsg : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _selectDate(context, initialDate, onDateSelected),
        child: AbsorbPointer(
          child: TextFormField(
            style: TextStyle(color: Colors.black),
            controller: controller,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, bool currentValue, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<bool>(
        value: currentValue,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: [
          DropdownMenuItem(value: false, child: Text('Nam')),
          DropdownMenuItem(value: true, child: Text('Nữ')),
        ],
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }
}
