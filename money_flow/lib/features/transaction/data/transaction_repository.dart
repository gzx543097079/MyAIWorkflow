import 'package:money_flow/features/transaction/domain/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> loadTransactions();

  Future<void> saveTransaction(Transaction transaction);

  Future<void> deleteTransaction(String id);
}
