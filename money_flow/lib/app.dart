import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_theme.dart';
import 'package:money_flow/features/home/presentation/home_page.dart';
import 'package:money_flow/features/settings/presentation/settings_page.dart';
import 'package:money_flow/features/statistics/presentation/statistics_page.dart';
import 'package:money_flow/features/transaction/data/transaction_repository.dart';
import 'package:money_flow/features/transaction/presentation/add_transaction_page.dart';
import 'package:money_flow/features/transaction/presentation/records_page.dart';
import 'package:money_flow/features/transaction/presentation/transaction_controller.dart';

class MoneyFlowApp extends StatelessWidget {
  const MoneyFlowApp({required this.transactionRepository, super.key});

  final TransactionRepository transactionRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _AppShell(transactionRepository: transactionRepository),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell({required this.transactionRepository});

  final TransactionRepository transactionRepository;

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _selectedIndex = 0;
  late final TransactionController _transactionController;

  @override
  void initState() {
    super.initState();
    _transactionController = TransactionController(
      repository: widget.transactionRepository,
    )..load();
  }

  @override
  void dispose() {
    _transactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _transactionController,
      builder: (context, _) {
        final transactions = _transactionController.transactions;
        final pages = [
          HomePage(
            transactions: transactions,
            isLoading: _transactionController.isLoading,
          ),
          RecordsPage(
            transactions: transactions,
            isLoading: _transactionController.isLoading,
            onDeleteTransaction: _transactionController.delete,
          ),
          AddTransactionPage(onSaveTransaction: _transactionController.add),
          StatisticsPage(transactions: transactions),
          const SettingsPage(),
        ];

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.appName)),
          body: IndexedStack(index: _selectedIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: AppStrings.home,
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: AppStrings.records,
              ),
              NavigationDestination(
                icon: Icon(Icons.add_circle_outline),
                selectedIcon: Icon(Icons.add_circle),
                label: AppStrings.addTransaction,
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: AppStrings.statistics,
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: AppStrings.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
