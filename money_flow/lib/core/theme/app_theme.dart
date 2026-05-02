import 'package:flutter/material.dart';
import 'package:money_flow/core/theme/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primarySeed,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.pageBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pageBackground,
        centerTitle: false,
        elevation: 0,
      ),
    );
  }
}
