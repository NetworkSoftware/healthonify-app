import 'package:flutter/material.dart';

const whiteColor = Colors.white;

//use for appbar nav bar bottomsheets what not
const grey = Color(0xFF2E2B2B);

//used for cards and stuff
const darkGrey = Color.fromARGB(255, 31, 31, 33);

//orange
const orange = Color(0xFFec6a13);

final datePickerDarkTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.dark(
    onPrimary: Colors.black, // selected text color
    onSurface: whiteColor, // default text color
    primary: orange, // circle color
  ),
  dialogBackgroundColor: grey,
);

final datePickerLightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light(
    onPrimary: whiteColor, // selected text color
    onSurface: Colors.black, // default text color
    primary: orange, // circle color
  ),
  dialogBackgroundColor: whiteColor,
);

final customTimePickerTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: orange,
    onPrimary: whiteColor,
    onSurface: whiteColor,
    brightness: Brightness.dark,
  ),
);

class MyTheme {
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: orange,
      primaryContainer: Colors.blue.shade300,
      secondary: orange,
      background: Colors.black,
      onBackground: orange,
    ),
    unselectedWidgetColor: Colors.white,
    canvasColor: darkGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGrey,
      toolbarTextStyle: TextStyle(
        color: Color.fromARGB(255, 222, 18, 96),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: darkGrey,
      dayPeriodTextColor: whiteColor,
      // dayPeriodColor: whiteColor,
      dialBackgroundColor: grey,
      dialHandColor: orange,
      dialTextColor: whiteColor,
      hourMinuteColor: grey,
      hourMinuteTextColor: whiteColor,
      entryModeIconColor: orange,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: whiteColor,
        ),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: orange),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: grey,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.teal,
        )),
    scaffoldBackgroundColor: Colors.black,
    dialogBackgroundColor: Colors.black,
    tabBarTheme: TabBarTheme(
      labelPadding: const EdgeInsets.only(bottom: 6, top: 8),
      labelColor: whiteColor,
      unselectedLabelColor: Colors.grey[700],
      indicatorSize: TabBarIndicatorSize.label,
    ),
    fontFamily: 'OpenSans',
    drawerTheme: const DrawerThemeData(
      backgroundColor: grey,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: grey,
      selectedItemColor: orange,
      unselectedItemColor: Color(0xFF9E9E9E),
      type: BottomNavigationBarType.fixed,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    iconTheme: const IconThemeData(
      color: orange,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: darkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 16,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          orange,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            color: whiteColor,
            fontSize: 16,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          orange,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
    // checkboxTheme: CheckboxThemeData(),
    radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(
      orange,
    )),
    popupMenuTheme: const PopupMenuThemeData(
      color: grey,
      textStyle: TextStyle(
        color: whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: Colors.white,
        // color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        color: whiteColor,
        // color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        color: whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        color: whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        color: whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        color: whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        color: whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        color: whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        color: whiteColor,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: whiteColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        color: whiteColor,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        color: whiteColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        color: whiteColor,
        fontSize: 26,
        fontWeight: FontWeight.w300,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      displayMedium: TextStyle(
        color: whiteColor,
        fontSize: 26,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      displayLarge: TextStyle(
        color: whiteColor,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
    ),
  );

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: orange,
      primaryContainer: Colors.blue.shade300,
      secondary: Colors.blue[400]!,
      background: const Color(0xFFF6F6F6),
      onBackground: Colors.black,
    ),
    // canvasColor: const Color(0xFFF6F6F6),
    canvasColor: whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: orange,
      toolbarTextStyle: TextStyle(
        color: Color.fromARGB(255, 222, 18, 96),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Color(0xFFF6F6F6),
      dayPeriodTextColor: Colors.black,
      dayPeriodColor: Color(0xFFF6F6F6),
      dialBackgroundColor: Color(0xFFF6F6F6),
      dialHandColor: orange,
      dialTextColor: Colors.black,
      hourMinuteColor: Colors.white,
      hourMinuteTextColor: Colors.black,
      entryModeIconColor: orange,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: orange),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFFF6F6F6),
      filled: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.orange),
      ),
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.teal,
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFFF6F6F6),
    dialogBackgroundColor: const Color(0xFFF6F6F6),
    fontFamily: 'OpenSans',
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFFF6F6F6),
    ),
    tabBarTheme: TabBarTheme(
      labelPadding: const EdgeInsets.only(bottom: 6, top: 8),
      labelColor: whiteColor,
      unselectedLabelColor: Colors.grey[700],
      indicatorSize: TabBarIndicatorSize.label,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 16,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          orange,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            color: whiteColor,
            fontSize: 16,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          orange,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all<Color>(
        orange,
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: grey,
      textStyle: TextStyle(
        color: whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF6F6F6),
      selectedItemColor: orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: const Color(0xFFF6F6F6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    iconTheme: const IconThemeData(color: orange),
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: const ColorScheme.light(
        background: orange,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: Color(0xFF000080),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        color: Color(0xFF333333),
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF333333),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        color: Color(0xFF333333),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 22,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 24,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 26,
        fontWeight: FontWeight.w300,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      displayMedium: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 26,
        fontWeight: FontWeight.w500,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
      displayLarge: TextStyle(
        color: Color(0xFF171B1E),
        fontSize: 26,
        fontWeight: FontWeight.bold,
        fontFamily: 'OpenSans',
        letterSpacing: 0,
      ),
    ),
  );
}

Gradient purpleGradient = const LinearGradient(
  colors: [
    Color.fromARGB(255, 177, 122, 253),
    Color(0xFF8E4CED),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

Gradient orangeGradient = LinearGradient(
  colors: [
    Colors.orange.shade300,
    const Color(0xFFec6a13),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

Gradient blueGradient = LinearGradient(
  colors: [
    Colors.blue.shade300,
    Colors.blue,
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
