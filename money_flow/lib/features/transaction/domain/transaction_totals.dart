import 'package:money_flow/features/transaction/domain/transaction.dart';

int incomeTotalCents(Iterable<Transaction> transactions) {
  return transactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amountCents);
}

int expenseTotalCents(Iterable<Transaction> transactions) {
  return transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amountCents);
}
