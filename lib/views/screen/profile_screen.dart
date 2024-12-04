import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/department_position_model.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/models/insurance_model.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/provinces.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/models/roles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/diplomas_view_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
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
import 'package:nloffice_hrm/views/screen/add_labor_contract_screen.dart';
import 'package:nloffice_hrm/views/screen/add_provinces.dart';
import 'package:nloffice_hrm/views/screen/add_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/add_trainingprocesses_screen.dart';
import 'package:nloffice_hrm/views/screen/add_workingprocess_screen.dart';
import 'package:nloffice_hrm/views/screen/info_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/info_laborcontract_screen.dart';
import 'package:nloffice_hrm/views/screen/info_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/info_trainingprocesses_screen.dart';
import 'package:nloffice_hrm/views/screen/info_workingprocess_screen.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'list_nation.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final Profiles? profile;
  final Profiles? loginUser; //TK đang đăng nhập
  const ProfileScreen({super.key, this.profile, this.loginUser});

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
  // final _profileNameController = TextEditingController();
  late TextEditingController _profileNameController;
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
  int? statusProfile;
  bool _isEditing = false;
  String? _profileImageBase64;
  bool _isButtonEnabled = true;
  bool _passwordVisible = false;
   bool _passwordVisible1 = false;
  //
  List<DepartmentPosition> departmentsPosition = [];
  DepartmentPosition? selectedDepartmentsPosition;
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
  String? _selectedNation;
  //
  late Future<List<Province>> futureProvinces;
  List<Province> provinces = [];
  //Ẩn hiện thông báo
  FocusNode _manvFocusNode = FocusNode();
  FocusNode _hovaTenFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _identifiNumFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _birthdayFocusNode = FocusNode();
  FocusNode _noisinhFocusNode = FocusNode();
  FocusNode _tamtruFocusNode = FocusNode();
  FocusNode _thuongtruFocusNode = FocusNode();
  FocusNode _ngayccdFocusNode = FocusNode();
  FocusNode _nationFocusNode = FocusNode();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  String? daysSignedFirstContract;
  String? daysSignedSecondContract;
  String? daysSignedThirdContract;
  int? roleid;
  String trialStatusText = "";
  bool showLaborContractButton = true; // Trạng thái hiển thị nút\
  bool showLaborContractButton1 = true; // Trạng thái hiển thị nút\
  bool isLaborContractClickable =
      true; // Trạng thái không cho người click vào widget để xem thông tin nữa
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  void initState() {
    super.initState();
    _loadLaborContact();
    _profileIDController.text = widget.profile!.profileId;
    // _profileNameController.text = widget.profile!.profileName;
    _profileNameController =
        TextEditingController(text: widget.profile!.profileName);
    _birthdayController.text =
        DateFormat('dd/MM/yyyy').format(widget.profile!.birthday).toString();
    _birthday = widget.profile!.birthday;
    _placeOfBirthController.text = widget.profile!.placeOfBirth;
    _gender = widget.profile!.gender;
    _identifiNumController.text = widget.profile!.identifiNum;
    _idLicenseDayController.text = DateFormat('dd/MM/yyyy')
        .format(widget.profile!.idLicenseDay)
        .toString();
    _idLicenseDay = widget.profile!.idLicenseDay;
    _startTimeController.text =
        DateFormat('dd/MM/yyyy').format(widget.profile!.startTime!).toString();
    _startTime = widget.profile!.startTime!;
    _endTimeController.text =
        DateFormat('dd/MM/yyyy').format(widget.profile!.endTime!).toString();
    _endTime = widget.profile!.endTime!;
    statusProfile = widget.profile!.profileStatus;
    _nationController.text = widget.profile!.nation;
    _selectedNation = widget.profile!.nation;
    _emailController.text = widget.profile!.email ?? '';
    _phoneController.text = widget.profile!.phone;
    _temporaryAddressController.text = widget.profile!.temporaryAddress;
    _currentAddressController.text = widget.profile!.currentAddress;
    _profileImageBase64 = widget.profile!.profileImage;
    _marriage = widget.profile!.marriage;
    _gender = widget.profile!.gender;
    roleid = widget.profile!.roleID;
    _loadDepartments();
    _loadSalaries();
    _loadworkingProcesses();
    _loadtrainingProcess();
    _loadRelative();
    _loadDiplomas();
    _loadLaborContact();
    _loadRoles();
    futureProvinces =
        Provider.of<ProfilesViewModel>(context, listen: false).fetchProvinces();
    loadProvinces();
    // Focus
    _identifiNumFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_identifiNumFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _phoneFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_phoneFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _emailFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_emailFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus

    _passwordFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_passwordFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    // Focus
    _hovaTenFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_hovaTenFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _manvFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_manvFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });

    _noisinhFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_noisinhFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
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
    _ngayccdFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_ngayccdFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _birthdayFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_birthdayFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
    _nationFocusNode.addListener(() {
      // Kiểm tra khi focus bị mất và validate lại
      if (!_nationFocusNode.hasFocus) {
        // Thực hiện validate lại khi người dùng rời khỏi trường nhập liệu
        _formKey.currentState?.validate();
      }
    });
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<ProfilesViewModel>(context, listen: false);
      await viewModel.getPassword(
        widget.profile!.profileId, // ID người dùng
        _newPasswordController.text, // Mật khẩu mới
        _confirmPasswordController.text, // Xác nhận mật khẩu mới
        (message) {
          // Callback để xử lý kết quả trả về
          if (message == 'Mật khẩu đã được đặt lại thành công.') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
      );
    }
  }

  Future<void> loadProvinces() async {
    final data = await futureProvinces;
    setState(() {
      provinces = data;
    });
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

  void _handleDeleteRelative(int relativeId) {
    setState(() {
      relatives.removeWhere((rela) => rela.relativeId == relativeId);
    });
  }

  void _handleDeleteDiploman(String diplomanId) {
    setState(() {
      diplomas.removeWhere((dip) => dip.diplomaId == diplomanId);
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

  void _handleDeleteWorkingProcess(int idworkingprocess) {
    setState(() {
      workingProcesses
          .removeWhere((wor) => wor.workingprocessId == idworkingprocess);
    });
  }

  void _handleUpdateWorkingProcess(WorkingProcesses idworkingprocessId) {
    setState(() {
      int index = workingProcesses.indexWhere(
          (wor) => wor.workingprocessId == idworkingprocessId.workingprocessId);
      if (index != -1) {
        workingProcesses[index] = idworkingprocessId;
      }
    });
  }

  void _handleDeleteTrainingProcess(int idTrainingProcess) {
    setState(() {
      trainingProcess.removeWhere(
          (train) => train.trainingprocessesId == idTrainingProcess);
    });
  }

  void _handleUpdateTrainingprocess(Trainingprocesses idTrainingProcess) {
    setState(() {
      int index = trainingProcess.indexWhere((train) =>
          train.trainingprocessesId == idTrainingProcess.trainingprocessesId);
      if (index != -1) {
        trainingProcess[index] = idTrainingProcess;
      }
    });
  }

  // void _loadDepartments() async {
  //   await Provider.of<DeparmentsViewModel>(context, listen: false)
  //       .getDepartmentsByPosition();

  //   departmentsPosition =
  //       Provider.of<DeparmentsViewModel>(context, listen: false)
  //           .getlistdepartmentPosition;
  //   if (departmentsPosition.isNotEmpty) {
  //     selectedDepartmentsPosition = departmentsPosition.firstWhere(
  //         (depandpos) =>
  //             depandpos.positionId == widget.profile!.positionId &&
  //             depandpos.departmentID == widget.profile!.departmentId);
  //   }
  //   setState(() {
  //     if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
  //     } else if (AppStrings.ROLE_PERMISSIONS
  //         .contains('Manage Staffs info only')) {
  //       departmentsPosition = departmentsPosition
  //           .where((department) => department.departmentID != 'PB-GĐ')
  //           .toList();
  //     }
  //   });
  // }
  void _loadDepartments() async {
    await Provider.of<DeparmentsViewModel>(context, listen: false)
        .getDepartmentsByPosition();

    departmentsPosition =
        Provider.of<DeparmentsViewModel>(context, listen: false)
            .getlistdepartmentPosition;

    if (widget.profile != null && departmentsPosition.isNotEmpty) {
      selectedDepartmentsPosition = departmentsPosition.firstWhere(
        (depandpos) =>
            depandpos.positionId == widget.profile!.positionId &&
            depandpos.departmentID == widget.profile!.departmentId,
      );
    }

    setState(() {
      if (AppStrings.ROLE_PERMISSIONS.contains('Manage BoD & HR accounts')) {
        // Logic quản lý tài khoản
      } else if (AppStrings.ROLE_PERMISSIONS
          .contains('Manage Staffs info only')) {
        departmentsPosition = departmentsPosition
            .where((department) => department.departmentID != 'PB-GĐ')
            .toList();
      }
    });
  }

  void _loadSalaries() async {
    await Provider.of<SalariesViewModel>(context, listen: false)
        .fetchAllSalaries();
    salarys =
        Provider.of<SalariesViewModel>(context, listen: false).listSalaries;
    if (salarys.isNotEmpty) {
      selectedSalarys = salarys.firstWhere(
        (salary) => salary.salaryId == widget.profile!.salaryId,
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
        roles = allRoles
            .where((role) => [1, 2, 3, 4].contains(role.roleID))
            .toList();
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
    await Provider.of<RelativesViewModel>(context, listen: false)
        .fetchAllRelatives(widget.profile!.profileId);
    relatives =
        Provider.of<RelativesViewModel>(context, listen: false).listRelatives;
    if (relatives.isNotEmpty) {
      selectedRelatives = relatives.firstWhere(
        (rel) => rel.profileId == widget.profile!.profileId,
      );
    }
  }

  void _loadworkingProcesses() async {
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
  }

  void _loadDiplomas() async {
    await Provider.of<DiplomasViewModel>(context, listen: false)
        .getDiplomasOf(widget.profile!.profileId);
    diplomas =
        Provider.of<DiplomasViewModel>(context, listen: false).listDiplomas;
    if (diplomas.isNotEmpty) {
      selectedDiplomas = diplomas.firstWhere(
        (dip) => dip.profileId == widget.profile!.profileId,
      );
    }
  }

  void _loadtrainingProcess() async {
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
  }

  void _loadLaborContact() {
    // Cập nhật giao diện
    setState(() {
      // Lấy danh sách hợp đồng từ ViewModel
      Provider.of<LaborContactsViewModel>(context, listen: false)
          .getLaborContactOf(widget.profile!.profileId);

      laborContracts =
          Provider.of<LaborContactsViewModel>(context, listen: false)
              .listLaborContact;

      if (laborContracts.isNotEmpty) {
        // Sắp xếp danh sách hợp đồng theo start_time để đảm bảo thứ tự đúng
        laborContracts.sort((a, b) => a.startTime.compareTo(b.startTime));

        DateTime currentDate = DateTime.now();

        if (statusProfile == 1) {
          // Trạng thái profile = 1: Lấy hợp đồng lần 1
          var firstContract = laborContracts[0];
          if (firstContract != null) {
            DateTime startTimeFirstContract = firstContract.startTime;
            DateTime? endTimeFirstContract = firstContract.endTime;

            if (endTimeFirstContract != null) {
              int remainingDays =
                  endTimeFirstContract.difference(currentDate).inDays;

              if (remainingDays > 0) {
                daysSignedFirstContract = "Hợp đồng lần 1: "
                    "${DateFormat('dd/MM/yyyy').format(startTimeFirstContract)} - ${DateFormat('dd/MM/yyyy').format(endTimeFirstContract)}"
                    "\ncòn thời hạn: "
                    "$remainingDays"
                    " ngày";
                showLaborContractButton1 = false; // Ẩn nút
              } else {
                daysSignedFirstContract = "Hợp đồng lần 1: "
                    "${DateFormat('dd/MM/yyyy').format(startTimeFirstContract)} - ${DateFormat('dd/MM/yyyy').format(endTimeFirstContract)}"
                    "\nđã hết thời hạn";
                showLaborContractButton1 = true; // Hiển thị nút
              }
            }
          }
        } else if (statusProfile == 2) {
          // Trạng thái profile = 2: Lấy hợp đồng lần 2
          if (laborContracts.length > 1) {
            var secondContract = laborContracts[1];
            if (secondContract != null) {
              DateTime startTimeSecondContract = secondContract.startTime;
              DateTime? endTimeSecondContract = secondContract.endTime;

              if (endTimeSecondContract != null) {
                int remainingDays =
                    endTimeSecondContract.difference(currentDate).inDays;

                if (remainingDays > 0) {
                  daysSignedSecondContract = "Hợp đồng lần 2: "
                      "${DateFormat('dd/MM/yyyy').format(startTimeSecondContract)} - ${DateFormat('dd/MM/yyyy').format(endTimeSecondContract)}"
                      "\ncòn thời hạn: "
                      "$remainingDays"
                      " ngày";
                } else {
                  daysSignedSecondContract = "Hợp đồng lần 2: "
                      "${DateFormat('dd/MM/yyyy').format(startTimeSecondContract)} - ${DateFormat('dd/MM/yyyy').format(endTimeSecondContract)}"
                      "\nđã hết thời hạn";
                }
              }
            }
          }
        } else if (statusProfile == 3) {
          // Trạng thái profile = 3: Lấy hợp đồng lần 3 hoặc hợp đồng vô hạn
          if (laborContracts.length > 2) {
            var thirdContract = laborContracts[2];
            if (thirdContract != null) {
              DateTime startTimeThirdContract = thirdContract.startTime;
              DateTime? endTimeThirdContract = thirdContract.endTime;

              if (endTimeThirdContract == null) {
                // Hợp đồng vô hạn
                daysSignedThirdContract = "Hợp đồng lần 3: "
                    "${DateFormat('dd/MM/yyyy').format(startTimeThirdContract)} - Vô hạn";
              }
              //
            }
          }
        }
      }
    });
  }

  String getStatusText(
      DateTime startTime, DateTime endTime, int statusProfile) {
    DateTime currentDate = DateTime.now();
    int remainingDays = endTime.difference(currentDate).inDays;

    // Kiểm tra trạng thái thử việc (statusProfile == 0)
    if (statusProfile == 0) {
      if (remainingDays > 0) {
        showLaborContractButton = false; // Ẩn nút
        return "Thử việc: "
            "${DateFormat('dd/MM/yyyy').format(startTime)} - ${DateFormat('dd/MM/yyyy').format(endTime)}"
            "\ncòn thời hạn: "
            "$remainingDays"
            " ngày";
      } else {
        showLaborContractButton = true; // Hiển thị nút
        return "Thử việc: "
            "${DateFormat('dd/MM/yyyy').format(startTime)} - ${DateFormat('dd/MM/yyyy').format(endTime)}"
            "\nđã hết hạn";
      }
    }

    // Xử lý các trạng thái hợp đồng khác
    switch (statusProfile) {
      case 1:
        return "Hợp đồng ký lần 1";
      case 2:
        return "Hợp đồng ký lần 2";
      case 3:
        return "Hợp đồng vô thời hạn";
      default:
        return "Trạng thái không xác định";
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
          startTime: _startTime,
          endTime: _endTime,
          nation: _nationController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          roleID: selectedRoles!.roleID,
          profileStatus: statusProfile,
          temporaryAddress: _temporaryAddressController.text,
          currentAddress: _currentAddressController.text,
          marriage: _marriage,
          departmentId: selectedDepartmentsPosition!.departmentID,
          positionId: selectedDepartmentsPosition!.positionId,
          salaryId: selectedSalarys!.salaryId,
          profileImage: _profileImageBase64 ?? '');

      Provider.of<ProfilesViewModel>(context, listen: false)
          .updateProfile(updatedProfile, (message) {
        if (message == 'Nhân viên đã được cập nhật thành công.') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          // Khởi tạo lại các TextEditingController
          Navigator.pop(context, updatedProfile); // Đóng màn hình
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      });
    }
  }

  void _deleteProfile() async {
    try {
      await Provider.of<ProfilesViewModel>(context, listen: false)
          .deleteProfile(widget.profile!.profileId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Khóa tài khoản thành công')),
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
      firstDate: DateTime(1960),
      lastDate: DateTime(2100),
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
      appBar: AppBar(
          elevation: 0,
          title: statusProfile == 0
              ? Text(
                  getStatusText(_startTime, _endTime, statusProfile!),
                  style: TextStyle(color: Colors.white, fontSize: 13),
                )
              : Text(
                  statusProfile == 1
                      ? (daysSignedFirstContract != null
                          ? daysSignedFirstContract!
                          : "Chưa có thông tin hợp đồng lần 1")
                      : statusProfile == 2
                          ? (daysSignedSecondContract != null
                              ? daysSignedSecondContract!
                              : "Chưa có thông tin hợp đồng lần 2")
                          : (daysSignedThirdContract != null
                              ? daysSignedThirdContract!
                              : "Chưa có thông tin hợp đồng lần 3"),
                  style: TextStyle(fontSize: 13),
                ),
          backgroundColor: AppColor.primaryLightColor,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          actions: <Widget>[
            _isEditing
                ? IconButton(
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
                    icon: Icon(Icons.save, color: Colors.white),
                  )
                : AppStrings.ROLE_PERMISSIONS
                        .contains('Manage your department members only')
                    ? SizedBox.shrink()
                    : AppStrings.ROLE_PERMISSIONS.containsAny([
                        'Manage BoD & HR accounts',
                        'Manage Staffs info only'
                      ])
                        ? SpeedDial(
                            elevation: 0,
                            direction: SpeedDialDirection.down,
                            icon: Icons.menu,
                            backgroundColor: AppColor.primaryLightColor,
                            foregroundColor: Colors.white,
                            buttonSize: Size(50, 50),
                            children: [
                                SpeedDialChild(
                                    child: Icon(Icons.edit_outlined,
                                        color: AppColor.primaryLightColor),
                                    onTap: () {
                                      setState(() {
                                        _isEditing =
                                            true; // Chuyển đổi chế độ chỉnh sửa
                                        _isButtonEnabled = true;
                                      });
                                    }),
                                SpeedDialChild(
                                  child: Icon(Icons.lock,
                                      color: AppColor.primaryLightColor),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Xác nhận khoá ?'),
                                          content: Text(
                                              'Khoá quyền sử dụng của hồ sơ này?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Huỷ'),
                                            ),
                                            AppStrings.ROLE_PERMISSIONS
                                                    .containsAny([
                                              'Manage BoD & HR accounts',
                                              'Manage Staffs info only'
                                            ])
                                                ? TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _deleteProfile();
                                                    },
                                                    child: Text('Khoá'),
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                SpeedDialChild(
                                  child: Icon(Icons.reset_tv_outlined,
                                      color: AppColor.primaryLightColor),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                400.0, // Chiều rộng của dialog
                                            height:
                                                300.0, // Chiều cao của dialog
                                            padding: EdgeInsets.all(
                                                20.0), // Padding bên trong
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Reset Mật Khẩu'),
                                                Column(
                                                  children: [
                                                    CustomTextFormField(
                                                      textEditingController:
                                                          _newPasswordController,
                                                      obscureText:
                                                          !_passwordVisible,
                                                      prefixIcon: const Icon(
                                                          Icons.lock_outline),
                                                      suffixIcon: IconButton(
                                                        icon: Icon(
                                                          _passwordVisible
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _passwordVisible =
                                                                !_passwordVisible;
                                                          });
                                                        },
                                                      ),
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Mật khẩu mới'),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Vui lòng nhập mật khẩu mới';
                                                        }
                                                        if (value.length < 8 ||
                                                            value.length > 15) {
                                                          return 'Mật khẩu phải từ 8 đến 15 ký tự';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    CustomTextFormField(
                                                      textEditingController:
                                                          _confirmPasswordController,
                                                      obscureText:
                                                          !_passwordVisible1,
                                                      prefixIcon: const Icon(
                                                          Icons.lock_outline),
                                                      suffixIcon: IconButton(
                                                        icon: Icon(
                                                          _passwordVisible1
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _passwordVisible1 =
                                                                !_passwordVisible1;
                                                          });
                                                        },
                                                      ),
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Xác nhận mật khẩu mới'),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Vui lòng xác nhận mật khẩu mới';
                                                        }
                                                        if (value !=
                                                            _newPasswordController
                                                                .text) {
                                                          return 'Mật khẩu xác nhận không khớp';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Đóng dialog
                                                      },
                                                      child: Text('Hủy'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed:
                                                          _resetPassword, // Hàm xử lý reset mật khẩu
                                                      child:
                                                          Text('Lấy mât khẩu'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
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
                                    label: "Thêm quá trình đào tạo",
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddTrainingprocessesScreen(
                                              profiles: widget.profile,
                                            ),
                                          )).then((createNewTraining) {
                                        setState(() {
                                          trainingProcess
                                              .add(createNewTraining);
                                        });
                                      });
                                    }),
                                SpeedDialChild(
                                    label: "Thêm quá trình công tác",
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddWorkingprocesScreen(
                                              profiles: widget.profile,
                                            ),
                                          )).then((createNewWorkingprocess) {
                                        setState(() {
                                          workingProcesses
                                              .add(createNewWorkingprocess);
                                        });
                                      });
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
                                if (showLaborContractButton &&
                                    statusProfile == 0)
                                  SpeedDialChild(
                                    label: "Tạo hợp đồng",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddLaborContractScreen(
                                                  profiles: widget.profile),
                                        ),
                                      ).then((createNewLaborContract) {
                                        if (createNewLaborContract != null) {
                                          setState(() {
                                            laborContracts
                                                .add(createNewLaborContract);
                                            _loadLaborContact(); // Làm mới dữ liệu'
                                          });
                                        }
                                      });
                                    },
                                  ),
                              ])
                        : SpeedDial(
                            elevation: 0,
                            icon: Icons.menu,
                            direction: SpeedDialDirection.down,
                            backgroundColor: AppColor.primaryLightColor,
                            foregroundColor: Colors.white,
                            buttonSize: Size(50, 50),
                            children: [
                                SpeedDialChild(
                                    child: Icon(Icons.edit_outlined,
                                        color: AppColor.primaryLightColor),
                                    onTap: () {
                                      setState(() {
                                        _isEditing =
                                            true; // Chuyển đổi chế độ chỉnh sửa
                                        _isButtonEnabled = true;
                                      });
                                    }),
                                SpeedDialChild(
                                    label: "Thêm quá trình đào tạo",
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddTrainingprocessesScreen(
                                              profiles: widget.profile,
                                            ),
                                          )).then((createNewTraining) {
                                        setState(() {
                                          trainingProcess
                                              .add(createNewTraining);
                                        });
                                      });
                                    }),
                                SpeedDialChild(
                                    label: "Thêm quá trình công tác",
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddWorkingprocesScreen(
                                              profiles: widget.profile,
                                            ),
                                          )).then((createNewWorkingprocess) {
                                        setState(() {
                                          workingProcesses
                                              .add(createNewWorkingprocess);
                                        });
                                      });
                                    }),
                              ]),
          ]),
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
                    enabled: false,
                    textEditingController: _profileIDController,
                    maxLength: 10,
                    focusNode: _manvFocusNode,
                    labelText: 'Mã nhân viên',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      } else if (value.length > 10) {
                        return 'Mã nhân viên không được vượt quá 10 ký tự';
                      } else if (!value.startsWith('NV')) {
                        return 'Mã nhân viên phải bắt đầu bằng "NV"';
                      } else if (!RegExp(r'^NV\d+$').hasMatch(value)) {
                        return 'Sau "NV" phải là số';
                      }
                      return null;
                    },
                  ).px8().w(150),
                  CustomTextFormField(
                    focusNode: _hovaTenFocusNode,
                    textEditingController: _profileNameController,
                    labelText: 'Họ và tên',
                    maxLength: 50,
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      // Kiểm tra không có khoảng trắng ở cuối tên
                      if (value.trim() != value) {
                        return 'Không được có khoảng trắng thừa\nở đầu hoặc cuối';
                      }
                      if (value.length < 4) {
                        return 'Họ và Tên phải có ít nhất 4 ký tự';
                      }
                      // Regex kiểm tra ký tự đặc biệt
                      final nameRegex = RegExp(
                          r"^[a-zA-ZÂÃÈÉÊÙÚĂĐŨƠÀÁẠÃàáạãâầấậẤẦẪẬÂẫấậẫầãèéêìíòóôõùúăđĩũơƯĂẮẰẲẴẶẤẦẨẪẬắằẳẵặéèẻẽẹêềếểễệẾỀỆỄíìỉĩịỊÌÍĨÒÓÕỌòóỏõọôồÔỒỘỐỖÔốổỗộơờớởỡợùúủÙÚỤUŨũụưừứửỪỰỮỨữựýỳỷỹỵ\s]+$");

                      if (!nameRegex.hasMatch(value)) {
                        return 'Họ và Tên không hợp lệ. Vui lòng\nnhập đúng định dạng.';
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
                        return 'Chữ cái đầu tiên của mỗi từ phải\n viết hoa. Ví dụ: Nguyễn Bình Dương';
                      }

                      if (!value.isLetter()) {
                        return 'Tên chỉ gồm chữ';
                      }
                      return null;
                    },
                  ).w(200),
                ],
              ).py16(),
              // Birthday + Place of birth

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildDateField(
                    'Ngày sinh', _birthdayController, _birthday, (date) {
                  setState(() {
                    _birthday = date;
                    _birthdayController.text =
                        DateFormat('dd/MM/yyyy').format(_birthday);
                  });
                }),
              ).p(8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
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
                              _placeOfBirthController.text = selectedAddress;
                            });
                          }
                        }
                      : null,
                  child: AbsorbPointer(
                    // Ngăn không cho bàn phím mở ra khi nhấn
                    child: CustomTextFormField(
                      focusNode: _noisinhFocusNode,
                      textEditingController: _placeOfBirthController,
                      labelText: 'Nơi sinh',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Không được để trống';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ).p(8),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildDepartmentPositionDropdown(
                  'Chức Vụ - Phòng Ban',
                  widget.loginUser!.profileId,
                  widget.profile!.profileId,
                ),
              ).p(8),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildSalaryDropdown(
                  'Mức lương',
                  widget.loginUser!.profileId,
                  widget.profile!.profileId,
                ),
              ).p(8),

              AppStrings.ROLE_PERMISSIONS.containsAny(
                      ['Manage Staffs info only', 'Manage BoD & HR accounts'])
                  ? Row(
                      children: [
                        Text('Quyền:').px(8),
                        _buildRolesDropdown(
                          'Quyền',
                          widget.loginUser!.profileId,
                          widget.profile!.profileId,
                        ).p(8).w(300),
                      ],
                    )
                  : SizedBox.shrink(),
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
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedNation,
                    focusNode: _nationFocusNode,
                    items: NationNames.map((nation) {
                      return DropdownMenuItem(
                        value: nation,
                        child: Text(
                          nation,
                          style: TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Quốc tịch',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _isEditing
                        ? (value) {
                            setState(() {
                              _selectedNation =
                                  value; // Cập nhật giá trị được chọn
                              _nationController.text =
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextFormField(
                  enabled: _isEditing,
                  textEditingController: _identifiNumController,
                  labelText: 'Số CCCD/CMND',
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  focusNode: _identifiNumFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    if (value.length != 12) {
                      return 'Số CCCD/CMND không\nhợp lệ';
                    }
                    if (!value.startsWith('0')) {
                      return 'Số CCCD phải bắt đầu\nbằng số 0';
                    }
                    if (!value.isNumber()) {
                      return 'Số CCCD chỉ gồm số';
                    }
                    return null;
                  },
                ),
              ).p(8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildDateLicenseDay(
                    'id ngày cấp', _idLicenseDayController, _idLicenseDay,
                    (date) {
                  setState(() {
                    _idLicenseDay = date;
                    _idLicenseDayController.text =
                        DateFormat('dd/MM/yyyy').format(_idLicenseDay);
                  });
                }),
              ).p(8),

              //Email + phone

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextFormField(
                  textEditingController: _emailController,
                  labelText: 'Email',
                  enabled: _isEditing,
                  maxLength: 254,
                  maxLines: 1,
                  focusNode: _emailFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống';
                    }
                    // Regex kiểm tra email: Phần trước @ phải từ 6-30 ký tự và không có dấu chấm ở đầu/cuối
                    final emailRegex =
                        RegExp(r'^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*@gmail\.com$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Email phải đúng định dạng\nvà có đuôi @gmail.com';
                    }
                    // Kiểm tra độ dài phần trước @
                    final localPart = value.split('@')[0];
                    if (localPart.length < 6 || localPart.length > 30) {
                      return 'Phần trước @ phải từ 6-30 ký tự';
                    }
                    if (value.length > 254) {
                      return 'Email không được vượt quá 254 ký tự';
                    }
                    return null;
                  },
                ),
              ).p(8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được\nđể trống';
                      }
                      if (value.length != 10) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      if (!value.startsWith('0')) {
                        return 'Số điện thoại\nphải bắt đầu\nbằng số 0';
                      }
                      if (!value.isNumber()) {
                        return 'Số điện thoại\nchỉ gồm số';
                      }
                      if (value.startsWith('00')) {
                        return 'Số điện thoại\nkhông được\nbắt đầu bằng 00';
                      }
                      return null;
                    },
                    textEditingController: _phoneController,
                    labelText: 'Điện thoại',
                    maxLines: 1,
                    maxLength: 10,
                    focusNode: _phoneFocusNode,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number),
              ).p(8),

              //Thường trú
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
                            _currentAddressController.text = selectedAddress;
                          });
                        }
                      }
                    : null,
                child: AbsorbPointer(
                  // Ngăn không cho bàn phím mở ra khi nhấn
                  child: CustomTextFormField(
                    enabled: _isEditing,
                    focusNode: _thuongtruFocusNode,
                    textEditingController: _currentAddressController,
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
                            _temporaryAddressController.text = selectedAddress;
                          });
                        }
                      }
                    : null,
                child: AbsorbPointer(
                  // Ngăn không cho bàn phím mở ra khi nhấn
                  child: CustomTextFormField(
                    enabled: _isEditing,
                    focusNode: _tamtruFocusNode,
                    textEditingController: _temporaryAddressController,
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
              // Thân nhân
              _buildRelativeList().p8(),
              //WorkingProcess
              _buildWorkingProcessList().p(8),
              // TrainingProcess
              _buildTrainingProcessesList().p8(),
              SizedBox(height: 16),
              _buildDiplomasList(),
              //Hợp đồng
              SizedBox(height: 16),
              _buildLaborContractList()
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: _isEditing
          ? () => _selectDate(context, initialDate, onDateSelected)
          : null,
      child: AbsorbPointer(
        child: TextFormField(
          focusNode: _birthdayFocusNode,
          readOnly: true,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nhập ngày sinh';
            }
            try {
              DateFormat dateFormat = DateFormat('dd/MM/yyyy');
              // Kiểm tra ngày sinh trong quá khứ
              DateTime birthday = dateFormat.parse(value);
              if (birthday.isAfter(DateTime.now())) {
                return 'Ngày sinh phải là ngày trong quá khứ';
              }
              int age = DateTime.now().year - birthday.year;
              if (DateTime.now().month < birthday.month ||
                  (DateTime.now().month == birthday.month &&
                      DateTime.now().day < birthday.day)) {
                age--;
                // Kiểm tra độ tuổi đủ làm việc (ví dụ từ 18 tuổi trở lên)

                if (age < 18) {
                  return 'Người lao động phải từ 18 tuổi trở lên';
                }

                // Kiểm tra tuổi nghỉ hưu nếu cần
                if (_isRetirementAgeExceeded(birthday, _gender)) {
                  return 'Người lao động đã quá tuổi!';
                }
              }
            } catch (e) {
              return 'Ngày không hợp lệ (Định dạng: dd/MM/yyyy)';
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

// Hàm kiểm tra tuổi nghỉ hưu
  bool _isRetirementAgeExceeded(DateTime birthday, bool gender) {
    DateTime currentDate = DateTime.now();

    // Tính số năm và tháng từ ngày sinh
    int ageInYears = currentDate.year - birthday.year;
    int ageInMonths = currentDate.month - birthday.month;
    if (ageInMonths < 0) {
      ageInYears--;
      ageInMonths += 12;
    }

    // Kiểm tra độ tuổi nghỉ hưu
    if (gender) {
      // Nữ (55 tuổi 4 tháng)
      if (ageInYears > 55 || (ageInYears == 55 && ageInMonths >= 4)) {
        return true;
      }
    } else {
      // Nam (60 tuổi 3 tháng)
      if (ageInYears > 60 || (ageInYears == 60 && ageInMonths >= 3)) {
        return true;
      }
    }
    return false;
  }

  Widget _buildDateLicenseDay(String label, TextEditingController controller,
      DateTime initialDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: _isEditing
          ? () => _selectDate(context, initialDate, onDateSelected)
          : null,
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          focusNode: _ngayccdFocusNode,
          style: TextStyle(color: Colors.black),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nhập ngày cấp';
            }
            // Kiểm tra ngày sinh trong quá khứ

            // Kiểm tra ngày sinh đã nhập (dùng controller)
            if (_birthdayController.text.isEmpty) {
              return 'Cần nhập ngày\n sinh trước!';
            }
            try {
              DateFormat dateFormat = DateFormat('dd/MM/yyyy');
              DateTime CCCD = dateFormat.parse(value);
              if (CCCD.isAfter(DateTime.now())) {
                return 'Ngày cấp CCCD phải là\nngày trong quá khứ';
              }
              // Parse ngày sinh từ _birthdayController
              DateTime birthday = dateFormat.parse(_birthdayController.text);
              // Kiểm tra tuổi đủ 14 tại thời điểm cấp
              DateTime licenseDay = dateFormat.parse(value);
              int ageAtLicense = licenseDay.year - birthday.year;

              if (licenseDay.month < birthday.month ||
                  (licenseDay.month == birthday.month &&
                      licenseDay.day < birthday.day)) {
                ageAtLicense--;
              }

              if (ageAtLicense < 14) {
                return 'Ngày cấp không hợp lệ\nCCCD chỉ cấp khi đủ\n14 tuổi';
              }
            } catch (e) {
              return 'Ngày không hợp lệ (Định dạng: dd/MM/yyyy)';
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

  Widget _buildDepartmentPositionDropdown(
      String hint, String loginUser, String profileId) {
    final bool isOwnProfile = loginUser == profileId;
    print(
        "isOwnProfile: $isOwnProfile, loginUser: $loginUser, profileId: $profileId");
    return DropdownButtonFormField<DepartmentPosition>(
      value: selectedDepartmentsPosition,
      isExpanded: true,
      hint: Text(hint),
      onChanged:
          !isOwnProfile // Chỉ cho chỉnh sửa nếu không phải trang cá nhân của chính mình
              ? (_isEditing
                  ? (DepartmentPosition? newValue) {
                      setState(() {
                        selectedDepartmentsPosition = newValue;
                      });
                    }
                  : null)
              : null,
      items: departmentsPosition.map((DepartmentPosition dep) {
        return DropdownMenuItem<DepartmentPosition>(
          value: dep,
          child: Text("${dep.positionName!} - ${dep.departmentName!}"),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabled:
            !isOwnProfile, // Đảm bảo Dropdown không bị vô hiệu hóa nếu không phải trang cá nhân
      ),
    );
  }

  Widget _buildSalaryDropdown(String hint, String loginUser, String profileId) {
    final bool isOwnProfile = loginUser == profileId;
    return DropdownButtonFormField<Salaries>(
      value: selectedSalarys,
      hint: Text(hint),
      onChanged:
          !isOwnProfile // Chỉ cho chỉnh sửa nếu không phải trang cá nhân của chính mình
              ? (_isEditing
                  ? (Salaries? newValue) {
                      setState(() {
                        selectedSalarys = newValue;
                      });
                    }
                  : null)
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

  Widget _buildRolesDropdown(String hint, String loginUser, String profileId) {
    final bool isOwnProfile = loginUser == profileId;
    return DropdownButtonFormField<Roles>(
      value: selectedRoles,
      hint: Text(hint),
      onChanged:
          !isOwnProfile // Chỉ cho chỉnh sửa nếu không phải trang cá nhân của chính mình
              ? (_isEditing
                  ? (Roles? newValue) {
                      setState(() {
                        selectedRoles = newValue;
                      });
                    }
                  : null)
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
              title: Text("Thân nhân",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            );
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text(
                process.relativesName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        builder: (context) => InfoRelativeScreen(
                          profile: process,
                          onDelete: _handleDeleteRelative,
                        ),
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
                          builder: (context) => InfoDiplomaScreen(
                            diplomas: process,
                            profiles: widget.profile,
                            onDelete: _handleDeleteDiploman,
                          ),
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

  Widget _buildWorkingProcessList() {
    return ExpansionPanelList(
      elevation: 2,
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          workingProcesses[index].isExpanded = isExpanded;
        });
      },
      children: workingProcesses.map((process) {
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
            child: InkWell(
              onTap: () async {
                final updatewokignprocess = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoWorkingprocessScreen(
                      workingProcesses: process,
                      profiles: widget.profile,
                      onDelete: _handleDeleteWorkingProcess,
                    ),
                  ),
                );
                if (updatewokignprocess != null) {
                  _handleUpdateWorkingProcess(updatewokignprocess);
                }
              },
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
                              "Từ: ${DateFormat('dd/MM/yyyy').format(process.startTime).toString()}"),
                          Text(process.endTime == null
                              ? " Hiện tại"
                              : " Đến: ${DateFormat('dd/MM/yyyy').format(process.endTime!).toString()}"),
                        ],
                      ),
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

  Widget _buildTrainingProcessesList() {
    return ExpansionPanelList(
      elevation: 2,
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          trainingProcess[index].isExpanded = isExpanded;
        });
      },
      children: trainingProcess.map((process) {
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
            child: InkWell(
              onTap: () async {
                final updatetrainingprocess = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoTrainingprocessesScreen(
                      trainingprocesses: process,
                      profiles: widget.profile,
                      onDelete: _handleDeleteTrainingProcess,
                    ),
                  ),
                );
                if (updatetrainingprocess != null) {
                  _handleUpdateTrainingprocess(updatetrainingprocess);
                }
              },
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
                          Text("Bắt đầu từ: ${DateFormat('dd/MM/yyyy').format(process.startTime).toString()}")
                              .p8(),
                          Text(process.endTime == null
                                  ? " Hiện tại"
                                  : " Đến: ${DateFormat('dd/MM/yyyy').format(process.endTime!).toString()}")
                              .p8(),
                        ],
                      ),
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

  Widget _buildLaborContractList() {
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
                "Hợp đồng lao động",
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
                    Text(
                        "${process.laborContractId} Hợp đồng kí lần ${laborContracts.indexOf(process) + 1}"),
                    Row(
                      children: [
                        Text(
                            "Bắt đầu từ: ${DateFormat('dd/MM/yyyy').format(process.startTime).toString()}"),
                        Text(process.endTime == null
                            ? " Hợp đồng vô hạn"
                            : " Đến: ${DateFormat('dd/MM/yyyy').format(process.endTime!).toString()}"),
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
                    profiles: widget.profile,
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
