import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/state/app_state_controller.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/core/theme/app_theme.dart';
import 'package:money_flow/features/category/data/category_repository.dart';
import 'package:money_flow/features/home/presentation/home_page.dart';
import 'package:money_flow/features/settings/presentation/settings_page.dart';
import 'package:money_flow/features/statistics/presentation/statistics_page.dart';
import 'package:money_flow/features/transaction/data/transaction_repository.dart';
import 'package:money_flow/features/transaction/presentation/add_transaction_page.dart';
import 'package:money_flow/features/transaction/presentation/records_page.dart';

class MoneyFlowApp extends StatefulWidget {
  const MoneyFlowApp({
    required this.transactionRepository,
    required this.categoryRepository,
    super.key,
  });

  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;

  @override
  State<MoneyFlowApp> createState() => _MoneyFlowAppState();
}

class _MoneyFlowAppState extends State<MoneyFlowApp> {
  late final AppStateController _appStateController;

  @override
  void initState() {
    super.initState();
    _appStateController = AppStateController(
      transactionRepository: widget.transactionRepository,
      categoryRepository: widget.categoryRepository,
    )..load();
  }

  @override
  void dispose() {
    _appStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appStateController,
      builder: (context, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _appStateController.themeMode,
          home: _AppShell(appStateController: _appStateController),
        );
      },
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell({required this.appStateController});

  final AppStateController appStateController;

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _selectedIndex = 0;

  AppStateController get _appStateController => widget.appStateController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appStateController,
      builder: (context, _) {
        final transactions = _appStateController.selectedMonthTransactions;
        final categories = _appStateController.categories;
        final pages = [
          HomePage(
            transactions: transactions,
            categories: categories,
            isLoading: _appStateController.isLoadingTransactions,
            selectedMonth: _appStateController.selectedMonth,
            onPreviousMonth: _appStateController.previousMonth,
            onNextMonth: _appStateController.nextMonth,
          ),
          RecordsPage(
            transactions: transactions,
            categories: categories,
            isLoading: _appStateController.isLoadingTransactions,
            selectedMonth: _appStateController.selectedMonth,
            onPreviousMonth: _appStateController.previousMonth,
            onNextMonth: _appStateController.nextMonth,
            onDeleteTransaction: _appStateController.deleteTransaction,
          ),
          AddTransactionPage(
            categories: categories,
            onSaveTransaction: _appStateController.addTransaction,
          ),
          StatisticsPage(
            transactions: transactions,
            categories: categories,
            selectedMonth: _appStateController.selectedMonth,
            onPreviousMonth: _appStateController.previousMonth,
            onNextMonth: _appStateController.nextMonth,
          ),
          SettingsPage(
            categories: categories,
            isLoadingCategories: _appStateController.isLoadingCategories,
            isDarkMode: _appStateController.isDarkMode,
            onDarkModeChanged: _appStateController.setDarkMode,
            onSaveCategory: _appStateController.saveCategory,
            onDeleteCategory: _appStateController.deleteCategory,
          ),
        ];

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.appName)),
          body: Column(
            children: [
              if (_appStateController.errorMessage != null)
                _ErrorBanner(
                  message: _appStateController.errorMessage!,
                  onRetry: _appStateController.load,
                  onClose: _appStateController.clearError,
                ),
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: pages),
              ),
            ],
          ),
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

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    required this.onRetry,
    required this.onClose,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: AppRadii.card,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
            ),
            TextButton(onPressed: onRetry, child: const Text(AppStrings.retry)),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              tooltip: AppStrings.cancel,
            ),
          ],
        ),
      ),
    );
  }
}
