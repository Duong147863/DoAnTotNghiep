import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_languages.dart';
import 'package:nloffice_hrm/constant/app_theme.dart';
import 'package:nloffice_hrm/constant/internet_connect.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/views/route_service.dart' as router;
import 'package:nloffice_hrm/views/screen/add_position_screen.dart';
import 'package:nloffice_hrm/views/screen/add_profile_screen.dart';
import 'package:nloffice_hrm/views/screen/auth/login/login_screen.dart';
import 'package:nloffice_hrm/views/screen/home_screen.dart';
import 'package:nloffice_hrm/views/screen/employee_managment_screen.dart';
import 'package:nloffice_hrm/views/screen/list_department_screen.dart';
import 'package:nloffice_hrm/views/screen/list_dot_screen.dart';
import 'package:nloffice_hrm/views/screen/list_position_screen.dart';
import 'package:nloffice_hrm/views/screen/list_absents_screen.dart';
import 'package:nloffice_hrm/views/screen/list_employee_management_screen.dart';
import 'package:nloffice_hrm/views/screen/list_checkin_screen.dart';
import 'package:nloffice_hrm/views/screen/list_dot_screen.dart';
import 'package:nloffice_hrm/views/screen/list_employee_attend_list_screen.dart';
import 'package:nloffice_hrm/views/screen/list_profile_screen.dart';
import 'package:nloffice_hrm/views/screen/list_salary_screen.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:provider/provider.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
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
    runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<EnterprisesViewModel>(
            create: (context) => EnterprisesViewModel(),
          ),
          ChangeNotifierProvider<ProjectsViewModel>(
            create: (context) => ProjectsViewModel(),
          ),
          ChangeNotifierProvider<RelativesViewModel>(
            create: (context) => RelativesViewModel(),
          ),
          ChangeNotifierProvider<PositionsViewModel>(
            create: (context) => PositionsViewModel(),
          ),
          ChangeNotifierProvider<DeparmentsViewModel>(
            create: (context) => DeparmentsViewModel(),
          ),
          ChangeNotifierProvider<ProfilesViewModel>(
            create: (context) => ProfilesViewModel(),
          )
        ],
        child: const LocalizedApp(
          child: MainApp(),
        )));
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
          title: 'LDOffice',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: translator.delegates,
          locale: translator.activeLocale,
          supportedLocales: translator.locals(),
          onGenerateRoute: router.generateRoute,
          onUnknownRoute: (RouteSettings settings) {
            // open your app when is executed from outside when is terminated.
            return router.generateRoute(settings);
          },
          home: AddProfilePage(),
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
