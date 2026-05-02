import 'package:flutter/material.dart';
import 'package:money_flow/app.dart';
import 'package:money_flow/features/category/data/hive_category_repository.dart';
import 'package:money_flow/features/transaction/data/hive_transaction_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final transactionRepository = await HiveTransactionRepository.open();
  final categoryRepository = await HiveCategoryRepository.open();

  runApp(
    MoneyFlowApp(
      transactionRepository: transactionRepository,
      categoryRepository: categoryRepository,
    ),
  );
}
