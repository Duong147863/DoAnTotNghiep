import 'package:flutter/material.dart';

class SalaryIncreaseDecisionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quyết định tăng lương'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CÔNG TY .......'),
                    Text('Số: .... /20.... - QĐ-TL'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Độc lập - Tự do - Hạnh phúc',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: Text('...., ngày ... tháng ... năm 20...'),
            ),
            SizedBox(height: 24.0),
            // Title
            Center(
              child: Text(
                'QUYẾT ĐỊNH',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Center(
              child: Text('Về việc tăng lương cho Nhân viên'),
            ),
            SizedBox(height: 24.0),
            // Content
            Text(
                '- Căn cứ vào quy chế lương thưởng và Điều lệ hoạt động của công ty ..............'),
            Text(
                '- Căn cứ vào hợp đồng lao động số.../HĐLĐ... ngày ... tháng ... năm 20....'),
            Text(
                '- Căn cứ những đóng góp thực tế của Ông (Bà) ... đối với sự phát triển của Công ty.'),
            Text('- Xét đề nghị của trưởng phòng hành chính nhân sự.'),
            SizedBox(height: 24.0),
            Center(
              child: Text(
                'GIÁM ĐỐC CÔNG TY .................',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: Text(
                'QUYẾT ĐỊNH',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(height: 16.0),
            // Decision
            Text('Điều 1: Tăng lương cho nhân viên: ....................'),
            Text(
                '- Mức lương chính của nhân viên .......... đang thỏa thuận tại hợp đồng lao động số.../HĐLĐ... ngày ... tháng ... năm 20.... là: ................. (Bằng chữ: .................)'),
            Text(
                '- Điều chỉnh mức lương chính nhân viên ............ sẽ được tăng thêm: ................. (Bằng chữ: ................)'),
            Text(
                '- Kể từ ngày ... tháng ... năm ...., mức lương chính của Ông (Bà) sẽ là: ................. (Bằng chữ: ........ triệu đồng).'),
            SizedBox(height: 24.0),
            Text(
                'Điều 2: Các ông/bà Phòng Nhân sự Phòng Tài chính Kế toán và Ông/Bà ............ căn cứ quyết định thi hành.'),
            SizedBox(height: 24.0),
            // Signature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nơi nhận:'),
                    Text('- TỔNG GIÁM ĐỐC'),
                    Text('- Như Điều 2'),
                    Text('- Lưu HS, HC'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('GIÁM ĐỐC',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text('(Ký tên, đóng dấu)'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
