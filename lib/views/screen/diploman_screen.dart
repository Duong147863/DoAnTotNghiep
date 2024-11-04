import 'package:flutter/material.dart';

class DiplomaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bằng Tốt Nghiệp Trung Cấp'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'BẰNG TỐT NGHIỆP TRUNG CẤP',
                style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Công Nghệ Thông Tin',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(height: 20),
            Text('Cho: Nguyễn Bình Dương', style: TextStyle(fontSize: 16)),
            Text('Giới tính: Nam', style: TextStyle(fontSize: 16)),
            Text('Ngày sinh: 15/4/2003', style: TextStyle(fontSize: 16)),
            Text('Xếp hạng: 1', style: TextStyle(fontSize: 16)),
            Text('Xếp loại tốt nghiệp: Giỏi', style: TextStyle(fontSize: 16)),
            Text('Được cấp bởi: Cao đẳng kỹ thuật Cao Thắng', style: TextStyle(fontSize: 16)),
            Text('Hình thức đào tạo: Chính quy', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    'Hiệu trưởng',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Trịnh Văn Thắng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Số hiệu: 2008/2147/2019', style: TextStyle(fontSize: 14)),
            Text('Sổ vào cấp bằng: 2147', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
