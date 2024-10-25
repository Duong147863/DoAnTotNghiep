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
  DateTime _birthday = DateTime.now();
  final _birthdayController = TextEditingController();
  final _place_of_birthController = TextEditingController();
  final _identifiNumController = TextEditingController();
  final _idLicenseDayController = TextEditingController();
  DateTime idLicenseDay = DateTime.now();
  final _nationController = TextEditingController();
  final _temporary_address_Controller = TextEditingController();
  final _current_address_Controller = TextEditingController();
  String? _gender;

  @override
  void dispose() {
    _profileNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _birthdayController.dispose();
    _place_of_birthController.dispose();
    _idLicenseDayController.dispose();
    _identifiNumController.dispose();
    _nationController.dispose();
    _temporary_address_Controller.dispose();
    _current_address_Controller.dispose();
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
        temporary_address:_temporary_address_Controller.text ,
        current_address: _current_address_Controller.text,
        identifiNum: _identifiNumController.text,
        idLicenseDay: idLicenseDay 
      );

      Provider.of<ProfilesViewModel>(context, listen: false).addProfile(newProfile).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add profile: $error')));
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _birthday)
      setState(() {
        _birthday = picked;
        _birthdayController.text = "${_birthday.toLocal()}".split(' ')[0];
      });
  }

  Future<void> _selectExpireDay(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: idLicenseDay,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != idLicenseDay)
      setState(() {
        idLicenseDay = picked;
        _idLicenseDayController.text = "${idLicenseDay.toLocal()}".split(' ')[0];
      });
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
            icon:
                Icon(Icons.arrow_back, color: Colors.white), 
            onPressed: () {
              Navigator.pop(context); 
            },
          ),
        ),
        bodyChildren: [
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _profileNameController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Tên nhân viên',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter profile name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: _birthdayController,
                            decoration: InputDecoration(
                              labelText: 'Ngày sinh',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              hintText: "${_birthday.toLocal()}".split(' ')[0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<String>(
                        value: _gender,
                        hint: Text('Chọn giới tính'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text('Nam'),
                            value: 'male',
                          ),
                          DropdownMenuItem(
                            child: Text('Nữ'),
                            value: 'female',
                          ),
                          DropdownMenuItem(
                            child: Text('Khác'),
                            value: 'other',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a gender';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _place_of_birthController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Nơi Sinh',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter place of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      controller: _identifiNumController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Căn Cước Công Dân',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter identification number';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => _selectExpireDay(context),
                        child: AbsorbPointer(
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: _idLicenseDayController,
                            decoration: InputDecoration(
                              labelText: 'Ngày cấp cccd',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              hintText: "${idLicenseDay.toLocal()}".split(' ')[0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _nationController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Quê Quán',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter nation';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _departmentController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Công ty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter department';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _departmentController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Tạm trú',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter department';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Thường trú',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _departmentController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Công ty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter department';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text('Thêm nhân viên'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}


// import 'package:flutter/material.dart';
// import 'package:nloffice_hrm/constant/app_color.dart';
// import 'package:nloffice_hrm/models/profiles_model.dart';
// import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
// import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart'; // Import CustomTextFormField

// class AddProfilePage extends StatefulWidget {
//   @override
//   _AddProfilePageState createState() => _AddProfilePageState();
// }

// class _AddProfilePageState extends State<AddProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _profileNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _departmentController = TextEditingController();
//   DateTime _birthday = DateTime.now();

//   @override
//   void dispose() {
//     _profileNameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _departmentController.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       final newProfile = Profiles(
//         profileName: _profileNameController.text,
//         profileStatus: 1,
//         phone: _phoneController.text,
//         email: _emailController.text,
//         departmentId: _departmentController.text,
//         birthday: _birthday,
//       );

//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BasePage(
//       showAppBar: true,
//       showLeadingAction: true,
//       defaultBody: true,
//       appBarItemColor: AppColor.boneWhite,
//       backgroundColor: AppColor.primaryLightColor,
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0B258A),
//         elevation: 0,
//         automaticallyImplyLeading: true,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Thêm nhân viên',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Color(0xFFEFF8FF),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//       bodyChildren: [
//         Padding(
//           padding: EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   CustomTextFormField(
//                     textEditingController: _profileNameController,
//                     labelText: 'Tên nhân viên',
                    
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Vui lòng nhập tên nhân viên';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 14.0),
//                   CustomTextFormField(
//                     textEditingController: _phoneController,
//                     labelText: 'Số điện thoại',
//                     hintText: 'Nhập số điện thoại',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Vui lòng nhập số điện thoại';
//                       }
//                       return null;
//                     },
//                     keyboardType: TextInputType.phone,
//                   ),
//                   SizedBox(height: 8.0),
//                   CustomTextFormField(
//                     textEditingController: _emailController,
//                     labelText: 'Email',
//                     hintText: 'Nhập email',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Vui lòng nhập email';
//                       }
//                       return null;
//                     },
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   SizedBox(height: 8.0),
//                   CustomTextFormField(
//                     textEditingController: _departmentController,
//                     labelText: 'Công ty',
//                     hintText: 'Nhập tên công ty',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Vui lòng nhập tên công ty';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: _submit,
//                     child: Text('Thêm nhân viên'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
