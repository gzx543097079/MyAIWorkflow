import 'package:money_flow/features/category/domain/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> loadCategories();

  Future<void> saveCategory(Category category);

  Future<void> deleteCategory(String id);
}
