import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_provinces.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'list_relationships.dart';

class AddRelativeScreen extends StatefulWidget {
  final Profiles? profile;

  const AddRelativeScreen({super.key, this.profile});

  @override
  _AddRelativeScreenState createState() => _AddRelativeScreenState();
}

class _AddRelativeScreenState extends State<AddRelativeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _relativeNameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _phoneRelativeController = TextEditingController();
  final _birthdayRelativeController = TextEditingController();
  DateTime _birthdayRelative = DateTime.now();
  final _nationRelativeController = TextEditingController();
  final _temporaryAddressRelativeController = TextEditingController();
  final _currentAddressRelativeController = TextEditingController();
  final _relativeJobController = TextEditingController();
  //
  String? _selectecRelationship;
  FocusNode _tamtruFocusNode = FocusNode();
  FocusNode _thuongtruFocusNode = FocusNode();
  FocusNode _tenTNFocusNode = FocusNode();
  FocusNode _quanheFocusNode = FocusNode();
  FocusNode _sdtFocusNode = FocusNode();
  FocusNode _quequanFocusNode = FocusNode();
  FocusNode _ngaysinhFocusNode = FocusNode();
  FocusNode _ngheNghiepFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    DateTime tuoinhanvien = widget.profile!.birthday;
    _profileIDController.text = widget.profile!.profileId;
    // Focus
    _tamtruFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_tamtruFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _thuongtruFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_thuongtruFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _tenTNFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_tenTNFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _quanheFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_quanheFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _sdtFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_sdtFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _quequanFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_quequanFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _ngaysinhFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_ngaysinhFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _ngheNghiepFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_ngheNghiepFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    _profileIDController.dispose();
    _relativeNameController.dispose();
    _relationshipController.dispose();
    _phoneRelativeController.dispose();
    _birthdayRelativeController.dispose();
    _nationRelativeController.dispose();
    _temporaryAddressRelativeController.dispose();
    _currentAddressRelativeController.dispose();
    super.dispose();
  }

  void _submit()  {
    if (_formKey.currentState!.validate()) {
      final addNewRelative = Relatives(
        profileId: _profileIDController.text,
        relativesName: _relativeNameController.text,
        relationship: _relationshipController.text,
        relativesPhone: _phoneRelativeController.text,
        relativesBirthday: _birthdayRelative,
        relativesNation: _nationRelativeController.text,
        relativesTempAddress: _temporaryAddressRelativeController.text,
        relativesCurrentAddress: _currentAddressRelativeController.text,
        relativeJob: _relativeJobController.text,
      );
          Provider.of<RelativesViewModel>(context, listen: false)
          .addRelative(addNewRelative, (message) {
          if (message == 'Thân nhân đã được thêm thành công.') {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
            Navigator.pop(context,addNewRelative);  // Đóng màn hình
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        });
    
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1960),
      lastDate: DateTime(2100),
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
        defaultBody: false,
        appBarItemColor: AppColor.boneWhite,
        backgroundColor: AppColor.aliceBlue,
        actions: [
          TextButton.icon(
            onPressed: () {
              _submit();
            },
            icon: Icon(
              Icons.save_outlined,
              color: AppColor.boneWhite,
            ),
            label: Text(
              "Lưu",
              style: TextStyle(color: AppColor.boneWhite),
            ),
          )
        ],
        resizeToAvoidBottomInset: true,
        titletext: "Thân nhân",
        appBarColor: AppColor.primaryLightColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              CustomTextFormField(
                textEditingController: _relativeNameController,
                labelText: 'Họ tên thân nhân',
                maxLength: 50,
                focusNode: _tenTNFocusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  // Kiểm tra không có khoảng trắng ở cuối tên
                  if (value.trim() != value) {
                    return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                  }
                  if (value.length < 4) {
                    return 'Họ và Tên phải có ít nhất 4 ký tự';
                  }
                  // Regex kiểm tra ký tự đặc biệt
                  final nameRegex = RegExp(
                      r"^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàảạáâãèéêìíòóôõùúủũuụĂĐĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặÈÉẺẼẸÊềếểễnệjiíìỉĩịÒÓỎÕỌôỒỐỔỖỘơỜỚỞỠỢÙÚỦŨỤƯưừứửữựýỳỷỹỵạọấầẩẫậ\s]+$");
                  if (!nameRegex.hasMatch(value)) {
                    return 'Họ và Tên không hợp lệ. Vui lòng nhập đúng định dạng.';
                  }
                  // Kiểm tra và chuyển chữ cái đầu tiên của mỗi từ thành chữ hoa
                  List<String> words = value.split(" ");
                  for (int i = 0; i < words.length; i++) {
                    // Chuyển chữ cái đầu tiên của mỗi từ thành chữ hoa
                    words[i] = words[i].substring(0, 1).toUpperCase() +
                        words[i].substring(1).toLowerCase();
                  }
                  String capitalizedName = words.join(" ");

                  // Kiểm tra xem tên có đúng định dạng hay không (chữ cái đầu tiên mỗi từ viết hoa)
                  if (value != capitalizedName) {
                    return 'Chữ cái đầu tiên của mỗi từ phải viết hoa. Ví dụ: Nguyễn Bình Dương';
                  }

                  if (!value.isLetter()) {
                    return 'Tên chỉ gồm chữ';
                  }
                  return null;
                },
              ).p8(),
              //relationship + relativephone
              Row(
                children: [
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectecRelationship,
                    focusNode: _quanheFocusNode,
                    items: relationships.map((relat) {
                      return DropdownMenuItem(
                        value: relat,
                        child: Text(relat),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Quan hệ',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectecRelationship =
                            value; // Cập nhật giá trị được chọn
                        _relationshipController.text =
                            value ?? ""; // Gán vào controller
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ).px8().w(160),
                  _buildDateField('Ngày sinh', _birthdayRelativeController,
                      _birthdayRelative, (date) {
                    setState(() {
                      _birthdayRelative = date;
                      _birthdayRelativeController.text =
                          "${_birthdayRelative.toLocal()}".split(' ')[0];
                    });
                  }).px(8).w(250),
                ],
              ),
              CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Không được để trống';
                        }
                        if (value.length != 10) {
                          return 'Số điện thoại không hợp lệ';
                        }
                        if (!value.startsWith('0')) {
                          return 'Số điện thoại phải \n bắt đầu bằng số 0';
                        }
                        if (!value.isNumber()) {
                          return 'Số điện thoại chỉ gồm số';
                        }
                        if (value.startsWith('00')) {
                          return 'Số điện thoại không được bắt đầu bằng 00';
                        }
                        return null;
                      },
                      textEditingController: _phoneRelativeController,
                      labelText: 'Điện thoại liên lạc',
                      maxLines: 1,
                      maxLength: 10,
                      focusNode: _sdtFocusNode,
                      keyboardType: TextInputType.number)
                  .px8(),
              InkWell(
                onTap: () async {
                  // Điều hướng đến trang AddProvinces và nhận dữ liệu trả về
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProvinces(),
                    ),
                  );

                  if (selectedAddress != null) {
                    setState(() {
                      // Cập nhật TextEditingController với địa chỉ được chọn
                      _nationRelativeController.text = selectedAddress;
                    });
                  }
                },
                child: AbsorbPointer(
                  // Ngăn không cho bàn phím mở ra khi nhấn
                  child: CustomTextFormField(
                    focusNode: _quequanFocusNode,
                    textEditingController: _nationRelativeController,
                    labelText: 'Quê quán',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ),
                ),
              ).p(8),
              //Phone
              CustomTextFormField(
                textEditingController: _relativeJobController,
                focusNode: _ngheNghiepFocusNode,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  // Kiểm tra không có khoảng trắng ở cuối tên
                  if (value.trim() != value) {
                    return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                  }
                  if (value.length < 3) {
                    return 'Nghề nghiệp phải có ít nhất 3 ký tự';
                  }
                  // Regex kiểm tra ký tự đặc biệt
                  final nameRegex = RegExp(
                      r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                  if (!nameRegex.hasMatch(value)) {
                    return 'Nghề nghiệp không hợp lệ. Vui lòng nhập đúng định dạng.';
                  }
                  if (!value.isLetter()) {
                    return 'Tên chỉ gồm chữ';
                  }
                  return null;
                },
                labelText: 'Nghề nghiệp',
              ).p8(),
              //Address
              InkWell(
                onTap: () async {
                  // Điều hướng đến trang AddProvinces và nhận dữ liệu trả về
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProvinces(),
                    ),
                  );

                  if (selectedAddress != null) {
                    setState(() {
                      // Cập nhật TextEditingController với địa chỉ được chọn
                      _currentAddressRelativeController.text = selectedAddress;
                    });
                  }
                },
                child: AbsorbPointer(
                  // Ngăn không cho bàn phím mở ra khi nhấn
                  child: CustomTextFormField(
                    focusNode: _thuongtruFocusNode,
                    textEditingController: _currentAddressRelativeController,
                    labelText: 'Địa chỉ thường trú',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ),
                ),
              ).p8(),

              //Tạm trú
              InkWell(
                onTap: () async {
                  // Điều hướng đến trang AddProvinces và nhận dữ liệu trả về
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProvinces(),
                    ),
                  );

                  if (selectedAddress != null) {
                    setState(() {
                      // Cập nhật TextEditingController với địa chỉ được chọn
                      _temporaryAddressRelativeController.text =
                          selectedAddress;
                    });
                  }
                },
                child: AbsorbPointer(
                  // Ngăn không cho bàn phím mở ra khi nhấn
                  child: CustomTextFormField(
                    focusNode: _tamtruFocusNode,
                    textEditingController: _temporaryAddressRelativeController,
                    labelText: 'Địa chỉ tạm trú',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ),
                ),
              ).p8(),
            ]),
          ),
        ));
  }

  Widget _buildDateField(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _selectDate(context, initialDate, onDateSelected),
        child: AbsorbPointer(
          child: TextFormField(
            readOnly: true,
            style: TextStyle(color: Colors.black),
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Không được để trống';
              }
              DateTime selectedDate = DateTime.parse(value);
              DateTime oneYearBeforeNow =
                  DateTime.now().subtract(Duration(days: 365));

              if (selectedDate.isAfter(DateTime.now())) {
                return 'Ngày sinh phải là quá khứ';
              }

              if (selectedDate.isAfter(oneYearBeforeNow)) {
                return 'Ngày sinh phải ít nhất trước 1 năm so với hiện tại';
              }
              return null;
            },
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
}
