import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  String title;
  String? subttile;
  String? subttile1;
  Function? onTap;
  CustomCard(
      {super.key,
      required this.title,
      this.onTap,
      this.subttile,
      this.subttile1});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.subttile!,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            Text(
              widget.subttile1!,
              style: TextStyle(
                fontSize: 16.0,
                color: widget.subttile1!.contains("Từ Chối Duyệt")
                    ? Colors.red 
                    : widget.subttile1!.contains("Đợi Duyệt")
                        ? Colors.yellow 
                        : Colors
                            .green, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
