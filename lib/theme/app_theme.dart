import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  ThemeData get light => _base(LightColor());

  ThemeData _base(AppColors color) {
    return ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: color.primary,
        foregroundColor: color.accent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: color.white,
        elevation: 2,
        centerTitle: true,
      ),
      // TextEditingController
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: color.primary),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color.primary),
        ),
      ),
      // default
      primaryTextTheme: TextTheme(
        labelLarge: GoogleFonts.roboto(
          fontSize: 48,
          color: color.primary,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.roboto(
          fontSize: 20,
          color: color.primary,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.roboto(
          fontSize: 14,
          color: color.richBlack,
          fontWeight: FontWeight.w500,
        ),
      ),

      useMaterial3: true,
      extensions: [color],
      scaffoldBackgroundColor: color.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color.primary),
          foregroundColor: WidgetStatePropertyAll(color.white),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      // DropdownMenu Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: color.white,
          labelStyle: TextStyle(color: color.primary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.primary, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color.primary, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textStyle: GoogleFonts.publicSans(
          fontSize: 16,
          color: color.richBlack,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(color.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
