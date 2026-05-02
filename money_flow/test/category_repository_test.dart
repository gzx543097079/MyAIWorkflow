import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_flow/features/category/data/default_categories.dart';
import 'package:money_flow/features/category/data/hive_category_repository.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

void main() {
  late Directory tempDirectory;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync(
      'money_flow_category_hive_test_',
    );
    Hive.init(tempDirectory.path);
  });

  tearDown(() async {
    await Hive.close();
    tempDirectory.deleteSync(recursive: true);
  });

  test('loads default category records from Hive storage', () async {
    final categoryBox = await Hive.openBox<String>('categories_test');
    final metadataBox = await Hive.openBox<bool>('category_metadata_test');
    final repository = HiveCategoryRepository.forBoxes(
      categoryBox: categoryBox,
      metadataBox: metadataBox,
    );

    for (final category in defaultCategories) {
      await repository.saveCategory(category);
    }

    final categories = await repository.loadCategories();

    expect(categories, hasLength(defaultCategories.length));
    expect(categories.any((category) => category.name == '餐饮'), true);
  });

  test('saves, updates, and deletes custom categories', () async {
    final categoryBox = await Hive.openBox<String>('categories_test');
    final metadataBox = await Hive.openBox<bool>('category_metadata_test');
    final repository = HiveCategoryRepository.forBoxes(
      categoryBox: categoryBox,
      metadataBox: metadataBox,
    );

    await repository.saveCategory(
      const Category(id: 'shopping', name: '购物', type: TransactionType.expense),
    );
    await repository.saveCategory(
      const Category(
        id: 'shopping',
        name: '日用品',
        type: TransactionType.expense,
      ),
    );

    var categories = await repository.loadCategories();
    expect(categories.single.name, '日用品');

    await repository.deleteCategory('shopping');
    categories = await repository.loadCategories();

    expect(categories, isEmpty);
  });
}
