import 'package:money_flow/features/transaction/domain/transaction_type.dart';

class Category {
  const Category({required this.id, required this.name, required this.type});

  final String id;
  final String name;
  final TransactionType type;
}
