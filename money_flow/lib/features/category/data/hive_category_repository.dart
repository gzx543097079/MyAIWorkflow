import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_flow/features/category/data/category_repository.dart';
import 'package:money_flow/features/category/data/default_categories.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

class HiveCategoryRepository implements CategoryRepository {
  const HiveCategoryRepository.forBoxes({
    required Box<String> categoryBox,
    required Box<bool> metadataBox,
  }) : _categoryBox = categoryBox,
       _metadataBox = metadataBox;

  static const _categoryBoxName = 'categories';
  static const _metadataBoxName = 'category_metadata';
  static const _seededKey = 'seeded_v1';

  final Box<String> _categoryBox;
  final Box<bool> _metadataBox;

  static Future<HiveCategoryRepository> open() async {
    await Hive.initFlutter();
    final categoryBox = await Hive.openBox<String>(_categoryBoxName);
    final metadataBox = await Hive.openBox<bool>(_metadataBoxName);
    final repository = HiveCategoryRepository.forBoxes(
      categoryBox: categoryBox,
      metadataBox: metadataBox,
    );
    await repository._seedInitialCategories();
    return repository;
  }

  @override
  Future<List<Category>> loadCategories() async {
    final categories = _categoryBox.values.map(_categoryFromJsonString).toList()
      ..sort(_compareCategories);
    return categories;
  }

  @override
  Future<void> saveCategory(Category category) {
    return _categoryBox.put(category.id, jsonEncode(_categoryToJson(category)));
  }

  @override
  Future<void> deleteCategory(String id) {
    return _categoryBox.delete(id);
  }

  Future<void> _seedInitialCategories() async {
    if (_metadataBox.get(_seededKey, defaultValue: false) ?? false) {
      return;
    }

    for (final category in defaultCategories) {
      await saveCategory(category);
    }
    await _metadataBox.put(_seededKey, true);
  }
}

Map<String, Object?> _categoryToJson(Category category) {
  return {'id': category.id, 'name': category.name, 'type': category.type.name};
}

Category _categoryFromJsonString(String value) {
  final json = jsonDecode(value) as Map<String, Object?>;
  return Category(
    id: json['id'] as String,
    name: json['name'] as String,
    type: TransactionType.values.byName(json['type'] as String),
  );
}

int _compareCategories(Category left, Category right) {
  final typeOrder = left.type.index.compareTo(right.type.index);
  if (typeOrder != 0) {
    return typeOrder;
  }
  return left.name.compareTo(right.name);
}
