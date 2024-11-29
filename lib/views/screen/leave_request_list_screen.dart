// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:intl/intl.dart';
// import 'package:nloffice_hrm/constant/app_color.dart';
// import 'package:nloffice_hrm/constant/app_strings.dart';
// import 'package:nloffice_hrm/models/absents_model.dart';
// import 'package:nloffice_hrm/models/profiles_model.dart';
// import 'package:nloffice_hrm/view_models/absent_view_model.dart';
// import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
// import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
// import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
// import 'package:provider/provider.dart';
// import 'package:velocity_x/velocity_x.dart';

// class EmployAttendListScreen extends StatefulWidget {
//   // final Profiles? profiles;
//   const EmployAttendListScreen({super.key});

//   @override
//   State<EmployAttendListScreen> createState() => _EmployAttendListScreenState();
// }

// class _EmployAttendListScreenState extends State<EmployAttendListScreen> {
//   int _selectedTabIndex = 0;
//   String? selectedEmployee;
//   final _formKey = GlobalKey<FormState>();
//   final _profileIDController = TextEditingController();
//   final _reasonController = TextEditingController();
//   final _daysOffController = TextEditingController();
//   final _fromDateController = TextEditingController();
//   final _toDateController = TextEditingController();
//   DateTime _fromDate = DateTime.now();
//   DateTime _toDate = DateTime.now();
//   final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

//   void initState() {
//     super.initState();
//     _profileIDController.text = "dev-001";
//   }

//   Future<void> _selectDate(BuildContext context, DateTime initialDate,
//       Function(DateTime) onDateSelected) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != initialDate) {
//       onDateSelected(picked);
//     }
//   }

//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       final newAbsents = Absents(
//           profileID: _profileIDController.text,
//           reason: _reasonController.text,
//           from: _fromDate,
//           to: _toDate,
//           daysOff: double.parse(_daysOffController.text),
//           status: 0);
//       Provider.of<AbsentsViewModel>(context, listen: false)
//           .addNewAbsent(newAbsents)
//           .then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Absent added successfully!')),
//         );
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add absent: $error')),
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BasePage(
//         titletext: "Nghỉ phép",
//         showAppBar: true,
//         showLeadingAction: true,
//         fab: FloatingActionButton(
//             child: Icon(Icons.add),
//             onPressed: () {
//               showDialog<Widget>(
//                   context: context,
//                   builder: (context) {
//                     return Dialog(
//                       child: Container(
//                         height: 380,
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CustomTextFormField(
//                                 enabled: false,
//                                 textEditingController: _profileIDController,
//                                 labelText: 'Mã nhân viên',
//                               ).py8(),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: _buildDateField(
//                                       'Từ',
//                                       _fromDateController,
//                                       _fromDate,
//                                       (date) {
//                                         setState(() {
//                                           _fromDate = date;
//                                           _fromDateController.text =
//                                               dateFormat.format(date);
//                                           _updateDayOff(); // Cập nhật lại dayoff khi chọn ngày "From"
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(width: 16),
//                                   Expanded(
//                                     child: _buildDateField(
//                                       'Đến',
//                                       _toDateController,
//                                       _toDate,
//                                       (date) {
//                                         setState(() {
//                                           _toDate = date;
//                                           _toDateController.text =
//                                               dateFormat.format(date);
//                                           _updateDayOff(); // Cập nhật lại dayoff khi chọn ngày "To"
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ).py8(),
//                               CustomTextFormField(
//                                 enabled: false,
//                                 textEditingController: _daysOffController,
//                                 labelText: 'Số ngày nghỉ',
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'please_enter_dayoffs';
//                                   }
//                                   // Kiểm tra nếu số ngày nhập vào khớp với sự tính toán từ ngày "From" và "To"
//                                   double enteredDaysOff = double.parse(value);
//                                   if (enteredDaysOff != _calculateDaysOff()) {
//                                     return 'Holiday does not match the number of days between "To day" and "From day" ';
//                                   }
//                                   return null;
//                                 },
//                               ).py8(),
//                               CustomTextFormField(
//                                 textEditingController: _reasonController,
//                                 labelText: 'Lí do',
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Vui lòng nhập lí do nghỉ phép';
//                                   }
//                                   return null;
//                                 },
//                               ).py8(),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       _submit();
//                                     },
//                                     child: Text('Tạo'),
//                                   ),
//                                 ],
//                               ).py16(),
//                             ],
//                           ),
//                         ).p8(),
//                       ),
//                     );
//                   });
//             }),
//         body: Spacer());
//   }

//   Widget _buildDateField(String label, TextEditingController controller,
//       DateTime initialDate, Function(DateTime) onDateSelected) {
//     return GestureDetector(
//       onTap: () => _selectDate(context, initialDate, onDateSelected),
//       child: AbsorbPointer(
//         child: TextFormField(
//           readOnly: true,
//           style: TextStyle(color: Colors.black),
//           controller: controller,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'please';
//             }

//             // Kiểm tra ngày "To" phải lớn hơn hoặc bằng ngày "From" cộng thêm một ngày
//             if (label == 'To day') {
//               final fromDate = _fromDate;
//               final toDate = DateTime.parse(value);

//               if (toDate.isBefore(fromDate.add(Duration(days: 1)))) {
//                 return 'To day must be at least one day after From day';
//               }
//             }
//             return null;
//           },
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         ),
//       ),
//     );
//   }

// // Hàm tính toán số ngày nghỉ
//   double _calculateDaysOff() {
//     final difference = _toDate.difference(_fromDate).inDays;
//     return difference >= 0 ? difference.toDouble() : 0.0;
//   }

//   // Cập nhật lại giá trị "Dayoffs" sau khi chọn ngày "From" và "To"
//   void _updateDayOff() {
//     setState(() {
//       double daysOff = _calculateDaysOff();
//       _daysOffController.text = daysOff.toString();
//     });
//   }

//   Widget _buildTabButton(String text, int index, Function onPressed) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5.0),
//       child: ElevatedButton(
//         onPressed: () {
//           setState(() {
//             _selectedTabIndex = index;
//             onPressed;
//           });
//         },
//         child: Text(text),
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//               _selectedTabIndex == index ? Colors.blue : Colors.grey[300],
//           foregroundColor:
//               _selectedTabIndex == index ? Colors.white : Colors.black,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AbsentRequestCard extends StatelessWidget {
//   final List<Map<String, String>> timeCardData;

//   AbsentRequestCard({required this.timeCardData});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.6,
//       child: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: timeCardData.length,
//         itemBuilder: (context, index) {
//           final data = timeCardData[index];
//           return TimeCard(
//             name: data['name']!,
//             designation: data['designation']!,
//             date: data['date']!,
//             inTime: data['inTime']!,
//             outTime: data['outTime']!,
//             status: data['status']!,
//             profileImage: data['profileImage']!,
//           );
//         },
//       ),
//     );
//   }
// }

// class TimeCard extends StatelessWidget {
//   final String name;
//   final String designation;
//   final String date;
//   final String inTime;
//   final String outTime;
//   final String status;

//   final String profileImage;

//   TimeCard({
//     required this.name,
//     required this.designation,
//     required this.date,
//     required this.inTime,
//     required this.outTime,
//     required this.status,
//     required this.profileImage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: EdgeInsets.all(12),
//         margin: EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundImage: NetworkImage(profileImage),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 14),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                       Text(
//                         designation,
//                         style: TextStyle(color: Colors.grey, fontSize: 12),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Date',
//                         style: TextStyle(color: Colors.grey, fontSize: 12)),
//                     Text(date, style: TextStyle(fontSize: 12)),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('In Time',
//                         style: TextStyle(color: Colors.grey, fontSize: 12)),
//                     Text(inTime, style: TextStyle(fontSize: 12)),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Out Time',
//                         style: TextStyle(color: Colors.grey, fontSize: 12)),
//                     Text(outTime, style: TextStyle(fontSize: 12)),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   status,
//                   style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         ));
//   }
// }
