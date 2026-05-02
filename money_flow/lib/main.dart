import 'package:flutter/material.dart';
import 'package:money_flow/app.dart';
import 'package:money_flow/features/transaction/data/hive_transaction_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final transactionRepository = await HiveTransactionRepository.open();

  runApp(MoneyFlowApp(transactionRepository: transactionRepository));
}
