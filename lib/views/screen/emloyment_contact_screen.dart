import 'package:flutter/material.dart';

class EmploymentContractScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Hợp Đồng Lao Động'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'HỢP ĐỒNG LAO ĐỘNG',
                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Căn cứ Bộ luật lao động ngày 20 tháng 11 năm 2019;\nCăn cứ vào nhu cầu của các Bên\n\nHôm nay, ngày... tháng... năm 2021, tại Công ty ..............., chúng tôi gồm:',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            buildPartySection('Bên A: Người sử dụng lao động', [
              'Công ty: ...................................................',
              'Địa chỉ: ...................................................',
              'Điện thoại: ...............................................',
              'Đại diện: ...................................  Chức vụ: ............',
            ]),
            SizedBox(height: 20),
            buildPartySection('Bên B: Người lao động', [
              'Ông/bà: ...................................................',
              'Quốc tịch: ...................................................',
              'Ngày sinh: ...................................................',
              'Nơi sinh: ....................................................',
              'Địa chỉ thường trú: ....................................',
              'Địa chỉ tạm trú: .........................................',
              'Số CMND/CCCD: ..................  Cấp ngày: ......',
            ]),
            SizedBox(height: 20),
            Text(
              'Cùng thoả thuận ký kết Hợp đồng lao động (HĐLĐ) và cam kết làm đúng những điều khoản sau đây:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildContractSection('Điều 1: Công việc, địa điểm làm việc và thời hạn của Hợp đồng', [
              '- Loại hợp đồng: ...........................................',
              '- Thử việc từ ngày ... đến ngày ...',
              '- Địa điểm làm việc: ...................................',
              '- Bộ phận công tác: .....................................',
              '- Nhiệm vụ công việc như sau:',
              '+ Thực hiện công việc theo đúng chức danh chuyên môn...',
              '+ Phối hợp công việc với các bộ phận...',
            ]),
            SizedBox(height: 20),
            buildContractSection('Điều 2: Lương, phụ cấp, các khoản bổ sung khác', [
              '- Lương căn bản: ................',
              '- Phụ cấp: .............................',
              '- Các khoản bổ sung khác: ................',
              '- Hình thức trả lương: ................',
              '- Thời hạn trả lương: ................',
            ]),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('NGƯỜI LAO ĐỘNG', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text('(Ký, ghi rõ họ tên)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Text('NGƯỜI SỬ DỤNG LAO ĐỘNG', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text('(Ký, ghi rõ họ tên)', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPartySection(String title, List<String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        for (var detail in details) Text(detail, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget buildContractSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        for (var item in items) Text(item, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
