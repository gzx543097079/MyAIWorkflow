import 'package:money_flow/features/transaction/domain/transaction_type.dart';

class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.amountCents,
    required this.type,
    required this.date,
    this.note,
  });

  final String id;
  final String title;
  final String categoryId;
  final int amountCents;
  final TransactionType type;
  final DateTime date;
  final String? note;

  bool get isIncome => type == TransactionType.income;

  String get monthDayLabel {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month-$day';
  }
}
