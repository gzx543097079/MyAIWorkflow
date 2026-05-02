import 'package:flutter_test/flutter_test.dart';
import 'package:money_flow/features/statistics/domain/monthly_statistics.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

void main() {
  test('calculates monthly totals from real transactions', () {
    final statistics = MonthlyStatistics(
      referenceDate: DateTime(2026, 5, 2),
      transactions: [
        Transaction(
          id: 'tx-food-1',
          title: '午餐',
          categoryId: 'food',
          amountCents: 3800,
          type: TransactionType.expense,
          date: DateTime(2026, 5, 2),
        ),
        Transaction(
          id: 'tx-food-2',
          title: '咖啡',
          categoryId: 'food',
          amountCents: 2200,
          type: TransactionType.expense,
          date: DateTime(2026, 5, 1),
        ),
        Transaction(
          id: 'tx-salary',
          title: '工资',
          categoryId: 'salary',
          amountCents: 1280000,
          type: TransactionType.income,
          date: DateTime(2026, 5, 1),
        ),
        Transaction(
          id: 'tx-rent',
          title: '房租',
          categoryId: 'housing',
          amountCents: 320000,
          type: TransactionType.expense,
          date: DateTime(2026, 4, 30),
        ),
      ],
    );

    expect(statistics.incomeCents, 1280000);
    expect(statistics.expenseCents, 6000);
    expect(statistics.balanceCents, 1274000);
    expect(statistics.monthTransactions, hasLength(3));
  });

  test('groups category expenses and daily trend for the selected month', () {
    final statistics = MonthlyStatistics(
      referenceDate: DateTime(2026, 5, 2),
      transactions: [
        Transaction(
          id: 'tx-food',
          title: '午餐',
          categoryId: 'food',
          amountCents: 3800,
          type: TransactionType.expense,
          date: DateTime(2026, 5, 2),
        ),
        Transaction(
          id: 'tx-subway',
          title: '地铁',
          categoryId: 'transport',
          amountCents: 600,
          type: TransactionType.expense,
          date: DateTime(2026, 5, 2),
        ),
        Transaction(
          id: 'tx-coffee',
          title: '咖啡',
          categoryId: 'food',
          amountCents: 2200,
          type: TransactionType.expense,
          date: DateTime(2026, 5, 1),
        ),
      ],
    );

    expect(statistics.categoryExpenseTotals.first.categoryId, 'food');
    expect(statistics.categoryExpenseTotals.first.amountCents, 6000);
    expect(statistics.categoryExpenseTotals.last.categoryId, 'transport');
    expect(statistics.categoryExpenseTotals.last.amountCents, 600);
    expect(statistics.dailyExpenseTotals, hasLength(2));
    expect(statistics.dailyExpenseTotals.first.monthDayLabel, '05-01');
    expect(statistics.dailyExpenseTotals.first.amountCents, 2200);
    expect(statistics.dailyExpenseTotals.last.monthDayLabel, '05-02');
    expect(statistics.dailyExpenseTotals.last.amountCents, 4400);
  });
}
