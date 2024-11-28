import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/screen/add_labor_contract_one_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class InfoLaborcontractScreen extends StatefulWidget {
  final LaborContracts? laborContracts;
  final Profiles? profiles;
  const InfoLaborcontractScreen(
      {super.key, this.laborContracts, this.profiles});

  @override
  State<InfoLaborcontractScreen> createState() =>
      _InfoLaborcontractScreenState();
}

class _InfoLaborcontractScreenState extends State<InfoLaborcontractScreen> {
  final _formKey = GlobalKey<FormState>();
  final _laborContractIDController = TextEditingController();
  final _startTimeHopDongController = TextEditingController();
  final _endTimeHopDongController = TextEditingController();
  final _profileNameController = TextEditingController();
  DateTime _startTimeHopDong = DateTime.now();
  DateTime _endTimeHopDong = DateTime.now();
  DateTime endTimeThuViec = DateTime.now();
  String? _laborContractImageBase64;
  String? profileId;
  int? statusProfile;
  bool _isEditing = false;
  FocusNode _mahdFocusNode = FocusNode();
  FocusNode _starttimeFocusNode = FocusNode();
  FocusNode _endtimeFocusNode = FocusNode();
   List<LaborContracts> laborContracts = [];
  LaborContracts? selectedlaborContracts;
  void initState() {
    super.initState();
    profileId = widget.laborContracts!.profiles;
    _profileNameController.text = widget.profiles!.profileName;
    statusProfile = widget.profiles!.profileStatus;
    endTimeThuViec = widget.profiles!.endTime!;
    //
    _laborContractIDController.text = widget.laborContracts!.laborContractId;
    _startTimeHopDongController.text = DateFormat('dd/MM/yyyy')
        .format(widget.laborContracts!.startTime)
        .toString();
    _startTimeHopDong = widget.laborContracts!.startTime;
    _endTimeHopDongController.text = DateFormat('dd/MM/yyyy')
        .format(widget.laborContracts!.endTime!)
        .toString();
    _endTimeHopDong = widget.laborContracts!.endTime!;
    _laborContractImageBase64 = widget.laborContracts!.image;
    // Focus
    _mahdFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_mahdFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _starttimeFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_starttimeFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus

    _endtimeFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_endtimeFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  void _updateLaborContract() async {
    if (_formKey.currentState!.validate()) {
      final updatedLaborContract = LaborContracts(
        laborContractId: _laborContractIDController.text,
        startTime: _startTimeHopDong,
        endTime: _endTimeHopDong,
        profiles: profileId!,
        image: _laborContractImageBase64 ?? "",
      );
      await Provider.of<LaborContactsViewModel>(context, listen: false)
          .updateLaborContact(updatedLaborContract, (message) {
        if (message == 'Hợp đồng đã được cập nhật thành công.') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context, updatedLaborContract);
          Navigator.pop(context, updatedLaborContract);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      });
    }
  }

  Future<void> _pickImage() async {
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
        _laborContractImageBase64 = base64String;
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
      titletext: 'Cập Nhật Hợp Đồng',
      showAppBar: true,
      showLeadingAction: true,
      defaultBody: false,
      appBarItemColor: AppColor.boneWhite,
      backgroundColor: AppColor.aliceBlue,
      resizeToAvoidBottomInset: true,
      appBarColor: AppColor.primaryLightColor,
      body: SingleChildScrollView(
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          image: _laborContractImageBase64 != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                      base64Decode(_laborContractImageBase64!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _laborContractImageBase64 == null
                            ? Icon(Icons.add_a_photo, size: 50)
                            : null,
                      ),
                    ),
                  ).px8(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      CustomTextFormField(
                        focusNode: _mahdFocusNode,
                        enabled: false,
                        textEditingController: _laborContractIDController,
                        labelText: 'Mã hợp đồng',
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống';
                          } else if (value.length > 10) {
                            return 'Mã hợp đồng không được vượt quá 10 ký tự';
                          } else if (!value.startsWith('HD-')) {
                            return 'Mã hợp đồng phải bắt đầu bằng "HD-"';
                          } else if (!RegExp(r'^HD-\d+$').hasMatch(value)) {
                            return 'Sau "HD-" phải là số';
                          }
                          return null;
                        },
                      ).px8().w(150),
                      CustomTextFormField(
                        textEditingController: _profileNameController,
                        labelText: 'Họ và tên',
                        enabled: false,
                        maxLength: 50,
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
                              r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                          if (!nameRegex.hasMatch(value.trim())) {
                            return 'Họ và Tên không được chứa ký tự đặc biệt';
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
                      ).w(200),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateStartTime(
                          'Thời hạn hợp đồng từ:',
                          _startTimeHopDongController,
                          _startTimeHopDong,
                          (date) {
                            setState(() {
                              _startTimeHopDong = date;
                              _startTimeHopDongController.text =
                                  "${_startTimeHopDong.toLocal()}".split(' ')[0];
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDateEndTime(
                          'Đến',
                          _endTimeHopDongController,
                          _endTimeHopDong,
                          (date) {
                            setState(() {
                              _endTimeHopDong = date;
                              _endTimeHopDongController.text =
                                  "${_endTimeHopDong.toLocal()}".split(' ')[0];
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.save,
                            color: const Color.fromARGB(255, 33, 243, 61)),
                        onPressed: _updateLaborContract,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      fab: SpeedDial(
              elevation: 0,
              icon: Icons.menu,
              buttonSize: Size(50, 50),
              children: [
                  SpeedDialChild(
                      label: "Thêm hợp đồng lần 2",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddLaborContractScreenKHD2(
                                laborContracts: widget.laborContracts,
                                profiles: widget.profiles,
                              ),
                            )).then((createNewLaborContract) {
                             if (createNewLaborContract != null) {
                              setState(() {
                                laborContracts.add(createNewLaborContract);
                              });
                            }
                        });
                      }),
                ]),
    );
  }

  Widget _buildDateStartTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
        onTap:_isEditing? () => _selectDate(context, initialDate, (selectedDate) {
          onDateSelected(selectedDate);
          setState(() {
            _startTimeHopDong = selectedDate; // Cập nhật giá trị
            controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
          });
        }):null,
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          focusNode: _starttimeFocusNode,
           validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập ngày bắt đầu hợp đồng';
              }
              try {
                DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(value);

                // Kiểm tra ngày bắt đầu hợp đầu 1 không được trước ngày kết thúc thử việc
                if (selectedDate.isBefore(endTimeThuViec)) {
                  return 'Ngày bắt đầu hợp đồng phải sau ngày ${DateFormat('dd/MM/yyyy').format(endTimeThuViec)}';
                }

                // Kiểm tra ngày không được trong quá khứ
                if (selectedDate.isBefore(DateTime.now())) {
                  return 'Ngày bắt đầu hợp đồng không được trong quá khứ';
                }
              } catch (e) {
                return 'Định dạng ngày không hợp lệ';
              }
              return null;
            },
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Widget _buildDateEndTime(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
       onTap:_isEditing? () => _selectDate(context, initialDate, (selectedDate) {
        onDateSelected(selectedDate);
        setState(() {
          _endTimeHopDong = selectedDate;
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }):null,
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          focusNode: _endtimeFocusNode,
          style: TextStyle(color: Colors.black),
          controller: controller,
          // validator: (value) {
          //   // Nếu giá trị là "Hiện tại", bỏ qua kiểm tra định dạng ngày
          //   if (controller.text == "Hiện tại") {
          //     return null; // Không cần kiểm tra
          //   }

          //   // Nếu có giá trị nhập vào
          //   if (controller.text.isNotEmpty) {
          //     try {
          //       DateTime selectedEndTime = DateTime.parse(controller.text);

          //       // Kiểm tra nếu End Time nằm trong vòng một tháng từ Start Time
          //       if (selectedEndTime.isBefore(_startTimeHopDong) ||
          //           selectedEndTime.difference(_startTimeHopDong).inDays < 30) {
          //         return 'End Time phải trong trên 1 tháng kể từ Start Time';
          //       }
          //     } catch (e) {
          //       return 'Định dạng ngày không hợp lệ';
          //     }
          //   }
          //   return null;
          // },
          validator: (value) {
            // Validator kiểm tra ràng buộc hợp đồng lần 1
            if (value == null || value.isEmpty) {
              return 'Vui lòng chọn ngày kết thúc hợp đồng';
            }
            try {
              DateTime selectedEndTime = DateFormat('dd/MM/yyyy').parse(value);

              // Kiểm tra ngày kết thúc phải sau ngày bắt đầu ít nhất 1 tháng
              if (selectedEndTime.isBefore(_startTimeHopDong.add(Duration(days: 30)))) {
                return 'Ngày kết thúc phải sau ngày bắt đầu ít nhất 1 tháng';
              }

              // Kiểm tra ngày kết thúc không được vượt quá 36 tháng từ ngày bắt đầu
              if (selectedEndTime.isAfter(_startTimeHopDong.add(Duration(days: 36 * 30)))) {
                return 'Ngày kết thúc không được vượt quá 36 tháng kể từ ngày bắt đầu';
              }
            } catch (e) {
              return 'Định dạng ngày không hợp lệ';
            }
            return null; // Hợp lệ
          },
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
