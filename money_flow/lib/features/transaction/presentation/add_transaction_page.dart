import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/domain/transaction_type.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({
    required this.categories,
    required this.onSaveTransaction,
    super.key,
  });

  final List<Category> categories;
  final Future<void> Function(Transaction transaction) onSaveTransaction;

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  var _selectedType = TransactionType.expense;
  var _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  var _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<Category> get _availableCategories {
    return widget.categories
        .where((category) => category.type == _selectedType)
        .toList(growable: false);
  }

  String get _effectiveCategoryId {
    final categories = _availableCategories;
    final selectedCategoryId = _selectedCategoryId;
    if (selectedCategoryId != null &&
        categories.any((category) => category.id == selectedCategoryId)) {
      return selectedCategoryId;
    }
    return categories.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final availableCategories = _availableCategories;
    final hasCategories = availableCategories.isNotEmpty;

    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            Text(
              AppStrings.addTransactionTitle,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
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
                  _selectedCategoryId = null;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: AppRadii.card,
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: AppStrings.amount,
                        prefixIcon: Icon(Icons.payments_outlined),
                        prefixText: '¥ ',
                      ),
                      validator: _validateAmount,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<String>(
                      key: ValueKey(_selectedType),
                      initialValue: hasCategories ? _effectiveCategoryId : null,
                      decoration: const InputDecoration(
                        labelText: AppStrings.category,
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: [
                        for (final category in availableCategories)
                          DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                    ),
                    if (!hasCategories) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.categoryRequired,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    _DateField(
                      selectedDate: _selectedDate,
                      onPickDate: _pickDate,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _noteController,
                      maxLength: 40,
                      decoration: const InputDecoration(
                        labelText: AppStrings.note,
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: _isSaving || !hasCategories ? null : _saveTransaction,
              icon: _isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(
                _isSaving ? AppStrings.savingRecord : AppStrings.saveRecord,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateAmount(String? value) {
    final cents = _parseAmountCents(value ?? '');
    if (cents == null || cents <= 0) {
      return AppStrings.amountRequired;
    }
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate == null) {
      return;
    }
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _saveTransaction() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final amountCents = _parseAmountCents(_amountController.text);
    if (amountCents == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final category = _availableCategories.firstWhere(
      (category) => category.id == _effectiveCategoryId,
    );
    final note = _noteController.text.trim();
    final now = DateTime.now();
    final transaction = Transaction(
      id: 'tx-${now.microsecondsSinceEpoch}',
      title: note.isEmpty ? category.name : note,
      categoryId: category.id,
      amountCents: amountCents,
      type: _selectedType,
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
        now.microsecond,
      ),
      note: note.isEmpty ? null : note,
    );

    var saved = false;
    try {
      await widget.onSaveTransaction(transaction);
      if (!mounted) {
        return;
      }

      _amountController.clear();
      _noteController.clear();
      saved = true;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.recordSaved)));
    } catch (_) {
      if (!mounted) {
        return;
      }
    } finally {
      if (mounted) {
        setState(() {
          if (saved) {
            _selectedType = TransactionType.expense;
            _selectedCategoryId = null;
            _selectedDate = DateTime.now();
          }
          _isSaving = false;
        });
      }
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.selectedDate, required this.onPickDate});

  final DateTime selectedDate;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: AppRadii.card,
      onTap: onPickDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: AppStrings.date,
          prefixIcon: Icon(Icons.calendar_today_outlined),
          suffixIcon: Icon(Icons.edit_calendar_outlined),
        ),
        child: Text(_formatDate(selectedDate), style: textTheme.bodyLarge),
      ),
    );
  }
}

int? _parseAmountCents(String value) {
  final trimmedValue = value.trim();
  if (trimmedValue.isEmpty) {
    return null;
  }

  final parts = trimmedValue.split('.');
  if (parts.length > 2 || parts.first.isEmpty) {
    return null;
  }

  final yuan = int.tryParse(parts.first);
  if (yuan == null) {
    return null;
  }

  var cents = 0;
  if (parts.length == 2 && parts.last.isNotEmpty) {
    final centText = parts.last.padRight(2, '0');
    cents = int.tryParse(centText) ?? -1;
  }
  if (cents < 0) {
    return null;
  }

  return yuan * 100 + cents;
}

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
