import 'package:flutter/material.dart';
import 'package:nloffice_hrm/constant/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppTheme {
  //
  static final lightTheme = ThemeData(
      primaryColor: AppColor.primaryLightColor,
      fontFamily: GoogleFonts.roboto().fontFamily,
      brightness: Brightness.light,
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
        ),
      ),
      // scaffoldBackgroundColor: ,
      useMaterial3: true,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(
            (states) => AppColor.seaShell),
      ),
      appBarTheme: AppBarTheme());

  //
  static final darkTheme = ThemeData(
    fontFamily: GoogleFonts.roboto().fontFamily,
    primaryColor: AppColor.primaryDarkColor,
    // primaryColorDark: AppColor.primaryColorDark,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.grey,
      // cursorColor: AppColor.cursorColor,
      selectionHandleColor: Colors.transparent,
    ),
    cardColor: Colors.grey[700],
    textTheme: TextTheme(
      displaySmall: TextStyle(
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.black,
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(
          // primary: AppColor.primaryColor,
          // secondary: AppColor.accentColor,
          brightness: Brightness.dark,
        )
        .copyWith(
            // primary: AppColor.primaryMaterialColor,
            background: Colors.grey[850]),
  );
}
