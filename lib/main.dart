import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_languages.dart';
import 'package:nloffice_hrm/constant/internet_connect.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/diplomas_view_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/view_models/shifts_view_model.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:nloffice_hrm/view_models/trainingprocesses_view_model.dart';
import 'package:nloffice_hrm/view_models/workingprocesses_view_model.dart';
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
import 'package:nloffice_hrm/views/screen/emloyment_contact_screen.dart';
import 'package:nloffice_hrm/views/screen/info_salari_sceen.dart';
import 'package:nloffice_hrm/views/screen/list_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/salary_increase_decision.dart';
import 'package:nloffice_hrm/views/screen/home_screen.dart';
import 'package:nloffice_hrm/views/screen/employee_managment_screen.dart';
import 'package:nloffice_hrm/views/screen/info_diploma_screen.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService.clearIrrelevantNotificationChannels();
  // await NotificationService.initializeAwesomeNotification();
  // await NotificationService.listenToActions();
  // Run app!
  runApp(MultiProvider(providers: [
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
    ),
    ChangeNotifierProvider<ShiftsViewModel>(
      create: (context) => ShiftsViewModel(),
    ),
    ChangeNotifierProvider<ProjectsViewModel>(
      create: (context) => ProjectsViewModel(),
    ),
    ChangeNotifierProvider<LaborContactsViewModel>(
      create: (context) => LaborContactsViewModel(),
    ),
    ChangeNotifierProvider<WorkingprocessesViewModel>(
      create: (context) => WorkingprocessesViewModel(),
    ),
    ChangeNotifierProvider<TrainingprocessesViewModel>(
      create: (context) => TrainingprocessesViewModel(),
    ),
    ChangeNotifierProvider<TimeKeepingViewModel>(
      create: (context) => TimeKeepingViewModel(),
    )
  ], child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LDOffice',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
      onUnknownRoute: (RouteSettings settings) {
        // open your app when is executed from outside when is terminated.
        return router.generateRoute(settings);
      },
      home: WelcomeScreen(),
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
