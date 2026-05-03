import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_flow/app.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/features/category/data/category_repository.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/data/static_transactions.dart';
import 'package:money_flow/features/transaction/data/transaction_repository.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

void main() {
  late _MemoryTransactionRepository transactionRepository;
  late _MemoryCategoryRepository categoryRepository;

  setUp(() {
    transactionRepository = _MemoryTransactionRepository(staticTransactions);
    categoryRepository = _MemoryCategoryRepository(staticCategories);
  });

  test('static data uses domain models', () {
    expect(staticCategories.first, isA<Category>());
    expect(staticTransactions.first, isA<Transaction>());
    expect(staticTransactions.first.type, TransactionType.expense);
    expect(staticCategoryFor(staticTransactions.first).name, '餐饮');
  });

  testWidgets('shows the V0.8 MoneyFlow app shell', (tester) async {
    await tester.pumpWidget(
      MoneyFlowApp(
        transactionRepository: transactionRepository,
        categoryRepository: categoryRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.monthlyOverview), findsOneWidget);
    expect(find.text(AppStrings.currentBalance), findsOneWidget);
    expect(find.text(AppStrings.home), findsOneWidget);
    expect(find.text(AppStrings.records), findsOneWidget);
    expect(find.text(AppStrings.addTransaction), findsOneWidget);
    expect(find.text(AppStrings.statistics), findsOneWidget);
    expect(find.text(AppStrings.settings), findsOneWidget);
  });

  testWidgets('switches to records page from bottom navigation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MoneyFlowApp(
        transactionRepository: transactionRepository,
        categoryRepository: categoryRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.records));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.allRecords), findsOneWidget);
    expect(find.text('工资'), findsWidgets);
  });

  testWidgets('shows statistics from real transactions', (tester) async {
    await tester.pumpWidget(
      MoneyFlowApp(
        transactionRepository: transactionRepository,
        categoryRepository: categoryRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.statistics));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.categoryOverview), findsOneWidget);
    expect(find.text('¥12800.00'), findsOneWidget);
    expect(find.text('¥66.00'), findsWidgets);
    expect(find.text('¥12734.00'), findsOneWidget);
    expect(find.text('¥60.00'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.spendingTrend), findsOneWidget);
    expect(find.text('¥22.00'), findsOneWidget);
    expect(find.text('¥44.00'), findsOneWidget);
  });

  testWidgets('saves a valid transaction through repository', (tester) async {
    await tester.pumpWidget(
      MoneyFlowApp(
        transactionRepository: transactionRepository,
        categoryRepository: categoryRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.addTransaction));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '12.34');
    await tester.enterText(find.byType(TextFormField).last, '测试晚餐');
    await tester.drag(find.byType(ListView).last, const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.saveRecord));
    await tester.pumpAndSettle();

    expect(
      transactionRepository.transactions.length,
      staticTransactions.length + 1,
    );
    expect(transactionRepository.transactions.last.amountCents, 1234);
    expect(transactionRepository.transactions.last.note, '测试晚餐');
    expect(find.text(AppStrings.recordSaved), findsOneWidget);
  });

  testWidgets('adds a custom expense category from settings', (tester) async {
    await tester.pumpWidget(
      MoneyFlowApp(
        transactionRepository: transactionRepository,
        categoryRepository: categoryRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(AppStrings.addCategory));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '购物');
    await tester.tap(find.text(AppStrings.save).last);
    await tester.pumpAndSettle();

    expect(
      categoryRepository.categories.any((item) => item.name == '购物'),
      true,
    );
    expect(find.text('购物'), findsOneWidget);

    await tester.tap(find.text(AppStrings.addTransaction));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    expect(find.text('购物'), findsOneWidget);
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
