import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/state/app_state_controller.dart';
import 'package:money_flow/features/category/data/category_repository.dart';
import 'package:money_flow/features/category/data/default_categories.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/data/static_transactions.dart';
import 'package:money_flow/features/transaction/data/transaction_repository.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

void main() {
  late _MemoryTransactionRepository transactionRepository;
  late _MemoryCategoryRepository categoryRepository;
  late AppStateController controller;

  setUp(() {
    transactionRepository = _MemoryTransactionRepository(staticTransactions);
    categoryRepository = _MemoryCategoryRepository(defaultCategories);
    controller = AppStateController(
      transactionRepository: transactionRepository,
      categoryRepository: categoryRepository,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  test('loads transactions and categories together', () async {
    await controller.load();

    expect(controller.transactions, hasLength(staticTransactions.length));
    expect(controller.categories, hasLength(defaultCategories.length));
    expect(controller.isLoadingTransactions, false);
    expect(controller.isLoadingCategories, false);
  });

  test('updates transaction state through repository actions', () async {
    await controller.load();
    await controller.addTransaction(
      Transaction(
        id: 'tx-test',
        title: '测试',
        categoryId: 'food',
        amountCents: 1200,
        type: TransactionType.expense,
        date: DateTime(2026, 5, 3),
      ),
    );

    expect(controller.transactions.first.id, 'tx-test');

    await controller.deleteTransaction('tx-test');

    expect(
      controller.transactions.any((transaction) => transaction.id == 'tx-test'),
      false,
    );
  });

  test('updates category state through repository actions', () async {
    await controller.load();
    await controller.saveCategory(
      const Category(id: 'shopping', name: '购物', type: TransactionType.expense),
    );

    expect(
      controller.categories.any((category) => category.name == '购物'),
      true,
    );

    await controller.deleteCategory('shopping');

    expect(
      controller.categories.any((category) => category.id == 'shopping'),
      false,
    );
  });

  test('falls back to default categories before storage load returns data', () {
    controller.dispose();
    controller = AppStateController(
      transactionRepository: transactionRepository,
      categoryRepository: _MemoryCategoryRepository(const []),
    );

    expect(controller.categories, defaultCategories);
  });

  test('filters visible transactions by selected month', () async {
    await controller.load();

    expect(
      controller.selectedMonthTransactions.every(
        (transaction) => transaction.date.month == DateTime.now().month,
      ),
      true,
    );

    controller.previousMonth();

    expect(
      controller.selectedMonthTransactions.every(
        (transaction) => transaction.date.month == DateTime.now().month - 1,
      ),
      true,
    );
  });

  test('toggles dark mode without widget state', () {
    expect(controller.themeMode, ThemeMode.light);

    controller.setDarkMode(true);

    expect(controller.themeMode, ThemeMode.dark);
    expect(controller.isDarkMode, true);
  });

  test('captures repository failures as user-facing errors', () async {
    controller.dispose();
    controller = AppStateController(
      transactionRepository: _FailingTransactionRepository(),
      categoryRepository: categoryRepository,
    );

    await controller.load();

    expect(controller.errorMessage, AppStrings.loadFailed);

    controller.clearError();

    expect(controller.errorMessage, isNull);
  });
}

class _MemoryTransactionRepository implements TransactionRepository {
  _MemoryTransactionRepository(Iterable<Transaction> transactions)
    : transactions = [...transactions];

  final List<Transaction> transactions;

  @override
  Future<void> deleteTransaction(String id) async {
    transactions.removeWhere((transaction) => transaction.id == id);
  }

  @override
  Future<List<Transaction>> loadTransactions() async {
    return [...transactions]
      ..sort((left, right) => right.date.compareTo(left.date));
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    transactions.add(transaction);
  }
}

class _FailingTransactionRepository implements TransactionRepository {
  @override
  Future<void> deleteTransaction(String id) async {
    throw StateError('delete failed');
  }

  @override
  Future<List<Transaction>> loadTransactions() async {
    throw StateError('load failed');
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    throw StateError('save failed');
  }
}

class _MemoryCategoryRepository implements CategoryRepository {
  _MemoryCategoryRepository(Iterable<Category> categories)
    : categories = [...categories];

  final List<Category> categories;

  @override
  Future<void> deleteCategory(String id) async {
    categories.removeWhere((category) => category.id == id);
  }

  @override
  Future<List<Category>> loadCategories() async {
    return [...categories];
  }

  @override
  Future<void> saveCategory(Category category) async {
    final index = categories.indexWhere((item) => item.id == category.id);
    if (index == -1) {
      categories.add(category);
      return;
    }
    categories[index] = category;
  }
}
