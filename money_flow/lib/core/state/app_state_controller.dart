import 'package:flutter/foundation.dart' show ChangeNotifier;
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

  List<Transaction> get transactions => _transactionController.transactions;

  List<Category> get categories {
    final loadedCategories = _categoryController.categories;
    return loadedCategories.isEmpty ? defaultCategories : loadedCategories;
  }

  bool get isLoadingTransactions => _transactionController.isLoading;

  bool get isLoadingCategories => _categoryController.isLoading;

  Future<void> load() async {
    await Future.wait([
      _transactionController.load(),
      _categoryController.load(),
    ]);
  }

  Future<void> addTransaction(Transaction transaction) {
    return _transactionController.add(transaction);
  }

  Future<void> deleteTransaction(String id) {
    return _transactionController.delete(id);
  }

  Future<void> saveCategory(Category category) {
    return _categoryController.save(category);
  }

  Future<void> deleteCategory(String id) {
    return _categoryController.delete(id);
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
}
