import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_list_view.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constant/app_color.dart';

/// Example without a datasource
class TimeAttendanceTable extends StatefulWidget {
  const TimeAttendanceTable();

  @override
  State<TimeAttendanceTable> createState() => _TimeAttendanceTableState();
}

class _TimeAttendanceTableState extends State<TimeAttendanceTable> {
  DateTime now = DateTime.now();
  // Lấy ngày đầu và cuối tuần này
  DateTime startOfWeek = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - 1)); // Thứ 2
  DateTime endOfWeek = DateTime.now()
      .add(Duration(days: 7 - DateTime.now().weekday)); // Chủ nhật
  // Lấy ngày đầu và cuối tháng này
  DateTime startOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endOfMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
          .subtract(Duration(days: 1));
  // Format ngày nếu cần
  String formatDatetoJson(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);
  String formatDatetoUI(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  // Hàm chuyển sang tuần trước
  void _previousWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(Duration(days: 7));
      endOfWeek = endOfWeek.subtract(Duration(days: 7));
    });
  }

  // Hàm chuyển sang tuần tiếp theo
  void _nextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(Duration(days: 7));
      endOfWeek = endOfWeek.add(Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      bodyChildren: [
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              // TabBar
              Container(
                color: AppColor.primaryLightColor,
                child: TabBar(
                  // indicatorColor: AppColor.primaryColor,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: "Đang làm việc"),
                    Tab(text: "Đi trễ"),
                    Tab(text: "Tăng ca"),
                  ],
                ),
              ),
              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back_rounded)
                              .onInkTap(_previousWeek),
                          Text("Tuần ${formatDatetoUI(startOfWeek)} - ${formatDatetoUI(endOfWeek)}")
                              .px32(),
                          const Icon(Icons.arrow_forward_rounded)
                              .onInkTap(_nextWeek),
                        ],
                      ).py4(),
                      Consumer<TimeKeepingViewModel>(
                          builder: (context, viewModel, child) {
                        Provider.of<TimeKeepingViewModel>(context,
                                listen: false)
                            .getLateEmployees(formatDatetoJson(startOfWeek),
                                formatDatetoJson(endOfWeek));
                        return CustomListView(
                            dataSet: [],
                            itemBuilder: (context, index) {
                              return Card();
                            });
                      })
                    ]),
                    Column(
                      children: [
                        //   Consumer<TimeKeepingViewModel>(
                        //     builder: (context, viewModel, child) {
                        //       Provider.of<TimeKeepingViewModel>(context,listen: false)
                        //   return CustomListView(
                        //       dataSet: [],
                        //       itemBuilder: (context, index) {
                        //         return Card();
                        //       });
                        // })
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: DataTable2(
        //       columnSpacing: 12,
        //       horizontalMargin: 12,
        //       minWidth: 600,
        //       columns: [
        //         DataColumn2(
        //           label: Text('Mã NV'),
        //           size: ColumnSize.L,
        //         ),
        //         DataColumn(
        //           label: Text('Ngày'),
        //         ),
        //         DataColumn(
        //           label: Text('Giờ vào'),
        //         ),
        //         DataColumn(
        //           label: Text('Giờ ra'),
        //         ),
        //         DataColumn(
        //           label: Text('Số giờ công'),
        //           numeric: true,
        //         ),
        //         DataColumn(
        //           label: Text('Trễ'),
        //           numeric: true,
        //         ),
        //       ],
        //       rows: List<DataRow>.generate(
        //           100,
        //           (index) => DataRow(cells: [
        //                 DataCell(Text('Mã NV')),
        //               ]))),
        // )
      ],
    );
  }
}
