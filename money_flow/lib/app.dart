import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_theme.dart';
import 'package:money_flow/features/home/presentation/home_page.dart';

class MoneyFlowApp extends StatelessWidget {
  const MoneyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}
