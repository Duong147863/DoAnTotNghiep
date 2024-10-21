import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_languages.dart';
import 'package:nloffice_hrm/constant/app_theme.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/route_service.dart' as router;
import 'package:nloffice_hrm/views/screen/add_profile_screen.dart';
import 'package:nloffice_hrm/views/screen/auth/login/login_screen.dart';
import 'package:nloffice_hrm/views/screen/home_screen.dart';
import 'package:nloffice_hrm/views/screen/list_absents.dart';
import 'package:nloffice_hrm/views/screen/list_account_screen.dart';
import 'package:nloffice_hrm/views/screen/list_dot_screen.dart';
import 'package:nloffice_hrm/views/screen/list_profile_screen.dart';
import 'package:nloffice_hrm/views/screen/list_salary_screen.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await translator.init(
        assetsDirectory: 'assets/lang',
        languagesList: AppLanguages.codes,
        localeType: LocalizationDefaultType.asDefined);
    // await NotificationService.clearIrrelevantNotificationChannels();
    // await NotificationService.initializeAwesomeNotification();
    // await NotificationService.listenToActions();
    //prevent ssl error
    // HttpOverrides.global = new MyHttpOverrides();
    // Run app!
    runApp(LocalizedApp(
        child: ChangeNotifierProvider(
            create: (context) => ProfilesViewModel(), child: MainApp())));
  }, (error, stack) {});
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: AdaptiveThemeMode.system, // đồng bộ với chế độ màu nền thiết bị
      builder: (theme, darkTheme) {
        return MaterialApp(
          title: 'NLOffice',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: translator.delegates,
          locale: translator.activeLocale,
          supportedLocales: translator.locals(),
          onGenerateRoute: router.generateRoute,
          onUnknownRoute: (RouteSettings settings) {
            // open your app when is executed from outside when is terminated.
            return router.generateRoute(settings);
          },
          home: EmployeeListScreen(),
          theme: theme,
          darkTheme: darkTheme,
        );
      },
    );
  }
}

// Future<void> getDeviceId() async {R
//   var deviceInfo = DeviceInfoPlugin();
//   if (Platform.isIOS) {
//     // import 'dart:io'
//     var iosDeviceInfo = await deviceInfo.iosInfo;
//     final result =
//         '${iosDeviceInfo.name}-${iosDeviceInfo.model}-${iosDeviceInfo.identifierForVendor}';
//     SPUtill.setValue(SPUtill.keyIosDeviceToken, result);
//     // return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//   } else {
//     final androidDeviceInfo = await deviceInfo.androidInfo;
//     final result =
//         '${androidDeviceInfo.brand}-${androidDeviceInfo.device}-${androidDeviceInfo.id}';
//     SPUtill.setValue(SPUtill.keyAndroidDeviceToken, result);
//     final map = androidDeviceInfo.toMap();
//     print('Device Map: $map');
//     // return androidDeviceInfo.androidId; // unique ID on Android
//   }
// }
