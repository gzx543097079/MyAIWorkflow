import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/features/category/data/category_repository.dart';
import 'package:money_flow/features/category/data/default_categories.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/category/presentation/category_controller.dart';
import 'package:money_flow/features/transaction/data/transaction_repository.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/presentation/transaction_controller.dart';

class AppStateController extends ChangeNotifier {
  AppStateController({
    required TransactionRepository transactionRepository,
    required CategoryRepository categoryRepository,
  }) : _transactionController = TransactionController(
         repository: transactionRepository,
       ),
       _categoryController = CategoryController(
         repository: categoryRepository,
       ) {
    _transactionController.addListener(_notifyStateChanged);
    _categoryController.addListener(_notifyStateChanged);
  }

  final TransactionController _transactionController;
  final CategoryController _categoryController;

  var _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  var _themeMode = ThemeMode.light;
  String? _errorMessage;

  List<Transaction> get transactions => _transactionController.transactions;

  List<Transaction> get selectedMonthTransactions {
    return transactions
        .where((transaction) => _isSameMonth(transaction.date, _selectedMonth))
        .toList(growable: false);
  }

  List<Category> get categories {
    final loadedCategories = _categoryController.categories;
    return loadedCategories.isEmpty ? defaultCategories : loadedCategories;
  }

  bool get isLoadingTransactions => _transactionController.isLoading;

  bool get isLoadingCategories => _categoryController.isLoading;

  DateTime get selectedMonth => _selectedMonth;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    await _runOperation(
      () => Future.wait([
        _transactionController.load(),
        _categoryController.load(),
      ]),
      fallbackMessage: AppStrings.loadFailed,
    );
  }

  Future<void> addTransaction(Transaction transaction) {
    return _runOperation(
      () => _transactionController.add(transaction),
      fallbackMessage: AppStrings.operationFailed,
      rethrowError: true,
    );
  }

  Future<void> deleteTransaction(String id) {
    return _runOperation(
      () => _transactionController.delete(id),
      fallbackMessage: AppStrings.operationFailed,
      rethrowError: true,
    );
  }

  Future<void> saveCategory(Category category) {
    return _runOperation(
      () => _categoryController.save(category),
      fallbackMessage: AppStrings.operationFailed,
      rethrowError: true,
    );
  }

  Future<void> deleteCategory(String id) {
    return _runOperation(
      () => _categoryController.delete(id),
      fallbackMessage: AppStrings.operationFailed,
      rethrowError: true,
    );
  }

  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _transactionController.removeListener(_notifyStateChanged);
    _categoryController.removeListener(_notifyStateChanged);
    _transactionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _notifyStateChanged() {
    notifyListeners();
  }

  Future<void> _runOperation(
    Future<void> Function() operation, {
    required String fallbackMessage,
    bool rethrowError = false,
  }) async {
    _errorMessage = null;
    notifyListeners();
    try {
      await operation();
    } catch (_) {
      _errorMessage = fallbackMessage;
      notifyListeners();
      if (rethrowError) {
        rethrow;
      }
    }
  }
}

bool _isSameMonth(DateTime date, DateTime month) {
  return date.year == month.year && date.month == month.month;
}
