import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF4CAF50);
const kSecondaryColor = Color(0xFFe59a54);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFeceee6);
const kWhiteColor = Color(0xFFfbfcfa);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
const kOccasionalColor = Color(0xFF10f4b4);
const kDefaultPadding = 20.0;

final ThemeData lightThemeData = ThemeData(
  primaryColor: kPrimaryColor,
  fontFamily: "Intel",
  scaffoldBackgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: kContentColorLightTheme),
  colorScheme: const ColorScheme.light(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    error: kErrorColor,
    outline: kContentColorDarkTheme,
    surface: kOccasionalColor
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    errorStyle: TextStyle(height: 0),
    border: defaultInputBorder,
    enabledBorder: defaultInputBorder,
    focusedBorder: defaultInputBorder,
    errorBorder: defaultInputBorder,
  ),
);

final ThemeData darkThemeData = ThemeData(
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kContentColorLightTheme,
  iconTheme: const IconThemeData(color: kContentColorDarkTheme),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    error: kErrorColor,
    outline: kContentColorDarkTheme,
    surface: kOccasionalColor
  ),
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  ),
);

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
