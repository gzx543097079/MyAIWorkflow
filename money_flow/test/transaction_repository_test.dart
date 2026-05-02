import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_flow/features/transaction/data/hive_transaction_repository.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

void main() {
  late Directory tempDirectory;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync(
      'money_flow_hive_test_',
    );
    Hive.init(tempDirectory.path);
  });

  tearDown(() async {
    await Hive.close();
    tempDirectory.deleteSync(recursive: true);
  });

  test('persists transactions after Hive boxes reopen', () async {
    var transactionBox = await Hive.openBox<String>('transactions_test');
    var metadataBox = await Hive.openBox<bool>('metadata_test');
    var repository = HiveTransactionRepository.forBoxes(
      transactionBox: transactionBox,
      metadataBox: metadataBox,
    );

    await repository.saveTransaction(
      Transaction(
        id: 'tx-test',
        title: '测试记录',
        categoryId: 'food',
        amountCents: 3800,
        type: TransactionType.expense,
        date: DateTime(2026, 5, 2),
      ),
    );

    await transactionBox.close();
    await metadataBox.close();

    transactionBox = await Hive.openBox<String>('transactions_test');
    metadataBox = await Hive.openBox<bool>('metadata_test');
    repository = HiveTransactionRepository.forBoxes(
      transactionBox: transactionBox,
      metadataBox: metadataBox,
    );

    final transactions = await repository.loadTransactions();

    expect(transactions, hasLength(1));
    expect(transactions.single.id, 'tx-test');
    expect(transactions.single.amountCents, 3800);
  });
}
