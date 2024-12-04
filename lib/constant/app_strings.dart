import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class AppStrings {
  AppStrings._();

  static const String baseUrlApi = "http://192.168.20.251:8000/api/v1/";

  static String notificationsKey = "notifications";
  static String SHARED_LOGGED = "USER_IS_LOGGED";
  static String SHARED_USER = "USER";
  static String SHARED_PASSWORD = "PASSWORD";
  static String TOKEN = "TOKEN";
  static List<String> ROLE_PERMISSIONS = [];

  // static Future<String> ImagetoBase64(File imageFile) async {
  //   Uint8List bytes = await imageFile.readAsBytes();
  //   return base64.encode(bytes);
  // }
  static Future<String> ImagetoBase64(File imageFile) async {
    // Nén ảnh
    var result = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minWidth: 600, // Điều chỉnh kích thước ảnh
      minHeight: 600, // Điều chỉnh kích thước ảnh
      quality: 80, // Giảm chất lượng để nén dung lượng ảnh
    );

    // Chuyển ảnh nén thành chuỗi Base64
    String base64String = base64Encode(result!);

    return base64String;
  }
}
