import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundOfScreenColor,
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }
}