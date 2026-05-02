import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.categories,
    required this.isLoadingCategories,
    required this.onSaveCategory,
    required this.onDeleteCategory,
    super.key,
  });

  final List<Category> categories;
  final bool isLoadingCategories;
  final Future<void> Function(Category category) onSaveCategory;
  final Future<void> Function(String id) onDeleteCategory;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          Text(
            AppStrings.settings,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SettingsGroup(
            children: [
              _SettingsTile(
                icon: Icons.account_circle_outlined,
                title: AppStrings.accountSettings,
                subtitle: AppStrings.localLedger,
              ),
              _SettingsTile(
                icon: Icons.storage_outlined,
                title: AppStrings.dataSettings,
                subtitle: AppStrings.localStorageEnabled,
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: AppStrings.appVersion,
                subtitle: AppStrings.versionName,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          _CategorySettings(
            categories: categories,
            isLoading: isLoadingCategories,
            onSaveCategory: onSaveCategory,
            onDeleteCategory: onDeleteCategory,
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadii.card,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(
        title,
        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(subtitle),
    );
  }
}

class _CategorySettings extends StatelessWidget {
  const _CategorySettings({
    required this.categories,
    required this.isLoading,
    required this.onSaveCategory,
    required this.onDeleteCategory,
  });

  final List<Category> categories;
  final bool isLoading;
  final Future<void> Function(Category category) onSaveCategory;
  final Future<void> Function(String id) onDeleteCategory;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.categorySettings,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton.filled(
              onPressed: () {
                _showCategoryDialog(context);
              },
              icon: const Icon(Icons.add),
              tooltip: AppStrings.addCategory,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadii.card,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: isLoading
                ? const Padding(
                    padding: AppSpacing.cardPadding,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : categories.isEmpty
                ? const Padding(
                    padding: AppSpacing.cardPadding,
                    child: _CategoryEmptyState(),
                  )
                : Column(
                    children: [
                      for (final type in TransactionType.values)
                        _CategoryTypeSection(
                          type: type,
                          categories: categories
                              .where((category) => category.type == type)
                              .toList(growable: false),
                          onEdit: (category) {
                            _showCategoryDialog(context, category: category);
                          },
                          onDelete: (category) {
                            _confirmDelete(context, category);
                          },
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCategoryDialog(
    BuildContext context, {
    Category? category,
  }) async {
    final result = await showDialog<Category>(
      context: context,
      builder: (context) => _CategoryDialog(category: category),
    );

    if (result == null) {
      return;
    }
    await onSaveCategory(result);
  }

  Future<void> _confirmDelete(BuildContext context, Category category) async {
    final sameTypeCount = categories
        .where((item) => item.type == category.type)
        .length;
    if (sameTypeCount <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.keepOneCategoryPerType)),
      );
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.deleteCategory),
          content: Text('${AppStrings.confirmDeleteCategory} ${category.name}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete ?? false) {
      await onDeleteCategory(category.id);
    }
  }
}

class _CategoryTypeSection extends StatelessWidget {
  const _CategoryTypeSection({
    required this.type,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  final TransactionType type;
  final List<Category> categories;
  final void Function(Category category) onEdit;
  final void Function(Category category) onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              type == TransactionType.expense
                  ? AppStrings.expenseCategories
                  : AppStrings.incomeCategories,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final category in categories)
            ListTile(
              leading: Icon(
                type == TransactionType.expense
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
              ),
              title: Text(category.name),
              trailing: Wrap(
                spacing: AppSpacing.xs,
                children: [
                  IconButton(
                    onPressed: () {
                      onEdit(category);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: AppStrings.editCategory,
                  ),
                  IconButton(
                    onPressed: () {
                      onDelete(category);
                    },
                    icon: const Icon(Icons.delete_outline),
                    tooltip: AppStrings.deleteCategory,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryEmptyState extends StatelessWidget {
  const _CategoryEmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.category_outlined, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            AppStrings.emptyCategoryMessage,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog({this.category});

  final Category? category;

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late TransactionType _selectedType;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _nameController = TextEditingController(text: category?.name);
    _selectedType = category?.type ?? TransactionType.expense;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.category == null
            ? AppStrings.addCategory
            : AppStrings.editCategory,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text(AppStrings.expense),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text(AppStrings.income),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedType = selection.single;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: AppStrings.categoryName,
                prefixIcon: Icon(Icons.category_outlined),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.categoryNameRequired;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(onPressed: _submit, child: const Text(AppStrings.save)),
      ],
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final now = DateTime.now();
    final category = Category(
      id: widget.category?.id ?? 'cat-${now.microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      type: _selectedType,
    );
    Navigator.of(context).pop(category);
  }
}
