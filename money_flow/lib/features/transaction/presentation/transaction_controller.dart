import 'package:flutter/foundation.dart';
import 'package:money_flow/features/transaction/data/transaction_repository.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';

class TransactionController extends ChangeNotifier {
  TransactionController({required TransactionRepository repository})
    : _repository = repository;

  final TransactionRepository _repository;

  var _transactions = <Transaction>[];
  var _isLoading = true;

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _transactions = await _repository.loadTransactions();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> add(Transaction transaction) async {
    await _repository.saveTransaction(transaction);
    await load();
  }

  Future<void> delete(String id) async {
    await _repository.deleteTransaction(id);
    await load();
  }
}
