import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';

class EmployAttendListScreen extends StatefulWidget {
  const EmployAttendListScreen({super.key});

  @override
  State<EmployAttendListScreen> createState() => _EmployAttendListScreenState();
}

class _EmployAttendListScreenState extends State<EmployAttendListScreen> {
  int _selectedTabIndex = 0;
  final List<Map<String, String>> timeCardData = [
    {
      'name': 'Shaidul Islam',
      'designation': 'Designer',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Ibne Riead',
      'designation': 'Designer',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Nguyễn Bình Dương',
      'designation': 'IT',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Phạm Ngọc Liêm',
      'designation': 'IT',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Phạm Ngọc Liêm',
      'designation': 'IT',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Phạm Ngọc Liêm',
      'designation': 'IT',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Phạm Ngọc Liêm',
      'designation': 'IT',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Phạm Ngọc Liêm',
      'designation': 'IT',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Phạm Ngọc Liêm',
      'designation': 'IT',
      'date': '17 Aug 2021',
      'inTime': '09:00 AM',
      'outTime': '05:00 PM',
      'status': 'Approved',
      'profileImage': 'https://via.placeholder.com/150',
    },

  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, 
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("Request", 0),
                _buildTabButton("Approve", 1),
              ],
            ),
          ),
          TimeCardList(timeCardData: timeCardData)
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedTabIndex == index ? Colors.blue : Colors.grey[300],
          foregroundColor:
              _selectedTabIndex == index ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}

class TimeCardList extends StatelessWidget {
  final List<Map<String, String>> timeCardData;

  TimeCardList({required this.timeCardData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: timeCardData.length,
        itemBuilder: (context, index) {
          final data = timeCardData[index];
          return TimeCard(
            name: data['name']!,
            designation: data['designation']!,
            date: data['date']!,
            inTime: data['inTime']!,
            outTime: data['outTime']!,
            status: data['status']!,
            profileImage: data['profileImage']!,
          );
        },
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  final String name;
  final String designation;
  final String date;
  final String inTime;
  final String outTime;
  final String status;

  final String profileImage;

  TimeCard({
    required this.name,
    required this.designation,
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.status,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12), 
        margin: EdgeInsets.only(bottom: 12), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(profileImage),
                ),
                SizedBox(width: 12), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1, 
                      ),
                      Text(
                        designation,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date',
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12)), 
                    Text(date, style: TextStyle(fontSize: 12)), 
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('In Time',
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12)), 
                    Text(inTime,
                        style: TextStyle(fontSize: 12)), 
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Out Time',
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12)), 
                    Text(outTime,
                        style: TextStyle(fontSize: 12)), 
                  ],
                ),
              ],
            ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status,
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
          ],
        ));
  }
}
