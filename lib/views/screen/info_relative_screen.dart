import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_provinces.dart';
import 'package:nloffice_hrm/views/screen/add_relative_screen.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'list_relationships.dart';

class InfoRelativeScreen extends StatefulWidget {
  final Relatives profile;
  final Function(int) onDelete;
  const InfoRelativeScreen({
    required this.profile,
    required this.onDelete,
  });

  @override
  _InfoRelativeScreenState createState() => _InfoRelativeScreenState();
}

class _InfoRelativeScreenState extends State<InfoRelativeScreen> {
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
  final idrelativeController = TextEditingController();
  bool _isEditing = false;
  List<Relatives> relatives = [];
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
  void initState() {
    super.initState();
    _profileIDController.text = widget.profile.profileId;
    _relativeNameController.text = widget.profile.relativesName;
    _phoneRelativeController.text = widget.profile.relativesPhone;
    _birthdayRelativeController.text = DateFormat('dd/MM/yyyy')
        .format(widget.profile.relativesBirthday)
        .toString();
    _birthdayRelative = widget.profile.relativesBirthday;
    _nationRelativeController.text = widget.profile.relativesNation;
    _temporaryAddressRelativeController.text =
        widget.profile.relativesTempAddress;
    _currentAddressRelativeController.text =
        widget.profile.relativesCurrentAddress;
    _relativeJobController.text = widget.profile.relativeJob;
    _relationshipController.text = widget.profile.relationship;
    _selectecRelationship = widget.profile.relationship;
    idrelativeController.text = widget.profile.relativeId.toString();
    //focus
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

  void _updateRelatives() async {
    if (_formKey.currentState!.validate()) {
      final updatedRelative = Relatives(
        profileId: _profileIDController.text,
        relativesName: _relativeNameController.text,
        relationship: _relationshipController.text,
        relativesPhone: _phoneRelativeController.text,
        relativesBirthday: _birthdayRelative,
        relativesNation: _nationRelativeController.text,
        relativesTempAddress: _temporaryAddressRelativeController.text,
        relativesCurrentAddress: _currentAddressRelativeController.text,
        relativeJob: _relativeJobController.text,
        relativeId: int.tryParse(idrelativeController.text),
      );
        await Provider.of<RelativesViewModel>(context, listen: false)
          .updateRelatives(updatedRelative, (message) {
        if (message == 'Thân nhân đã được cập nhật thành công.') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context, updatedRelative);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      });
    }
  }

  void _deleteRelative() async {
    try {
      final relativeId = widget.profile.relativeId;
      if (relativeId != null) {
        // Gọi phương thức delete từ ViewModel hoặc API để xóa
        await Provider.of<RelativesViewModel>(context, listen: false)
            .deleteRelative(relativeId);

        // Gọi callback từ màn hình cha để xóa thân nhân trong danh sách
        widget.onDelete(relativeId);
        Navigator.pop(context); // Trở về màn hình trước
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa thân nhân thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Relative ID is null. Cannot delete relative.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Relative: $e')),
      );
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
      titletext: 'Thông tin thân nhân',
      showLeadingAction: true,
      appBarItemColor: AppColor.offWhite,
      backgroundColor: AppColor.primaryLightColor,
      appBarColor: AppColor.primaryLightColor,
      defaultBody: true,
      bodyChildren: [
        Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomTextFormField(
              textEditingController: _relativeNameController,
              labelText: 'Họ tên thân nhân',
              maxLength: 50,
              focusNode: _tenTNFocusNode,
              enabled: _isEditing,
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
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
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
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _selectecRelationship =
                            value; // Cập nhật giá trị được chọn
                        _relationshipController.text =
                            value ?? ""; // Gán vào controller
                      });
                    }
                  : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
            ).px8(),
            SizedBox(height: 16),

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
                    labelText: 'Điện thoại',
                    maxLines: 1,
                    maxLength: 10,
                    enabled: _isEditing,
                    focusNode: _sdtFocusNode,
                    keyboardType: TextInputType.number)
                .px8(),
            SizedBox(height: 16),

            InkWell(
              onTap: _isEditing
                  ? () async {
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
                    }
                  : null,
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
            SizedBox(height: 16),
            _buildDateField(
                'Ngày sinh', _birthdayRelativeController, _birthdayRelative,
                (date) {
              setState(() {
                _birthdayRelative = date;
                _birthdayRelativeController.text =
                    DateFormat('dd/MM/yyyy').format(_birthdayRelative);
              });
            }).px(8),
            SizedBox(height: 16),
            CustomTextFormField(
              textEditingController: _relativeJobController,
              focusNode: _ngheNghiepFocusNode,
              maxLength: 50,
              enabled: _isEditing,
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
            ).px(8),
            SizedBox(height: 16),
            InkWell(
              onTap: _isEditing
                  ? () async {
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
                          _currentAddressRelativeController.text =
                              selectedAddress;
                        });
                      }
                    }
                  : null,
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
              onTap: _isEditing
                  ? () async {
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
                    }
                  : null,
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
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.save,
                  color: const Color.fromARGB(255, 33, 243, 61)),
              onPressed: _updateRelatives,
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
                            Navigator.of(context).pop(); // Đóng dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng dialog
                            _deleteRelative(); // Thực hiện xóa
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
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: _isEditing
            ? () => _selectDate(context, initialDate, onDateSelected)
            : null,
        child: AbsorbPointer(
          child: TextFormField(
            readOnly: true,
            style: TextStyle(color: Colors.black),
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Không được để trống';
              }

              // Sử dụng DateFormat để phân tích chuỗi ngày theo định dạng dd/MM/yyyy
              try {
                DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                DateTime selectedDate =
                    dateFormat.parse(value); // Phân tích ngày
                DateTime oneYearBeforeNow =
                    DateTime.now().subtract(Duration(days: 365));

                if (selectedDate.isAfter(DateTime.now())) {
                  return 'Ngày sinh phải là quá khứ';
                }

                if (selectedDate.isAfter(oneYearBeforeNow)) {
                  return 'Ngày sinh phải ít nhất trước 1 năm so với hiện tại';
                }
              } catch (e) {
                return 'Ngày không hợp lệ (Định dạng: dd/MM/yyyy)';
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
