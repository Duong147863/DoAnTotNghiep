import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/api_services/profile_service.dart';
import 'package:nloffice_hrm/api_services/salary_service.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_seach.dart';
import 'package:nloffice_hrm/views/screen/info_salari_sceen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/views/screen/payslipscreen.dart';
import 'package:provider/provider.dart';

// class SalaryListScreen extends StatefulWidget {
//   @override
//   _SalaryListScreenState createState() => _SalaryListScreenState();
// }

// class _SalaryListScreenState extends State<SalaryListScreen> {
//   List<Profiles> profiles = []; // Khai báo danh sách profiles
//   List<Profiles> filteredProfiles = [];
//   List<Salaries> salaries = []; // Khai báo danh sách salaries
//   @override
//   void initState() {
//     super.initState();
//     _fetchSalary();
//   }

//  Future<void> _fetchSalary() async {
//   try {
//     // Gọi API để lấy danh sách lương
//     List<Salaries> fetchedSalaries = await fetchSalary();
//     setState(() {
//       salaries = fetchedSalaries;
//     });
//   } catch (error) {
//     print('Error fetching salaries: $error');
//   }
// }

//   void _handleSearch(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredProfiles = profiles;
//       } else {
//         filteredProfiles = profiles.where((profile) {
//           return profile.profileName!
//               .toLowerCase()
//               .contains(query.toLowerCase());
//         }).toList();
//       }
//     });
//   }

//   Widget build(BuildContext context) {
//     return BasePage(
//       showAppBar: true,
//       defaultBody: true,
//       showLeadingAction: true,
//       backgroundColor: AppColor.primaryLightColor,

//       bodyChildren: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: CustomSearchBar(
//             hintText: '',
//             suggestions:
//                 profiles.map((profile) => profile.profileName!).toList(),
//             onTextChanged: _handleSearch,
//           ),
//         ),
//         Expanded(
//           child:
//               Consumer<ProfilesViewModel>(builder: (context, viewModel, child) {
//             if (!viewModel.fetchingData && viewModel.listProfiles.isEmpty) {
//               Provider.of<ProfilesViewModel>(context, listen: true)
//                   .fetchAllProfiles();
//             }
//             if (viewModel.fetchingData) {
//               // While data is being fetched
//               return Center(child: CircularProgressIndicator());
//             } else {
//               // If data is successfully fetched
//               List<Profiles> profiles = viewModel.listProfiles;
//               return CustomListView(
//                 dataSet: profiles,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(profiles[index].profileName),
//                     leading: CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.white,
//                       child: ClipOval(
//                         child: SizedBox(
//                           width: 60,
//                           height: 60,
//                           child: profiles[index].profileImage != null &&
//                                   profiles[index].profileImage.isNotEmpty
//                               ? Image.memory(
//                                   base64Decode(profiles[index].profileImage),
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Icon(Icons.error,
//                                         size: 30, color: Colors.grey);
//                                   },
//                                 )
//                               :
//                               // AssetImage("assets/images/logos/white_logo.png")
//                               Icon(Icons.person, size: 30, color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PayrollScreen(
//                               profile: profiles[index],
//                             ),
//                           ));
//                     },
//                   );
//                 },
//               );
//             }
//           }),
//         ),
//       ],
//     );
//   }
// }
// class SalaryListScreen extends StatefulWidget {
//   const SalaryListScreen({super.key});
//   @override
//   _SalaryListScreenState createState() => _SalaryListScreenState();
// }

// class _SalaryListScreenState extends State<SalaryListScreen> {
//   final profileId = "CEO";
//   @override

//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(title: Text("Danh Sách Lương")),
//       body: Consumer<SalariesViewModel>(
//         builder: (context, viewModel, child) {
//           if (viewModel.fetchingData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (viewModel.profile == null ||
//               viewModel.position == null ||
//               viewModel.salary == null) {
//             return Center(child: Text("Không tìm thấy dữ liệu."));
//           }

//           return ListView(
//             children: [
//               ListTile(
//                 title: Text("Profile ID: ${viewModel.profile!.profileId}"),
//                 subtitle:
//                     Text("Profile Name: ${viewModel.profile!.profileName}"),
//               ),
//               ListTile(
//                 title: Text("Position ID: ${viewModel.position!.positionId}"),
//                 subtitle:
//                     Text("Position Name: ${viewModel.position!.positionName}"),
//               ),
//               ListTile(
//                 title: Text(
//                     "Salary Coefficient: ${viewModel.salary!.salaryCoefficient}"),
//               ),
//               ListTile(
//                 title: Text("Allowances: ${viewModel.salary!.allowances ?? 0}"),
//               ),
//               ListTile(
//                 title: Text("Personal Tax: ${viewModel.salary!.personalTax}"),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
