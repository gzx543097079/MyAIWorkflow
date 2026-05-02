import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

const uncategorizedCategory = Category(
  id: 'uncategorized',
  name: '未分类',
  type: TransactionType.expense,
);

Category categoryById(Iterable<Category> categories, String id) {
  for (final category in categories) {
    if (category.id == id) {
      return category;
    }
  }
  return uncategorizedCategory;
}
