import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:localize_and_translate/localize_and_translate.dart';

class AppStrings {
  AppStrings._();

  static const String baseUrlApi = "http://192.168.1.2:8000/api/v1/";

  static String notificationsKey = "notifications";
  static String SHARED_LOGGED = "USER_IS_LOGGED";
  static String SHARED_USER = "USER";
  static String SHARED_PASSWORD = "PASSWORD";

  static List<String> get Statuses {
    return [
      'pending'.tr(),
      'accepted'.tr(),
      'cancelled'.tr(),
    ];
  }

  static Future<String> ImagetoBase64(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    return base64.encode(bytes);
  }
}

