import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:nloffice_hrm/constant/app_languages.dart';
import 'package:nloffice_hrm/constant/internet_connect.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/diplomas_view_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/views/route_service.dart' as router;
import 'package:nloffice_hrm/views/screen/add_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/add_salary_screen.dart';
import 'package:nloffice_hrm/views/screen/diploman_screen.dart';
import 'package:nloffice_hrm/views/screen/add_absent_request_screen.dart';
import 'package:nloffice_hrm/views/screen/add_department_screen.dart';
import 'package:nloffice_hrm/views/screen/add_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/add_position_screen.dart';
import 'package:nloffice_hrm/views/screen/add_profile_screen.dart';
import 'package:nloffice_hrm/views/screen/auth/login/login_screen.dart';
import 'package:nloffice_hrm/views/screen/info_salari_sceen.dart';
import 'package:nloffice_hrm/views/screen/list_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/salary_increase_decision.dart';
import 'package:nloffice_hrm/views/screen/home_screen.dart';
import 'package:nloffice_hrm/views/screen/employee_managment_screen.dart';
import 'package:nloffice_hrm/views/screen/info_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/list_department_screen.dart';
import 'package:nloffice_hrm/views/screen/list_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/list_dot_screen.dart';
import 'package:nloffice_hrm/views/screen/list_position_screen.dart';
import 'package:nloffice_hrm/views/screen/list_absents_screen.dart';
import 'package:nloffice_hrm/views/screen/payslipscreen.dart';
import 'package:nloffice_hrm/views/screen/profile_screen.dart';
import 'package:nloffice_hrm/views/screen/time_attendance_screen.dart';
import 'package:nloffice_hrm/views/screen/list_dot_screen.dart';
import 'package:nloffice_hrm/views/screen/leave_request_list_screen.dart';
import 'package:nloffice_hrm/views/screen/list_salary_screen.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/views/screen/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          ),
          ChangeNotifierProvider<DiplomasViewModel>(
            create: (context) => DiplomasViewModel(),
          ),
          ChangeNotifierProvider<SalariesViewModel>(
            create: (context) => SalariesViewModel(),
          ),
          ChangeNotifierProvider<AbsentsViewModel>(
            create: (context) => AbsentsViewModel(),
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
      home: LoginScreen(),
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
//     SPUtill.setValue(SPUtill.keyIosDeviceToken, result);SQ
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
