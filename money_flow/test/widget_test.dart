import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_flow/app.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/data/static_transactions.dart';
import 'package:money_flow/features/transaction/data/transaction_repository.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

void main() {
  late _MemoryTransactionRepository repository;

  setUp(() {
    repository = _MemoryTransactionRepository(staticTransactions);
  });

  test('static data uses domain models', () {
    expect(staticCategories.first, isA<Category>());
    expect(staticTransactions.first, isA<Transaction>());
    expect(staticTransactions.first.type, TransactionType.expense);
    expect(staticCategoryFor(staticTransactions.first).name, '餐饮');
  });

  testWidgets('shows the V0.5 MoneyFlow app shell', (tester) async {
    await tester.pumpWidget(MoneyFlowApp(transactionRepository: repository));
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
    await tester.pumpWidget(MoneyFlowApp(transactionRepository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.records));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.allRecords), findsOneWidget);
    expect(find.text('工资'), findsWidgets);
  });

  testWidgets('saves a valid transaction through repository', (tester) async {
    await tester.pumpWidget(MoneyFlowApp(transactionRepository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.addTransaction));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '12.34');
    await tester.enterText(find.byType(TextFormField).last, '测试晚餐');
    await tester.drag(find.byType(ListView).last, const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.saveRecord));
    await tester.pumpAndSettle();

    expect(repository.transactions.length, staticTransactions.length + 1);
    expect(repository.transactions.last.amountCents, 1234);
    expect(repository.transactions.last.note, '测试晚餐');
    expect(find.text(AppStrings.recordSaved), findsOneWidget);
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
