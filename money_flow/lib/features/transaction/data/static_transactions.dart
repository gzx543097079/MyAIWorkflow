import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

const staticCategories = [
  Category(id: 'food', name: '餐饮', type: TransactionType.expense),
  Category(id: 'transport', name: '交通', type: TransactionType.expense),
  Category(id: 'housing', name: '居住', type: TransactionType.expense),
  Category(id: 'salary', name: '收入', type: TransactionType.income),
];

final staticTransactions = [
  Transaction(
    id: 'tx-lunch',
    title: '午餐',
    categoryId: 'food',
    amountCents: 3800,
    type: TransactionType.expense,
    date: DateTime(2026, 5, 2),
    note: '工作日午餐',
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
    id: 'tx-salary',
    title: '工资',
    categoryId: 'salary',
    amountCents: 1280000,
    type: TransactionType.income,
    date: DateTime(2026, 5, 1),
  ),
  Transaction(
    id: 'tx-coffee',
    title: '咖啡',
    categoryId: 'food',
    amountCents: 2200,
    type: TransactionType.expense,
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
];

Category staticCategoryById(String id) {
  return staticCategories.firstWhere((category) => category.id == id);
}

Category staticCategoryFor(Transaction transaction) {
  return staticCategoryById(transaction.categoryId);
}

int staticIncomeTotalCents() {
  return staticTransactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amountCents);
}

int staticExpenseTotalCents() {
  return staticTransactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amountCents);
}
