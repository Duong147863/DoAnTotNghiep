import 'package:flutter/material.dart';
import 'package:nloffice_hrm/view_models/absent_view_model.dart';
import 'package:nloffice_hrm/view_models/assignment_view_model.dart';
import 'package:nloffice_hrm/view_models/deparments_view_model.dart';
import 'package:nloffice_hrm/view_models/diplomas_view_model.dart';
import 'package:nloffice_hrm/view_models/enterprises_view_model.dart';
import 'package:nloffice_hrm/view_models/hirings_view_model.dart';
import 'package:nloffice_hrm/view_models/insurance_view_model.dart';
import 'package:nloffice_hrm/view_models/labor_contact_view_model.dart';
import 'package:nloffice_hrm/view_models/positions_view_model.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';
import 'package:nloffice_hrm/view_models/projects_view_model.dart';
import 'package:nloffice_hrm/view_models/relatives_view_model.dart';
import 'package:nloffice_hrm/view_models/roles_view_models.dart';
import 'package:nloffice_hrm/view_models/salaries_view_model.dart';
import 'package:nloffice_hrm/view_models/shifts_view_model.dart';
import 'package:nloffice_hrm/view_models/task_view_model.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:nloffice_hrm/view_models/trainingprocesses_view_model.dart';
import 'package:nloffice_hrm/view_models/workingprocesses_view_model.dart';
import 'package:nloffice_hrm/views/route_service.dart' as router;
import 'package:nloffice_hrm/views/screen/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService.clearIrrelevantNotificationChannels();
  // await NotificationService.initializeAwesomeNotification();
  // await NotificationService.listenToActions();

  // Run app!
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ProjectsViewModel>(
      create: (context) => ProjectsViewModel(),
    ),
    ChangeNotifierProvider<EnterprisesViewModel>(
      create: (context) => EnterprisesViewModel(),
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
    ),
    ChangeNotifierProvider<InsuranceViewModel>(
      create: (context) => InsuranceViewModel(),
    ),
    ChangeNotifierProvider<TaskViewModel>(
      create: (context) => TaskViewModel(),
    ),
    ChangeNotifierProvider<AssignmentsViewModel>(
      create: (context) => AssignmentsViewModel(),
    ),
    ChangeNotifierProvider<RolesViewModels>(
      create: (context) => RolesViewModels(),
    ),
    ChangeNotifierProvider<HiringsViewModel>(
      create: (context) => HiringsViewModel(),
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
