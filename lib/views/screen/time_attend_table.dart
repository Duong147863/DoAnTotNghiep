import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Example without a datasource
class TimeAttendanceTable extends StatelessWidget {
  const TimeAttendanceTable();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          columns: [
            DataColumn2(
              label: Text('Mã NV'),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text('Ngày'),
            ),
            DataColumn(
              label: Text('Giờ vào'),
            ),
            DataColumn(
              label: Text('Giờ ra'),
            ),
            DataColumn(
              label: Text('Số giờ công'),
              numeric: true,
            ),
            DataColumn(
              label: Text('Trễ'),
              numeric: true,
            ),
          ],
          rows: List<DataRow>.generate(
              100,
              (index) => DataRow(cells: [
                    DataCell(Text('Mã NV')),
                  ]))),
    );
  }
}
