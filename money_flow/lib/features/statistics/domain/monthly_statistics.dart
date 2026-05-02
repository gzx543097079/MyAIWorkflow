import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_totals.dart';

class MonthlyStatistics {
  MonthlyStatistics({
    required Iterable<Transaction> transactions,
    required DateTime referenceDate,
  }) : monthTransactions = transactions
           .where(
             (transaction) => _isSameMonth(transaction.date, referenceDate),
           )
           .toList(growable: false);

  final List<Transaction> monthTransactions;

  int get incomeCents => incomeTotalCents(monthTransactions);

  int get expenseCents => expenseTotalCents(monthTransactions);

  int get balanceCents => incomeCents - expenseCents;

  List<CategoryExpenseTotal> get categoryExpenseTotals {
    final totals = <String, int>{};
    for (final transaction in monthTransactions.where(
      (item) => !item.isIncome,
    )) {
      totals.update(
        transaction.categoryId,
        (value) => value + transaction.amountCents,
        ifAbsent: () => transaction.amountCents,
      );
    }

    final entries = totals.entries
        .map(
          (entry) => CategoryExpenseTotal(
            categoryId: entry.key,
            amountCents: entry.value,
          ),
        )
        .toList();
    entries.sort(
      (left, right) => right.amountCents.compareTo(left.amountCents),
    );
    return entries;
  }

  List<DailyExpenseTotal> get dailyExpenseTotals {
    final totals = <DateTime, int>{};
    for (final transaction in monthTransactions.where(
      (item) => !item.isIncome,
    )) {
      final day = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      totals.update(
        day,
        (value) => value + transaction.amountCents,
        ifAbsent: () => transaction.amountCents,
      );
    }

    final entries = totals.entries
        .map(
          (entry) =>
              DailyExpenseTotal(date: entry.key, amountCents: entry.value),
        )
        .toList();
    entries.sort((left, right) => left.date.compareTo(right.date));
    return entries;
  }
}

class CategoryExpenseTotal {
  const CategoryExpenseTotal({
    required this.categoryId,
    required this.amountCents,
  });

  final String categoryId;
  final int amountCents;
}

class DailyExpenseTotal {
  const DailyExpenseTotal({required this.date, required this.amountCents});

  final DateTime date;
  final int amountCents;

  String get monthDayLabel {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month-$day';
  }
}

bool _isSameMonth(DateTime date, DateTime referenceDate) {
  return date.year == referenceDate.year && date.month == referenceDate.month;
}
