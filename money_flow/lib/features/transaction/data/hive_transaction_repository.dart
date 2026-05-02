import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_flow/features/transaction/data/static_transactions.dart';
import 'package:money_flow/features/transaction/data/transaction_repository.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

class HiveTransactionRepository implements TransactionRepository {
  const HiveTransactionRepository.forBoxes({
    required Box<String> transactionBox,
    required Box<bool> metadataBox,
  }) : _transactionBox = transactionBox,
       _metadataBox = metadataBox;

  static const _transactionBoxName = 'transactions';
  static const _metadataBoxName = 'transaction_metadata';
  static const _seededKey = 'seeded_v1';

  final Box<String> _transactionBox;
  final Box<bool> _metadataBox;

  static Future<HiveTransactionRepository> open() async {
    await Hive.initFlutter();
    final transactionBox = await Hive.openBox<String>(_transactionBoxName);
    final metadataBox = await Hive.openBox<bool>(_metadataBoxName);
    final repository = HiveTransactionRepository.forBoxes(
      transactionBox: transactionBox,
      metadataBox: metadataBox,
    );
    await repository._seedInitialTransactions();
    return repository;
  }

  @override
  Future<List<Transaction>> loadTransactions() async {
    final transactions =
        _transactionBox.values.map(_transactionFromJsonString).toList()
          ..sort((left, right) => right.date.compareTo(left.date));
    return transactions;
  }

  @override
  Future<void> saveTransaction(Transaction transaction) {
    return _transactionBox.put(
      transaction.id,
      jsonEncode(_transactionToJson(transaction)),
    );
  }

  @override
  Future<void> deleteTransaction(String id) {
    return _transactionBox.delete(id);
  }

  Future<void> _seedInitialTransactions() async {
    if (_metadataBox.get(_seededKey, defaultValue: false) ?? false) {
      return;
    }

    for (final transaction in staticTransactions) {
      await saveTransaction(transaction);
    }
    await _metadataBox.put(_seededKey, true);
  }
}

Map<String, Object?> _transactionToJson(Transaction transaction) {
  return {
    'id': transaction.id,
    'title': transaction.title,
    'categoryId': transaction.categoryId,
    'amountCents': transaction.amountCents,
    'type': transaction.type.name,
    'date': transaction.date.toIso8601String(),
    'note': transaction.note,
  };
}

Transaction _transactionFromJsonString(String value) {
  final json = jsonDecode(value) as Map<String, Object?>;
  return Transaction(
    id: json['id'] as String,
    title: json['title'] as String,
    categoryId: json['categoryId'] as String,
    amountCents: json['amountCents'] as int,
    type: TransactionType.values.byName(json['type'] as String),
    date: DateTime.parse(json['date'] as String),
    note: json['note'] as String?,
  );
}
