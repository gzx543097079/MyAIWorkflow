import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

const defaultCategories = [
  Category(id: 'food', name: '餐饮', type: TransactionType.expense),
  Category(id: 'transport', name: '交通', type: TransactionType.expense),
  Category(id: 'housing', name: '居住', type: TransactionType.expense),
  Category(id: 'salary', name: '收入', type: TransactionType.income),
];
