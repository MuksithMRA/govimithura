import 'package:flutter/material.dart';

const Color primaryColor = Colors.green;
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryTextTheme: const TextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  drawerTheme: const DrawerThemeData(
    elevation: 0,
    backgroundColor: Colors.white,
    endShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  primaryColor: primaryColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.black,
    selectedIconTheme: IconThemeData(
      color: primaryColor,
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.black,
    ),
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.w600,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primaryColor),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);
