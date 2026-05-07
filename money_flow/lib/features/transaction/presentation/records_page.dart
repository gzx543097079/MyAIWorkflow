import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/core/widgets/month_selector.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/category/domain/category_lookup.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';
import 'package:money_flow/features/transaction/presentation/widgets/transaction_tile.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({
    required this.transactions,
    required this.categories,
    required this.isLoading,
    required this.selectedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDeleteTransaction,
    super.key,
  });

  final List<Transaction> transactions;
  final List<Category> categories;
  final bool isLoading;
  final DateTime selectedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final Future<void> Function(String id) onDeleteTransaction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          Text(
            AppStrings.allRecords,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MonthSelector(
            month: selectedMonth,
            onPreviousMonth: onPreviousMonth,
            onNextMonth: onNextMonth,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: AppRadii.card,
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: transactions.isEmpty
                    ? const _EmptyRecords()
                    : Column(
                        children: [
                          for (final transaction in transactions)
                            TransactionTile(
                              transaction: transaction,
                              category: categoryById(
                                categories,
                                transaction.categoryId,
                              ),
                              onDelete: () {
                                _confirmDelete(context, transaction.id);
                              },
                            ),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.deleteRecord),
          content: const Text(AppStrings.confirmDeleteRecord),
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
      try {
        await onDeleteTransaction(id);
      } catch (_) {
        return;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.recordDeleted)));
      }
    }
  }
}

class _EmptyRecords extends StatelessWidget {
  const _EmptyRecords();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(Icons.receipt_long_outlined, color: colorScheme.primary, size: 40),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.emptyTransactionTitle,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.emptyTransactionMessage,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
