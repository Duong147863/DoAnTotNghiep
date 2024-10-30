import 'package:localize_and_translate/localize_and_translate.dart';

class AppStrings {
  AppStrings._();

  static const String baseUrlApi = "http://192.168.1.38:8000/api/v1/";

  static String notificationsKey = "notifications";

  static List<String> get Statuses {
    return [
      'pending'.tr(),
      'accepted'.tr(),
      'cancelled'.tr(),
    ];
  }
}
