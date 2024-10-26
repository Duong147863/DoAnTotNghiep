import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_route.dart';
import 'package:nloffice_hrm/views/custom_widgets/token_widget_item.dart';
import 'package:nloffice_hrm/views/screen/add_profile_screen.dart';
import 'package:nloffice_hrm/views/screen/auth/forgot_password/forgot_password_screen.dart';
import 'package:nloffice_hrm/views/screen/auth/login/login_screen.dart';
import 'package:nloffice_hrm/views/screen/home_screen.dart';
import 'package:nloffice_hrm/views/screen/info_department_screen.dart';
import 'package:nloffice_hrm/views/screen/language_screen.dart';
import 'package:nloffice_hrm/views/screen/list_checkin_screen.dart';
import 'package:nloffice_hrm/views/screen/list_decision_screen.dart';
import 'package:nloffice_hrm/views/screen/list_department_screen.dart';
import 'package:nloffice_hrm/views/screen/list_diploma_screen.dart';
import 'package:nloffice_hrm/views/screen/employee_managment_screen.dart';
import 'package:nloffice_hrm/views/screen/list_enterprises_screen.dart';
import 'package:nloffice_hrm/views/screen/list_position_screen.dart';
import 'package:nloffice_hrm/views/screen/list_profile_screen.dart';
import 'package:nloffice_hrm/views/screen/list_project_screen.dart';
import 'package:nloffice_hrm/views/screen/list_relative_screen.dart';
import 'package:nloffice_hrm/views/screen/list_salary_screen.dart';
import 'package:nloffice_hrm/views/screen/more_setting_screen.dart';
import 'package:nloffice_hrm/views/screen/notification_screen.dart';
import 'package:nloffice_hrm/views/screen/profile_screen.dart';
import 'package:nloffice_hrm/views/screen/sign_up_screen.dart';
import 'package:nloffice_hrm/views/screen/welcome_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.homeRoute:
      return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          settings: const RouteSettings(
            name: AppRoutes.homeRoute,
          ));
    ////
    case AppRoutes.welcomeRoute:
      return MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
          settings: const RouteSettings(
            name: AppRoutes.welcomeRoute,
          ));

    ///
    case AppRoutes.loginRoute:
      return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          settings: const RouteSettings(
            name: AppRoutes.loginRoute,
          ));

    ///
    case AppRoutes.forgotPasswordRoute:
      return MaterialPageRoute(
          builder: (context) => const ForgePasswordScreen(),
          settings: const RouteSettings(
            name: AppRoutes.forgotPasswordRoute,
          ));

    ///
    case AppRoutes.profileRoute:
      return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
          settings: const RouteSettings(
            name: AppRoutes.profileRoute,
          ));

    ///
    case AppRoutes.signupRoute:
      return MaterialPageRoute(
          builder: (context) => const CreateAcount(),
          settings: const RouteSettings(
            name: AppRoutes.signupRoute,
          ));

    ///
    case AppRoutes.homeRoute:
      return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          settings: const RouteSettings(
            name: AppRoutes.homeRoute,
          ));

    ///
    case AppRoutes.noconnetionRoute:
      return MaterialPageRoute(
          builder: (context) => const NotificationScreen(),
          settings: const RouteSettings(
            name: AppRoutes.noconnetionRoute,
          ));

    ///
    case AppRoutes.employeelistRoute:
      return MaterialPageRoute(
          builder: (context) => const EmployeeListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.employeelistRoute,
          ));

    ///
    case AppRoutes.languageRoute:
      return MaterialPageRoute(
          builder: (context) => const LanguageScreen(),
          settings: const RouteSettings(
            name: AppRoutes.languageRoute,
          ));

    ///
    case AppRoutes.tokenRoute:
      return MaterialPageRoute(
        builder: (context) => const MyDismissibleList(),
        settings: const RouteSettings(
          name: AppRoutes.tokenRoute,
        ),
      );

    ///
    case AppRoutes.profileListRoute:
      return MaterialPageRoute(
          builder: (context) => EmployeeListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.profileListRoute,
          ));

    ///
    case AppRoutes.departmentListRoute:
      return MaterialPageRoute(
          builder: (context) => DepartmentsScreen(),
          settings: const RouteSettings(
            name: AppRoutes.departmentListRoute,
          ));

    ///
    case AppRoutes.salariListRoute:
      return MaterialPageRoute(
          builder: (context) => SalaryListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.salariListRoute,
          ));

    ///
    case AppRoutes.diplomaListRoute:
      return MaterialPageRoute(
          builder: (context) => DiplomaListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.diplomaListRoute,
          ));

    ///
    case AppRoutes.relativeListRoute:
      return MaterialPageRoute(
          builder: (context) => RelativeListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.relativeListRoute,
          ));

    ///
    case AppRoutes.enterpriseListRoute:
      return MaterialPageRoute(
          builder: (context) => EnterprisesListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.enterpriseListRoute,
          ));

    ///
    case AppRoutes.positionListRoute:
      return MaterialPageRoute(
          builder: (context) => PositionsListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.positionListRoute,
          ));

    ///
    case AppRoutes.projectListRoute:
      return MaterialPageRoute(
          builder: (context) => ProjectsListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.projectListRoute,
          ));

    ///
    case AppRoutes.decisionListRoute:
      return MaterialPageRoute(
          builder: (context) => DecisionsListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.decisionListRoute,
          ));

    case AppRoutes.addprofileRoute:
      return MaterialPageRoute(
          builder: (context) => AddProfilePage(),
          settings: const RouteSettings(
            name: AppRoutes.addprofileRoute,
          ));
    ///
    case AppRoutes.departmentDetailRoute:
      return MaterialPageRoute(
          builder: (context) => DepartmentInfoScreen(),
          settings: const RouteSettings(
            name: AppRoutes.departmentDetailRoute,
          ));

     case AppRoutes.checkinListRoute:
      return MaterialPageRoute(
          builder: (context) => CheckinScreen(),
          settings: const RouteSettings(
            name: AppRoutes.checkinListRoute,
          ));
    ///
      case AppRoutes.employeeListRoute:
      return MaterialPageRoute(
          builder: (context) => EmployeeListScreen(),
          settings: const RouteSettings(
            name: AppRoutes.employeeListRoute,
          ));
    ///
    default:
      return MaterialPageRoute(builder: ((context) => LoginScreen()));
  }
}
