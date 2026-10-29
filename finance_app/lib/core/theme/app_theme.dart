import 'package:flutter/material.dart';
import 'dark_theme.dart';
import '../constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.success,
      error: AppColors.danger,
      background: AppColors.backgroundLight,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.cardLight,
    textTheme: GoogleFonts.interTextTheme(),
    fontFamily: 'Inter',
  );

  static final ThemeData darkTheme = DarkTheme.build();
}
