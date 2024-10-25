import 'package:flutter/material.dart';

class LeaveRequestForm extends StatefulWidget {
  @override
  _LeaveRequestFormState createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final List<Map<String, dynamic>> _leaveRequestData = [
    {
      "label": "Họ và tên",
      "fieldName": "employeeName",
      "options": ['Trần Bình Minh', 'Nguyễn Thị Hải', 'HAHA'],
    },
    {
      "label": "Mã nhân viên",
      "fieldName": "employeeID",
      "options": [],
    },
    {
      "label": "Vị trí công việc",
      "fieldName": "position",
      "options": ['Nhân viên kế toán', 'Nhân viên kỹ thuật'],
    },
    {
      "label": "Đơn vị công tác",
      "fieldName": "department",
      "options": ['Phòng kế toán', 'Phòng kỹ thuật'],
    },
    {
      "label": "Người duyệt",
      "fieldName": "approver",
      "options": ['Nguyễn Văn Nhân', 'Trần Thị Hằng'],
    },
    {
      "label": "Người thay thế",
      "fieldName": "substitute",
      "options": ['Nguyễn Văn A', 'Trần Văn B'],
    },
    {
      "label": "Người liên quan",
      "fieldName": "relatedPerson",
      "options": ['Hoàng Thùy Linh', 'Trần Thu Hà'],
    },
    {
      "label": "Trạng thái",
      "fieldName": "status",
      "options": ['Chờ duyệt', 'Đã duyệt', 'Từ chối'],
    },
  ];

  String? selectedEmployee;
  String? selectedPosition;
  String? selectedDepartment;
  String? selectedApprover;
  String? selectedRelatedPerson;
  String? selectedSubstitute;
  String employeeID = '';
  DateTime submissionDate = DateTime.now();
  String leaveReason = 'Nghỉ ốm';
  double leavePercentage = 75.0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(Duration(days: 1));
  double leaveDays = 1.0;
  String status = "Chờ duyệt";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Đơn Xin Nghỉ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ..._leaveRequestData.map((field) {
              if (field['fieldName'] == 'employeeID') {
                return TextFormField(
                  decoration: InputDecoration(
                    labelText: field['label'],
                  ),
                  initialValue: employeeID,
                  onChanged: (value) {
                    setState(() {
                      employeeID = value;
                    });
                  },
                  style: TextStyle(color: Colors.black),
                );
              } else {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: field['label']),
                  value: getSelectedValue(field['fieldName']),
                  items: (field['options'] as List<String>).map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      setSelectedValue(field['fieldName'], value);
                    });
                  },
                );
              }
            }).toList(),

            TextFormField(
              decoration: InputDecoration(labelText: 'Lý do nghỉ'),
              initialValue: leaveReason,
              onChanged: (value) {
                setState(() {
                  leaveReason = value;
                });
              },
              style: TextStyle(color: Colors.black),
            ),

            TextFormField(
              decoration: InputDecoration(labelText: 'Tỷ lệ hưởng'),
              initialValue: leavePercentage.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  leavePercentage = double.tryParse(value) ?? leavePercentage;
                });
              },
              style: TextStyle(color: Colors.black),
            ),

            ListTile(
              title: Text("Từ ngày: ${fromDate.toString().split(' ')[0]}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: fromDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != fromDate) {
                  setState(() {
                    fromDate = picked;
                  });
                }
              },
            ),

            // To Date
            ListTile(
              title: Text("Đến ngày: ${toDate.toString().split(' ')[0]}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: toDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != toDate) {
                  setState(() {
                    toDate = picked;
                  });
                }
              },
            ),

            TextFormField(
              decoration: InputDecoration(labelText: 'Số ngày nghỉ'),
              initialValue: leaveDays.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  leaveDays = double.tryParse(value) ?? leaveDays;
                });
              },
              style: TextStyle(color: Colors.black),
            ),

            ListTile(
              title: Text(
                  "Ngày đệ trình: ${submissionDate.toString().split(' ')[0]}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: submissionDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != submissionDate) {
                  setState(() {
                    submissionDate = picked;
                  });
                }
              },
            ),

            TextFormField(
              decoration: InputDecoration(labelText: 'Ghi chú'),
              style: TextStyle(color: Colors.black),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Lưu'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Lưu & Thêm'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Hủy bỏ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? getSelectedValue(String fieldName) {
    switch (fieldName) {
      case 'employeeName':
        return selectedEmployee;
      case 'position':
        return selectedPosition;
      case 'department':
        return selectedDepartment;
      case 'approver':
        return selectedApprover;
      case 'relatedPerson':
        return selectedRelatedPerson;
      case 'substitute':
        return selectedSubstitute;
      case 'status':
        return status;
      default:
        return null;
    }
  }

  void setSelectedValue(String fieldName, String? value) {
    switch (fieldName) {
      case 'employeeName':
        selectedEmployee = value;
        break;
      case 'position':
        selectedPosition = value;
        break;
      case 'department':
        selectedDepartment = value;
        break;
      case 'approver':
        selectedApprover = value;
        break;
      case 'relatedPerson':
        selectedRelatedPerson = value;
        break;
      case 'substitute':
        selectedSubstitute = value;
        break;
      case 'status':
        status = value ?? status;
        break;
    }
  }
}







// import 'package:flutter/material.dart';

// class LeaveRequestForm extends StatefulWidget {
//   @override
//   _LeaveRequestFormState createState() => _LeaveRequestFormState();
// }

// class _LeaveRequestFormState extends State<LeaveRequestForm> {
//   String? selectedEmployee;
//   String? selectedPosition;
//   String? selectedDepartment;
//   String? selectedApprover;
//   String? selectedRelatedPerson;
//   String? leaveType;
//   double leavePercentage = 75.0;
//   DateTime fromDate = DateTime.now();
//   DateTime toDate = DateTime.now().add(Duration(days: 1));
//   double leaveDays = 1.0;
//   String status = "Chờ duyệt";

//   final List<Map<String, dynamic>> _leaveRequestData = [];

//   void _submitForm() {
//     final leaveRequest = {
//       'employee': selectedEmployee,
//       'employeeId': 'PKT006', // You can modify this to get the actual ID
//       'position': selectedPosition,
//       'department': selectedDepartment,
//       'approver': selectedApprover,
//       'relatedPerson': selectedRelatedPerson,
//       'leaveType': leaveType ?? 'Nghỉ ốm',
//       'leavePercentage': leavePercentage,
//       'fromDate': fromDate,
//       'toDate': toDate,
//       'leaveDays': leaveDays,
//       'status': status,
//       'notes': '' // Add any notes if needed
//     };

//     setState(() {
//       _leaveRequestData.add(leaveRequest);
//     });

//     // Optionally clear the form fields after submission
//     _clearForm();
//   }

//   void _clearForm() {
//     selectedEmployee = null;
//     selectedPosition = null;
//     selectedDepartment = null;
//     selectedApprover = null;
//     selectedRelatedPerson = null;
//     leavePercentage = 75.0;
//     fromDate = DateTime.now();
//     toDate = DateTime.now().add(Duration(days: 1));
//     leaveDays = 1.0;
//     status = "Chờ duyệt";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Thêm Đơn Xin Nghỉ"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             // Employee Name
//             DropdownButtonFormField<String>(
//               value: selectedEmployee,
//               decoration: InputDecoration(labelText: 'Họ và tên'),
//               items: ['Trần Bình Minh', 'Nguyễn Thị Hải'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedEmployee = value;
//                 });
//               },
//             ),

//             // Employee ID
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Mã nhân viên'),
//               initialValue: 'PKT006',
//             ),

//             // Position
//             DropdownButtonFormField<String>(
//               value: selectedPosition,
//               decoration: InputDecoration(labelText: 'Vị trí công việc'),
//               items: ['Nhân viên kế toán', 'Nhân viên kỹ thuật']
//                   .map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedPosition = value;
//                 });
//               },
//             ),

//             // Department
//             DropdownButtonFormField<String>(
//               value: selectedDepartment,
//               decoration: InputDecoration(labelText: 'Đơn vị công tác'),
//               items: ['Phòng kế toán', 'Phòng kỹ thuật'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedDepartment = value;
//                 });
//               },
//             ),

//             // Approver
//             DropdownButtonFormField<String>(
//               value: selectedApprover,
//               decoration: InputDecoration(labelText: 'Người duyệt'),
//               items: ['Nguyễn Văn Nhân', 'Trần Thị Hằng'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedApprover = value;
//                 });
//               },
//             ),

//             // Related Persons
//             DropdownButtonFormField<String>(
//               value: selectedRelatedPerson,
//               decoration: InputDecoration(labelText: 'Người liên quan'),
//               items: ['Hoàng Thùy Linh', 'Trần Thu Hà'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedRelatedPerson = value;
//                 });
//               },
//             ),

//             // Leave Type
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Lý do nghỉ'),
//               initialValue: 'Nghỉ ốm',
//               onChanged: (value) {
//                 leaveType = value;
//               },
//             ),

//             // Leave Percentage
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Tỷ lệ hưởng'),
//               initialValue: leavePercentage.toString(),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 leavePercentage = double.tryParse(value) ?? 75.0;
//               },
//             ),

//             // From Date
//             ListTile(
//               title: Text("Từ ngày: ${fromDate.toLocal()}"),
//               trailing: Icon(Icons.calendar_today),
//               onTap: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: fromDate,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2100),
//                 );
//                 if (picked != null && picked != fromDate) {
//                   setState(() {
//                     fromDate = picked;
//                   });
//                 }
//               },
//             ),

//             // To Date
//             ListTile(
//               title: Text("Đến ngày: ${toDate.toLocal()}"),
//               trailing: Icon(Icons.calendar_today),
//               onTap: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: toDate,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2100),
//                 );
//                 if (picked != null && picked != toDate) {
//                   setState(() {
//                     toDate = picked;
//                   });
//                 }
//               },
//             ),

//             // Number of Leave Days
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Số ngày nghỉ'),
//               initialValue: leaveDays.toString(),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 leaveDays = double.tryParse(value) ?? 1.0;
//               },
//             ),

//             // Status
//             DropdownButtonFormField<String>(
//               value: status,
//               decoration: InputDecoration(labelText: 'Trạng thái'),
//               items: ['Chờ duyệt', 'Đã duyệt', 'Từ chối'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   status = value!;
//                 });
//               },
//             ),

//             // Notes
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Ghi chú'),
//             ),

//             // Submit and Cancel Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: Text('Lưu'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Save and add another action
//                     _submitForm();
//                   },
//                   child: Text('Lưu & Thêm'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Cancel action
//                   },
//                   child: Text('Hủy bỏ'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }