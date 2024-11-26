import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/view_models/diplomas_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/list_diploman_type.dart';
import 'package:nloffice_hrm/views/screen/list_major.dart';
import 'package:nloffice_hrm/views/screen/list_rank.dart';
import 'package:nloffice_hrm/views/screen/list_school1.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'list_type_training.dart';
class InfoDiplomaScreen extends StatefulWidget {
  final Diplomas? diplomas;
  final Function(String) onDelete;
  const InfoDiplomaScreen({super.key, this.diplomas,required this.onDelete});

  @override
  _InfoDiplomaScreenState createState() => _InfoDiplomaScreenState();
}

class _InfoDiplomaScreenState extends State<InfoDiplomaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diplomaIDController = TextEditingController();
  final _diplomaDegreeNameController = TextEditingController();
  final _modeOfStudyController = TextEditingController();
  final _rankingController = TextEditingController();
  final _liscenseDateController = TextEditingController();
  final _majorController = TextEditingController();
  final _grantedByController = TextEditingController();
  final _diplomaTypeController = TextEditingController();
  final _profileIDController = TextEditingController();
  DateTime _liscenseDate = DateTime.now();
  bool _isEditing = false;
  bool isImagePickerActive = false;
  String? _diplomaImageBase64;
  List<String> filteredItems = universityNames1;
  //
   String? _selectecRanking;
  String? _selectecDiplomanType;
  String? _selectecTypeTraining;
  String? _selectecSchool;
  String? _selectecMajor;
  //
    FocusNode _mabangcapFocusNode = FocusNode();
  FocusNode _tenbangcapFocusNode = FocusNode();
  FocusNode _loaitrainingFocusNode = FocusNode();
  FocusNode _xeploaiFocusNode = FocusNode();
  FocusNode _capboiFocusNode = FocusNode();
  FocusNode _ngaycapFocusNode = FocusNode();
  FocusNode _loaibangcapFocusNode = FocusNode();
  FocusNode _nghanhFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _profileIDController.text = widget.diplomas!.profileId;
    _diplomaIDController.text = widget.diplomas!.diplomaId;
    _diplomaDegreeNameController.text = widget.diplomas!.diplomaName;
    _diplomaImageBase64 = widget.diplomas!.diplomaImage;
    _modeOfStudyController.text = widget.diplomas!.modeOfStudy;
    _selectecRanking=widget.diplomas!.ranking;
    _selectecDiplomanType=widget.diplomas!.diplomaType;
    _selectecMajor=widget.diplomas!.major;
    _selectecTypeTraining=widget.diplomas!.modeOfStudy;
    _selectecSchool=widget.diplomas!.grantedBy;
    _liscenseDateController.text = DateFormat('dd/MM/yyyy')
        .format(widget.diplomas!.licenseDate)
        .toString();
    _liscenseDate = widget.diplomas!.licenseDate;
    _majorController.text = widget.diplomas!.major!;
    _rankingController.text = widget.diplomas!.ranking;
    _grantedByController.text = widget.diplomas!.grantedBy;
    _diplomaTypeController.text = widget.diplomas!.diplomaType;
     _mabangcapFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_mabangcapFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _tenbangcapFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_tenbangcapFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _loaitrainingFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_loaitrainingFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _xeploaiFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_xeploaiFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _capboiFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_capboiFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _ngaycapFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_ngaycapFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _loaibangcapFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_loaibangcapFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _nghanhFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_nghanhFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  void _updateDiploma() async {
    if (_formKey.currentState!.validate()) {
      final updatedDiplomas = Diplomas(
          diplomaId: _diplomaIDController.text,
          diplomaName: _diplomaDegreeNameController.text,
          diplomaImage: _diplomaImageBase64 ?? "",
          modeOfStudy: _modeOfStudyController.text,
          ranking: _rankingController.text,
          licenseDate: _liscenseDate,
          major: _majorController.text,
          grantedBy: _grantedByController.text,
          diplomaType: _diplomaTypeController.text,
          profileId: _profileIDController.text);

      try {
        await Provider.of<DiplomasViewModel>(context, listen: false)
            .updateDiplomas(updatedDiplomas,(message){
                 ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
            });
      } catch (e) {
         await Provider.of<DiplomasViewModel>(context, listen: false)
            .updateDiplomas(updatedDiplomas,(message){
                 ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
            });
      }
    }
  }

  void _deleteDiploma() async {
    try {
      await Provider.of<DiplomasViewModel>(context, listen: false)
          .deleteDiplomas(widget.diplomas!.diplomaId);
            // Gọi callback từ màn hình cha để xóa thân nhân trong danh sách
        widget.onDelete(widget.diplomas!.diplomaId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa bằng cấp thành công')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete position: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    if (isImagePickerActive) {
      return;
    }

    try {
      isImagePickerActive = true;

      final ImagePicker picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (imageFile != null) {
        File file = File(imageFile.path);
        String base64String = await AppStrings.ImagetoBase64(file);
        setState(() {
          _diplomaImageBase64 = base64String;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $error')),
      );
    } finally {
      isImagePickerActive = false;
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

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      resizeToAvoidBottomInset: true,
      titletext: "Info Diploma Screen",
      appBarColor: AppColor.primaryLightColor,
      actions: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isEditing = true; // Chuyển đổi chế độ chỉnh sửa
            });
          },
          icon: Icon(
            Icons.edit,
            color: AppColor.boneWhite,
          ),
          label: Text(
            "Sửa",
            style: TextStyle(color: AppColor.boneWhite),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            _updateDiploma();
          },
          icon: Icon(
            Icons.save,
            color: AppColor.boneWhite,
          ),
          label: Text(
            "Save",
            style: TextStyle(color: AppColor.boneWhite),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Delete'),
                  content:
                      Text('Are you sure you want to delete this diploma?'),
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
                        _deleteDiploma(); // Thực hiện xóa
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: Container(
                  width: 400, // Chiều rộng của ảnh
                  height: 400, // Chiều cao của ảnh
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Màu nền mặc định
                    image: _diplomaImageBase64 != null
                        ? DecorationImage(
                            image:
                                MemoryImage(base64Decode(_diplomaImageBase64!)),
                            fit: BoxFit.cover,
                            onError: (error, stackTrace) {
                              print("Error loading image: $error");
                            },
                          )
                        : (widget.diplomas!.diplomaImage != null &&
                                widget.diplomas!.diplomaImage.isNotEmpty)
                            ? DecorationImage(
                                image: MemoryImage(base64Decode(
                                    widget.diplomas!.diplomaImage)),
                                fit: BoxFit.cover,
                                onError: (error, stackTrace) {
                                  print("Error loading image: $error");
                                },
                              )
                            : null, // Không có ảnh thì không cần decoration image
                  ),
                  child: _diplomaImageBase64 == null &&
                          (widget.diplomas!.diplomaImage == null ||
                              widget.diplomas!.diplomaImage.isEmpty)
                      ? Icon(Icons.person,
                          size: 30,
                          color: Colors.grey) // Hiển thị icon khi không có ảnh
                      : null, // Khi có ảnh, không hiển thị icon
                ),
              ),
              Divider(),
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _diplomaIDController,
                    maxLength: 10,
                    enabled: false,
                    focusNode: _mabangcapFocusNode,
                    labelText: 'Mã bằng - chứng chỉ',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      } else if (value.length > 10) {
                        return 'Mã bằng cấp không được vượt quá 10 ký tự';
                      } else if (!value.startsWith('BC-')) {
                        return 'Mã bằng cấp phải bắt đầu bằng "BC-"';
                      } else if (!RegExp(r'^BC-\d+$').hasMatch(value)) {
                        return 'Sau "BC-" phải là các số, ví dụ: BC-001';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  CustomTextFormField(
                    enabled: _isEditing,
                    textEditingController: _diplomaDegreeNameController,
                    maxLength: 150,
                    focusNode: _tenbangcapFocusNode,
                    labelText: 'Tên bằng cấp - chứng chỉ',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      // Kiểm tra không có khoảng trắng ở cuối tên
                      if (value.trim() != value) {
                        return 'Không được có khoảng trắng thừa ở đầu hoặc cuối';
                      }
                      if (value.length < 4) {
                        return 'Tên bằng cấp phải có ít nhất 4 ký tự';
                      }
                      String upperCaseName = value.toUpperCase();
                      if (value != upperCaseName) {
                        return 'Văn bản phải viết hoa hoàn toàn. Ví dụ: BẰNG CỬ NHÂN';
                      }
                      // Regex kiểm tra ký tự tiếng Việt in hoa và khoảng trắng
                      final nameRegex = RegExp(
                          r"^[A-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯẮẰẲẴẶẤẦẨẪẬẸẺẼỀỀỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ]+(\s[A-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠƯẮẰẲẴẶẤẦẨẪẬẸẺẼỀỀỂỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ]+)*$");
                      if (!nameRegex.hasMatch(value)) {
                        return 'Tên bằng cấp không hợp lệ. Vui lòng nhập đúng định dạng.';
                      }

                      if (!value.isLetter()) {
                        return 'Tên chỉ gồm chữ';
                      }
                      return null;
                    },
                  ).w(229),
                ],
              ).py16(),
              DropdownButtonFormField<String>(
                value: _selectecSchool,
                focusNode: _capboiFocusNode,  
                isExpanded: true,
                items: filteredItems.map((relat) {
                  return DropdownMenuItem(
                    value: relat,
                    child: Text(relat,style: TextStyle(fontSize: 13),),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Được cấp bởi',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed:_isEditing? () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate1(
                          universityNames1,
                          (selectedItem) {
                            setState(() {
                              _selectecSchool = selectedItem;
                              _grantedByController.text =
                                  selectedItem; // Cập nhật controller
                            });
                          },
                        ),
                      );
                    }:null,
                  ),
                ),
                onChanged:_isEditing? (value) {
                  setState(() {
                    _selectecSchool = value;
                    _grantedByController.text = value ?? "";
                  });
                }:null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
              ).px8(),
              Row(
                children: [
                  DropdownButtonFormField<String>(
                     isExpanded: true,
                    value: _selectecTypeTraining,
                    focusNode: _loaitrainingFocusNode,
                    items: typeTraining.map((relat) {
                      return DropdownMenuItem(
                        value: relat,
                        child: Text(relat,style: TextStyle(fontSize: 13),),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Giáo dục chính quy',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:_isEditing? (value) {
                      setState(() {
                        _selectecTypeTraining =
                            value; // Cập nhật giá trị được chọn
                        _modeOfStudyController.text =
                            value ?? ""; // Gán vào controller
                      });
                    }:null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  DropdownButtonFormField<String>(
                     isExpanded: true,
                    value: _selectecMajor,
                    focusNode: _nghanhFocusNode,
                    items: majors.map((relat) {
                      return DropdownMenuItem(
                        value: relat,
                        child: Text(relat),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Ngành học',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:_isEditing? (value) {
                      setState(() {
                        _selectecMajor = value; // Cập nhật giá trị được chọn
                        _majorController.text =
                            value ?? ""; // Gán vào controller
                      });
                    }:null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ).w(229),
                ],
              ).py16(),
              Row(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectecDiplomanType,
                    focusNode: _loaibangcapFocusNode,
                    items: diplomantype.map((relat) {
                      return DropdownMenuItem(
                        value: relat,
                        child: Text(relat),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Loại bằng cấp',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:_isEditing? (value) {
                      setState(() {
                        _selectecDiplomanType =
                            value; // Cập nhật giá trị được chọn
                        _diplomaTypeController.text =
                            value ?? ""; // Gán vào controller
                      });
                    }:null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  CustomTextFormField(
                    enabled: false,
                    textEditingController: _profileIDController,
                    labelText: 'Profile ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_profile_id';
                      }
                      return null;
                    },
                  ).w(229),
                ],
              ).py16(),
              _buildDateField(
                  'Ngày Cấp', _liscenseDateController, _liscenseDate, (date) {
                setState(() {
                  _liscenseDate = date;
                  _liscenseDateController.text =
                      "${_liscenseDate.toLocal()}".split(' ')[0];
                });
              }).px(8).w(150),
              DropdownButtonFormField<String>(
                value: _selectecRanking,
                focusNode: _xeploaiFocusNode,
                items: ranking.map((relat) {
                  return DropdownMenuItem(
                    value: relat,
                    child: Text(relat),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Xếp loại',
                  border: OutlineInputBorder(),
                ),
                onChanged:_isEditing? (value) {
                  setState(() {
                    _selectecRanking = value; // Cập nhật giá trị được chọn
                    _rankingController.text = value ?? ""; // Gán vào controller
                  });
                }:null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
              ).px8().w(150),
              SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }
}
class CustomSearchDelegate1 extends SearchDelegate<String> {
  final List<String> items;
  final Function(String) onSelectItem; // Thêm callback để cập nhật giá trị

  CustomSearchDelegate1(this.items, this.onSelectItem);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = items
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: results.map((item) {
        return ListTile(
          title: Text(item),
          onTap: () {
            onSelectItem(item); // Cập nhật giá trị vào controller
            close(context, item); // Đóng màn hình tìm kiếm và trả kết quả
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = items
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: results.map((item) {
        return ListTile(
          title: Text(item),
          onTap: () {
            onSelectItem(item); // Cập nhật giá trị vào controller
            close(context, item); // Đóng màn hình tìm kiếm và trả kết quả
          },
        );
      }).toList(),
    );
  }
}
