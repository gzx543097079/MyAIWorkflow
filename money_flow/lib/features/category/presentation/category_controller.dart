import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:money_flow/features/category/data/category_repository.dart';
import 'package:money_flow/features/category/domain/category.dart';

class CategoryController extends ChangeNotifier {
  CategoryController({required CategoryRepository repository})
    : _repository = repository;

  final CategoryRepository _repository;

  var _categories = <Category>[];
  var _isLoading = true;

  List<Category> get categories => List.unmodifiable(_categories);

  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _repository.loadCategories();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save(Category category) async {
    await _repository.saveCategory(category);
    await load();
  }

  Future<void> delete(String id) async {
    await _repository.deleteCategory(id);
    await load();
  }
}
