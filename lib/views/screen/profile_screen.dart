import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/models/insurance_model.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/models/roles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/diplomas_view_model.dart';
import 'package:nloffice_hrm/view_models/insurance_view_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/view_models/roles_view_models.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/view_models/trainingprocesses_view_model.dart';
import 'package:nloffice_hrm/view_models/workingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';
import 'package:nloffice_hrm/views/screen/add_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/add_insurance_screen.dart';
import 'package:nloffice_hrm/views/screen/add_labor_contract_screen.dart';
import 'package:nloffice_hrm/views/screen/add_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/add_trainingprocesses_screen.dart';
import 'package:nloffice_hrm/views/screen/add_workingprocess_screen.dart';
import 'package:nloffice_hrm/views/screen/info_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/info_insurance_screen.dart';
import 'package:nloffice_hrm/views/screen/info_laborcontract_screen.dart';
import 'package:nloffice_hrm/views/screen/info_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/list_trainingprocesses_screen.dart';
import 'package:nloffice_hrm/views/screen/list_workingprocess_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  final Profiles? profile;
  const ProfileScreen({super.key, this.profile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
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

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileIDController = TextEditingController();
  final _profileNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _identifiNumController = TextEditingController();
  final _idLicenseDayController = TextEditingController();
  final _nationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _temporaryAddressController = TextEditingController();
  final _currentAddressController = TextEditingController();
  DateTime _birthday = DateTime.now();
  DateTime _idLicenseDay = DateTime.now();
  bool _gender = false;
  bool _marriage = false;
  bool _isEditing = false;
  String? _profileImageBase64;
  bool _isButtonEnabled = true;
  //
  List<Departments> departments = [];
  Departments? selectedDepartment;
  List<Positions> positions = [];
  Positions? selectedPositions;
  List<Salaries> salarys = [];
  Salaries? selectedSalarys;
  List<WorkingProcesses> workingProcesses = [];
  WorkingProcesses? selectedWorkingProcesses;
  List<Trainingprocesses> trainingProcess = [];
  Trainingprocesses? selectedtrainingProcess;
  List<Relatives> relatives = [];
  Relatives? selectedRelatives;
  List<Diplomas> diplomas = [];
  Diplomas? selectedDiplomas;
  List<Insurance> insurance = [];
  Insurance? selectedinsurance;
  List<LaborContracts> laborContracts = [];
  LaborContracts? selectedlaborContracts;
  List<Roles> roles = [];
  Roles? selectedRoles;
  //
  void initState() {
    super.initState();
    _profileIDController.text = widget.profile!.profileId;
    _profileNameController.text = widget.profile!.profileName;
    _birthdayController.text =
        DateFormat('dd/MM/yyyy').format(widget.profile!.birthday).toString();
    _placeOfBirthController.text = widget.profile!.placeOfBirth;
    _gender = widget.profile!.gender;
    _identifiNumController.text = widget.profile!.identifiNum;
    _idLicenseDayController.text = DateFormat('dd/MM/yyyy')
        .format(widget.profile!.idLicenseDay)
        .toString();
    _nationController.text = widget.profile!.nation;
    _emailController.text = widget.profile!.email ?? '';
    _phoneController.text = widget.profile!.phone;
    // _passwordController.text = widget.profile!.password;
    _temporaryAddressController.text = widget.profile!.temporaryAddress;
    _currentAddressController.text = widget.profile!.currentAddress;
    _profileImageBase64 = widget.profile!.profileImage;
    _marriage = widget.profile!.marriage;
    _gender = widget.profile!.gender;
    _loadDepartments();
    _loadPositions();
    _loadSalaries();
    _loadworkingProcesses();
    _loadtrainingProcess();
    _loadRelative();
    _loadDiplomas();
    _loadInsurance();
    _loadLaborContact();
    _loadRoles();
  }

  void _handleUpdateRelative(Relatives updatedRelative) {
    setState(() {
      int index = relatives
          .indexWhere((rela) => rela.relativeId == updatedRelative.relativeId);
      if (index != -1) {
        relatives[index] = updatedRelative;
      }
    });
  }

  void _handleUpdateDiplomas(Diplomas updatedDiplomas) {
    setState(() {
      int index = diplomas
          .indexWhere((dip) => dip.diplomaId == updatedDiplomas.diplomaId);
      if (index != -1) {
        diplomas[index] = updatedDiplomas;
      }
    });
  }

  void _handleUpdateInsurance(Insurance updatedInsurance) {
    setState(() {
      int index = insurance
          .indexWhere((ins) => ins.insuranceId == updatedInsurance.insuranceId);
      if (index != -1) {
        insurance[index] = updatedInsurance;
      }
    });
  }

  void _handleUpdateLaborContact(LaborContracts updatelaborContracts) {
    setState(() {
      int index = laborContracts.indexWhere(
          (lab) => lab.laborContractId == updatelaborContracts.laborContractId);
      if (index != -1) {
        laborContracts[index] = updatelaborContracts;
      }
    });
  }

  // Method to load departments
  void _loadDepartments() async {
    try {
      await Provider.of<DeparmentsViewModel>(context, listen: false)
          .fetchAllDepartments();
      departments = Provider.of<DeparmentsViewModel>(context, listen: false)
          .listDepartments;
      if (departments.isNotEmpty) {
        selectedDepartment = departments.firstWhere(
          (department) =>
              department.departmentID == widget.profile!.departmentId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load departments')),
      );
    }
  }

  // Method to load departments
  void _loadPositions() async {
    try {
      await Provider.of<PositionsViewModel>(context, listen: false)
          .fetchPositions();
      positions =
          Provider.of<PositionsViewModel>(context, listen: false).listPositions;
      if (positions.isNotEmpty) {
        selectedPositions = positions.firstWhere(
          (position) => position.positionId == widget.profile!.positionId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Positions')),
      );
    }
  }

  void _loadSalaries() async {
    try {
      await Provider.of<SalariesViewModel>(context, listen: false)
          .fetchAllSalaries();
      salarys =
          Provider.of<SalariesViewModel>(context, listen: false).listSalaries;
      if (salarys.isNotEmpty) {
        selectedSalarys = salarys.firstWhere(
          (salary) => salary.salaryId == widget.profile!.salaryId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load salaries')),
      );
    }
  }

  void _loadRoles() async {
    try {
      await Provider.of<RolesViewModels>(context, listen: false).getAllRoles();
      List<Roles> allRoles =
          Provider.of<RolesViewModels>(context, listen: false).listRoles;
      if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
        roles = allRoles
            .where((role) => [1, 2, 3, 4, 5].contains(role.roleID))
            .toList();
      } else if (AppStrings.ROLE_PERMISSIONS
          .contains('Manage Staffs info only')) {
        roles =
            allRoles.where((role) => [1, 2, 3].contains(role.roleID)).toList();
      } else {
        roles = [];
      }

      setState(() {
        if (roles.isNotEmpty) {
          selectedRoles = roles.firstWhere(
            (rol) => rol.roleID == widget.profile!.roleID,
          );
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Roles $error')),
      );
    }
  }

  void _loadRelative() async {
    try {
      await Provider.of<RelativesViewModel>(context, listen: false)
          .fetchAllRelatives(widget.profile!.profileId);
      relatives =
          Provider.of<RelativesViewModel>(context, listen: false).listRelatives;
      if (relatives.isNotEmpty) {
        selectedRelatives = relatives.firstWhere(
          (rel) => rel.profileId == widget.profile!.profileId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Relative')),
      );
    }
  }

  void _loadworkingProcesses() async {
    try {
      await Provider.of<WorkingprocessesViewModel>(context, listen: false)
          .fetchWorkingProcess(widget.profile!.profileId);
      workingProcesses =
          Provider.of<WorkingprocessesViewModel>(context, listen: false)
              .listWorkingProcess;
      if (workingProcesses.isNotEmpty) {
        selectedWorkingProcesses = workingProcesses.firstWhere(
          (wor) => wor.profileId == widget.profile!.profileId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Workingprocesses')),
      );
    }
  }

  void _loadDiplomas() async {
    try {
      await Provider.of<DiplomasViewModel>(context, listen: false)
          .getDiplomasOf(widget.profile!.profileId);
      diplomas =
          Provider.of<DiplomasViewModel>(context, listen: false).listDiplomas;
      if (diplomas.isNotEmpty) {
        selectedDiplomas = diplomas.firstWhere(
          (dip) => dip.profileId == widget.profile!.profileId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Workingprocesses')),
      );
    }
  }

  void _loadLaborContact() async {
    try {
      await Provider.of<LaborContactsViewModel>(context, listen: false)
          .getLaborContactOf(widget.profile!.laborContractId!);
      laborContracts =
          Provider.of<LaborContactsViewModel>(context, listen: false)
              .listLaborContact;
      if (laborContracts.isNotEmpty) {
        selectedlaborContracts = laborContracts.firstWhere(
          (lab) => lab.laborContractId == widget.profile!.laborContractId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Workingprocesses $error')),
      );
    }
  }

  void _loadtrainingProcess() async {
    try {
      await Provider.of<TrainingprocessesViewModel>(context, listen: false)
          .getTrainingProcessesOf(widget.profile!.profileId);
      trainingProcess =
          Provider.of<TrainingprocessesViewModel>(context, listen: false)
              .listTrainingprocesses;
      if (trainingProcess.isNotEmpty) {
        selectedtrainingProcess = trainingProcess.firstWhere(
          (tra) => tra.profileId == widget.profile!.profileId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load TrainingProcess')),
      );
    }
  }

  void _loadInsurance() async {
    try {
      await Provider.of<InsuranceViewModel>(context, listen: false)
          .getInsurancesOf(widget.profile!.profileId);
      insurance =
          Provider.of<InsuranceViewModel>(context, listen: false).listInsurance;
      if (insurance.isNotEmpty) {
        selectedinsurance = insurance.firstWhere(
          (ins) => ins.profileId == widget.profile!.profileId,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load TrainingProcess')),
      );
    }
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = Profiles(
          profileId: _profileIDController.text,
          profileName: _profileNameController.text,
          birthday: _birthday,
          placeOfBirth: _placeOfBirthController.text,
          gender: _gender,
          identifiNum: _identifiNumController.text,
          idLicenseDay: _idLicenseDay,
          nation: _nationController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          roleID: selectedRoles!.roleID,
          temporaryAddress: _temporaryAddressController.text,
          currentAddress: _currentAddressController.text,
          marriage: _marriage,
          departmentId: selectedDepartment!.departmentID,
          positionId: selectedPositions!.positionId,
          salaryId: selectedSalarys!.salaryId,
          profileImage: _profileImageBase64 ?? '');

      Provider.of<ProfilesViewModel>(context, listen: false)
          .updateProfile(updatedProfile)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Update successfully!')),
        );
        Navigator.pop(context, updatedProfile);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Update profile: $error')),
        );
      });
    }
  }

  void _deleteProfile() async {
    try {
      await Provider.of<ProfilesViewModel>(context, listen: false)
          .deleteProfile(widget.profile!.profileId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Profile): $e')),
      );
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

  Future<void> _pickImage() async {
    try {
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
          _profileImageBase64 = base64String;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Quay lại trang trước đó
          },
        ),
        actions: AppStrings.ROLE_PERMISSIONS.containsAny(
                ['Manage BoD & HR accounts', 'Manage Staffs info only'])
            ? <Widget>[
                IconButton(
                  enableFeedback: true,
                  onPressed: _isButtonEnabled
                      ? () {
                          // Tắt nút sau khi nhấn
                          setState(() {
                            _isEditing = false;
                          });
                          // Thực hiện hành động
                          _updateProfile();
                        }
                      : null, // Nếu nút không được bật, sẽ không thực hiện hành động
                  icon: Icon(Icons.save, color: Colors.red),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true; // Chuyển đổi chế độ chỉnh sửa
                      _isButtonEnabled = true;
                    });
                  },
                  icon: Icon(Icons.edit_outlined, color: Colors.red),
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
                              'Are you sure you want to delete this Profile?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteProfile();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ]
            : [],
      ),
      extendBodyBehindAppBar: false,
      body: ListView(children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _profileImageBase64 != null &&
                          _profileImageBase64!.isNotEmpty
                      ? MemoryImage(base64Decode(_profileImageBase64!))
                      : (widget.profile!.profileImage.isNotEmptyAndNotNull
                          ? MemoryImage(
                              base64Decode(widget.profile!.profileImage!))
                          : AssetImage('assets/images/male_avatar.png')
                              as ImageProvider), // Default avatar
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.dstATop,
                  ),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              alignment: Alignment.center,
              child: UiSpacer.emptySpace(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isEditing
                      ? _pickImage
                      : null, // Cho phép chọn ảnh khi đang ở chế độ chỉnh sửa
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: 250,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: _profileImageBase64 != null
                          ? Image.memory(
                              base64Decode(_profileImageBase64!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print("Error loading image: $error");
                                return Icon(Icons.error,
                                    size: 30, color: Colors.grey);
                              },
                            )
                          : (widget.profile!.profileImage != null &&
                                  widget.profile!.profileImage!.isNotEmpty
                              ? Image.memory(
                                  base64Decode(widget.profile!.profileImage!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Error loading image: $error");
                                    return Icon(Icons.error,
                                        size: 30, color: Colors.grey);
                                  },
                                )
                              : Icon(Icons.person,
                                  size: 30, color: Colors.grey)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile ID + Full name
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _profileIDController,
                    labelText: 'Mã',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                    enabled: false,
                  ).px8().w(150),
                  CustomTextFormField(
                    textEditingController: _profileNameController,
                    labelText: 'Họ và tên',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).w(254),
                ],
              ).py16(),
              // Birthday + Place of birth
              Row(
                children: [
                  _buildDateField('Ngày sinh', _birthdayController, _birthday,
                      (date) {
                    setState(() {
                      _birthday = date;
                      _birthdayController.text =
                          "${_birthday.toLocal()}".split(' ')[0];
                    });
                  }).px(8).w(150),
                  CustomTextFormField(
                    textEditingController: _placeOfBirthController,
                    labelText: 'Nơi sinh',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).w(254),
                ],
              ),
              Row(
                children: [
                  Text('Phòng:').px(8),
                  _buildDepartmentDropdown('Choose Department').p(8).w(300),
                ],
              ),
              Row(
                children: [
                  Text('Chức vụ:').px(8),
                  _buildPositionsDropdown('Choose Postion').p(8).w(300),
                ],
              ),
              Row(
                children: [
                  Text('Lương cơ bản:').px(8),
                  _buildSalaryDropdown('Choose Salary').p(8).w(300),
                ],
              ),
              Row(
                children: [
                  Text('Roles').px(8),
                  _buildRolesDropdown('Choose Roles').p(8).w(300),
                ],
              ),
              // Gender + Marriage
              Row(
                children: [
                  Text('Giới tính').px(8),
                  _buildDropdownField('Chọn giới tính', _gender, (value) {
                    setState(() {
                      _gender = value!;
                    });
                  }).p(8).w(130),
                  //Nation
                  CustomTextFormField(
                    validator: (value) =>
                        value.isEmptyOrNull ? 'Vui lòng quốc tịch' : null,
                    textEditingController: _nationController,
                    labelText: 'Quốc tịch',
                    enabled: _isEditing,
                  ).p(8).w(160),
                ],
              ),
              Row(
                children: [
                  Text('Hôn nhân:'),
                  Radio(
                    value: true,
                    groupValue: _marriage,
                    onChanged: _isEditing
                        ? (value) {
                            setState(() {
                              _marriage = value! as bool;
                            });
                          }
                        : null,
                  ),
                  Text('Đã kết hôn'),
                  Radio(
                    value: false,
                    groupValue: _marriage,
                    onChanged: _isEditing
                        ? (value) {
                            setState(() {
                              _marriage = value! as bool;
                            });
                          }
                        : null,
                  ),
                  Text('Chưa kết hôn'),
                ],
              ),
              // ID number + license day
              Row(
                children: [
                 CustomTextFormField(
                  textEditingController: _identifiNumController,
                  labelText: 'Số CCCD/CMND',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    if (value.length != 12) {
                      return 'Số CCCD/CMND không hợp lệ'; // Thông báo nhập đúng 10 chữ số
                    }
                    if (!value.startsWith('0')) {
                      return 'Số CCCD phải bắt đầu bằng số 0';
                    }
                    return null;
                  },
                ).w(200).px8(),
                  _buildDateField(
                      'id ngày cấp', _idLicenseDayController, _idLicenseDay,
                      (date) {
                    setState(() {
                      _idLicenseDay = date;
                      _idLicenseDayController.text =
                          _idLicenseDay.toString().split(' ').first;
                    });
                  }).w(184),
                ],
              ).py8(),

              //Email + phone
              Row(
                children: [
                  CustomTextFormField(
                    textEditingController: _emailController,
                    labelText: 'Email',
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_email';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'please_enter_valid_email';
                      }
                      return null;
                    },
                    enabled: _isEditing,
                  ).px4().w(258),
                  CustomTextFormField(
                             validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống';
                          }
                          if (value.length != 10) {
                            return 'Số điện thoại không hợp lệ';
                          }
                          if (!value.startsWith('0')) {
                            return 'Số điện thoại phải bắt đầu bằng số 0';
                          }
                          return null;
                        },
                          textEditingController: _phoneController,
                          labelText: 'Số điện thoại',
                          maxLines: 1,
                          enabled: _isEditing,
                          keyboardType: TextInputType.number)
                      .w(145),
                ],
              ).py(8),
              //Address
              CustomTextFormField(
                textEditingController: _temporaryAddressController,
                labelText: 'Địa chỉ tạm trú',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_temp_address';
                  }
                  return null;
                },
                enabled: _isEditing,
              ).p8(),
              CustomTextFormField(
                textEditingController: _currentAddressController,
                labelText: 'Nơi ở hiện tại',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_current_address';
                  }
                  return null;
                },
                enabled: _isEditing,
              ).p8(),
              // Thân nhân
              _buildRelativeList().p8(),
              //WorkingProcess
              _buildWorkingProcessList(),
              // TrainingProcess
              _buildTrainingProcessesList().p8(),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey[200],
                  child: Text(
                    "Bằng Cấp",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildDiplomasList()
              ]),
              //
              SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey[200],
                  child: Text(
                    "Bảo Hiểm",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildInsuranceList(),
                //Hợp đồng
                SizedBox(height: 16),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: Colors.grey[200],
                        child: Text(
                          "Hợp đồng",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildLaborContractList()
                    ]),
              ])
            ],
          ),
        ),
      ]),
      fab: AppStrings.ROLE_PERMISSIONS.containsAny(
              ['Manage BoD & HR accounts', 'Manage Staffs info only'])
          ? SpeedDial(
              elevation: 0,
              icon: Icons.menu,
              buttonSize: Size(50, 50),
              children: [
                  SpeedDialChild(
                      label: "Thêm thân Nhân",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddRelativeScreen(
                                profile: widget.profile,
                              ),
                            )).then((addNewRelative) {
                          if (addNewRelative != null) {
                            setState(() {
                              relatives.add(addNewRelative);
                            });
                          }
                      });
                      }),
                  SpeedDialChild(
                      label: "Phê Duyệt Quá Trình Đạo Tạo",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ListTrainingprocessesScreen(
                                profiles: widget.profile,
                              ),
                            ));
                      }),
                  SpeedDialChild(
                      label: "Phê Duyệt Quá Trình Làm Việc",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ListWorkingprocessScreen(
                                profiles: widget.profile,
                              ),
                            ));
                      }),
                  SpeedDialChild(
                      label: "Thêm bằng cấp",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddDiplomaScreen(
                                profile: widget.profile,
                              ),
                            )).then((createNewDiploma) {
                          if (createNewDiploma != null) {
                            setState(() {
                              diplomas.add(createNewDiploma);
                            });
                          }
                        });
                      }),
                  SpeedDialChild(
                    label: "Bảo hiểm",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddInsuranceScreen(
                                  profiles: widget.profile,
                                )),
                      ).then((newInsurance) {
                        if (newInsurance != null) {
                          setState(() {
                            insurance.add(newInsurance);
                          });
                        }
                      });
                    },
                  )
                ])
          : SpeedDial(
              elevation: 0,
              icon: Icons.menu,
              buttonSize: Size(50, 50),
              children: [
                  SpeedDialChild(
                      label: "Thêm quá trình đào tạo",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  AddTrainingprocessesScreen(
                                profiles: widget.profile,
                              ),
                            ));
                      }),
                  SpeedDialChild(
                      label: "Thêm quá trình công tác",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  AddWorkingprocesScreen(
                                profiles: widget.profile,
                              ),
                            ));
                      }),
                ]),
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
                return 'please_id ngày cấp';
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
        onChanged: _isEditing
            ? onChanged
            : null, // Nếu không cho phép chọn, onChanged = null
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }

  Widget _buildDepartmentDropdown(String hint) {
    return DropdownButtonFormField<Departments>(
      value: selectedDepartment,
      hint: Text(hint),
      onChanged: _isEditing
          ? (Departments? newValue) {
              setState(() {
                selectedDepartment = newValue;
              });
            }
          : null, // Khi không cho phép chọn, onChanged = null
      items: departments.map((Departments department) {
        return DropdownMenuItem<Departments>(
          value: department,
          child: Text(department.departmentName),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabled: _isEditing, // Vô hiệu hóa cả dropdown nếu _isEditing là false
      ),
    );
  }

  Widget _buildPositionsDropdown(String hint) {
    return DropdownButtonFormField<Positions>(
      value: selectedPositions,
      hint: Text(hint),
      onChanged: _isEditing
          ? (Positions? newValue) {
              setState(() {
                selectedPositions = newValue;
              });
            }
          : null,
      items: positions.map((Positions position) {
        return DropdownMenuItem<Positions>(
          value: position,
          child: Text(
              position.positionName), // assuming department has a `name` field
        );
      }).toList(),
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabled: _isEditing),
    );
  }

  Widget _buildSalaryDropdown(String hint) {
    return DropdownButtonFormField<Salaries>(
      value: selectedSalarys,
      hint: Text(hint),
      onChanged: _isEditing
          ? (Salaries? newValue) {
              setState(() {
                selectedSalarys = newValue;
              });
            }
          : null,
      items: salarys.map((Salaries salary) {
        return DropdownMenuItem<Salaries>(
          value: salary,
          child: Text(
              "${salary.salaryId} - ${salary.salaryCoefficient}"), // assuming department has a `name` field
        );
      }).toList(),
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabled: _isEditing),
    );
  }
  //

  Widget _buildRolesDropdown(String hint) {
    return DropdownButtonFormField<Roles>(
      value: selectedRoles,
      hint: Text(hint),
      onChanged: _isEditing
          ? (Roles? newValue) {
              setState(() {
                selectedRoles = newValue;
              });
            }
          : null,
      items: roles.map((Roles role) {
        return DropdownMenuItem<Roles>(
          value: role,
          child: Text(role.roleName),
        );
      }).toList(),
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabled: _isEditing),
    );
  }

  //
  Widget _buildRelativeList() {
    if (relatives.isEmpty) {
      return Center(
        child: Text(
          "Không có thông tin thân nhân",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    }
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.all(0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          relatives[index].isExpanded = isExpanded;
        });
      },
      children: relatives.map((process) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: Icon(Icons.personal_injury,
                  color: const Color.fromARGB(255, 68, 218, 255)),
              title: Text(
                "Thân nhân",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text(
                process.relativesName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text("Quan hệ: ${process.relationship}",
                  style: TextStyle(fontSize: 16)),
              Text("Số điện thoại: ${process.relativesPhone}",
                  style: TextStyle(fontSize: 16)),
              Text("Tạm trú: ${process.relativesTempAddress}",
                  style: TextStyle(fontSize: 16)),
              Text("Thường trú: ${process.relativesCurrentAddress}",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              // Thêm hiệu ứng khi bấm vào để chuyển đến màn hình chi tiết
              Center(
                child: InkWell(
                  onTap: () async {
                    final updatedRelative = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InfoRelativeScreen(profile: process),
                      ),
                    );
                    if (updatedRelative != null) {
                      _handleUpdateRelative(updatedRelative);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Xem chi tiết",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ).px4(),
          isExpanded: process.isExpanded,
        );
      }).toList(),
    );
  }

  //
  Widget _buildDiplomasList() {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.all(0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          diplomas[index].isExpanded = isExpanded;
        });
      },
      children: diplomas.map((process) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: Icon(Icons.school,
                  color: const Color.fromARGB(255, 183, 255, 68)),
              title: Text(
                "Bằng Cấp",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: diplomas.isEmpty
              ? Center(
                  child: Text(
                    "Chưa có thông tin",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () async {
                      final updatediplomas = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InfoDiplomaScreen(diplomas: process),
                        ),
                      );
                      if (updatediplomas != null) {
                        _handleUpdateDiplomas(updatediplomas);
                      }
                    },
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "${process.major}",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text('Loại: ${process.diplomaType}',
                                style: TextStyle(fontSize: 16)),
                            Text('Xếp loại: ${process.ranking}',
                                style: TextStyle(fontSize: 16)),
                            Text('Được cấp bởi: ${process.grantedBy}',
                                style: TextStyle(fontSize: 16)),
                            Text('Hình thức đào tạo: ${process.modeOfStudy}',
                                style: TextStyle(fontSize: 16)),
                            SizedBox(height: 20),
                            Divider(color: Colors.grey),
                            SizedBox(height: 20),
                            Text('Số hiệu: ${process.diplomaId}',
                                style: TextStyle(fontSize: 14)),
                            Text(
                                'Ngày cấp: ${DateFormat('dd/MM/yyyy').format(process.licenseDate).toString()}',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          isExpanded: process.isExpanded,
        );
      }).toList(),
    );
  }

  //
  Widget _buildWorkingProcessList() {
    List<WorkingProcesses> filteredProcesses = workingProcesses
        .where((process) => process.workingprocessStatus == 1)
        .toList();

    if (filteredProcesses.isEmpty) {
      return Center(
        child: Text(
          "Không có thông tin làm việc",
          style: TextStyle(
              fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }
    return ExpansionPanelList(
      elevation: 2,
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          filteredProcesses[index].isExpanded = isExpanded;
        });
      },
      children: filteredProcesses.map((process) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(Icons.work, color: Colors.blueAccent),
              title: Text(
                "Tóm tắt quá trình công tác",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.blue.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nơi làm việc:",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    SizedBox(height: 8),
                    Text("Nội dung: ${process.workingprocessContent}"),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                            "Từ: ${DateFormat('yyyy-MM-dd').format(process.startTime).toString()}"),
                        Text(
                            " - Đến: ${DateFormat('yyyy-MM-dd').format(process.endTime!).toString()}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          isExpanded: process.isExpanded,
        );
      }).toList(),
    );
  }

  //
  Widget _buildTrainingProcessesList() {
    List<Trainingprocesses> filteredProcesses = trainingProcess
        .where((process) => process.trainingprocessesStatus == 1)
        .toList();
    if (filteredProcesses.isEmpty) {
      return Center(
        child: Text(
          "Không có thông tin đào tạo",
          style: TextStyle(
              fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }
    return ExpansionPanelList(
      elevation: 2,
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          filteredProcesses[index].isExpanded = isExpanded;
        });
      },
      children: filteredProcesses.map((process) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(Icons.school, color: Colors.green),
              title: Text(
                "Tóm tắt quá trình đào tạo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.green.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nội dung đào tạo: ${process.trainingprocessesContent}")
                        .p8(),
                    Row(
                      children: [
                        Text(
                            "Bắt đầu từ: ${DateFormat('yyyy-MM-dd').format(process.startTime).toString()}"),
                        Text(process.endTime == null
                            ? "Hiện tại"
                            : "Đến: ${DateFormat('yyyy-MM-dd').format(process.endTime!).toString()}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          isExpanded: process.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _buildInsuranceList() {
    if (insurance.isEmpty) {
      return Center(
        child: Text(
          "Không có thông tin bảo hiểm",
          style: TextStyle(
              fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    return ExpansionPanelList(
      elevation: 2,
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          insurance[index].isExpanded = isExpanded;
        });
      },
      children: insurance.map((process) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(Icons.health_and_safety, color: Colors.green),
              title: Text(
                "Bảo hiểm",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.green.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${process.insuranceTypeName}"),
                    Text("Tỉ lệ: ${process.insurancePercent} %").p8(),
                    Row(
                      children: [
                        Text(
                            "Thời hạn từ: ${DateFormat('yyyy-MM-dd').format(process.startTime).toString()}"),
                        Text(
                            " - Đến: ${DateFormat('yyyy-MM-dd').format(process.endTime).toString()}"),
                      ],
                    ),
                  ],
                ),
              ),
            ).onInkTap(() async {
              final updatedInsurance = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoInsuranceScreen(
                    insurance: process,
                  ),
                ),
              );

              // Kiểm tra xem có dữ liệu cập nhật không
              if (updatedInsurance != null) {
                _handleUpdateInsurance(updatedInsurance);
              }
            }),
          ),
          isExpanded: process.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _buildLaborContractList() {
    if (laborContracts.isEmpty) {
      return Center(
        child: Text(
          "Không có thông tin hợp đồng nào",
          style: TextStyle(
              fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }
    return ExpansionPanelList(
      elevation: 2,
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          laborContracts[index].isExpanded = isExpanded;
        });
      },
      children: laborContracts.map((process) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(Icons.school, color: Colors.green),
              title: Text(
                "Tóm tắt hợp đồng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.green.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20, // Tăng kích thước cho ảnh lớn hơn
                      backgroundColor:
                          Colors.green.shade100, // Màu nền nhạt hơn
                      child: ClipOval(
                        child: SizedBox(
                          width: 70, // Kích thước ảnh
                          height: 70,
                          child: process.image.isNotEmptyAndNotNull
                              ? Image.memory(
                                  base64Decode(process.image),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      size: 30,
                                      color: Colors
                                          .redAccent, // Icon lỗi nổi bật hơn
                                    );
                                  },
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Không có ảnh",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                            "Bắt đầu từ: ${DateFormat('yyyy-MM-dd').format(process.startTime).toString()}"),
                        Text(process.endTime == null
                            ? "Hiện tại"
                            : "Đến: ${DateFormat('yyyy-MM-dd').format(process.endTime!).toString()}"),
                      ],
                    ),
                  ],
                ),
              ),
            ).onInkTap(() async {
              final updatedLaborContact = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoLaborcontractScreen(
                    laborContracts: process,
                  ),
                ),
              );

              // Kiểm tra xem có dữ liệu cập nhật không
              if (updatedLaborContact != null) {
                _handleUpdateLaborContact(updatedLaborContact);
              }
            }),
          ),
          isExpanded: process.isExpanded,
        );
      }).toList(),
    );
  }
}
