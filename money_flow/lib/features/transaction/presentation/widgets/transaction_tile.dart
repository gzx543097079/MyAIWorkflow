import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/core/utils/money_formatter.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    required this.category,
    this.onDelete,
    super.key,
  });

  final Transaction transaction;
  final Category category;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final amountColor = transaction.isIncome
        ? colorScheme.primary
        : colorScheme.onSurface;
    final amountPrefix = transaction.isIncome ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            child: Icon(_categoryIcon(category.id), size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${category.name} · ${transaction.monthDayLabel}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '$amountPrefix${MoneyFormatter.yuanFromCents(transaction.amountCents)}',
            style: textTheme.titleSmall?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: AppStrings.delete,
            ),
          ],
        ],
      ),
    );
  }

  IconData _categoryIcon(String categoryId) {
    return switch (categoryId) {
      'food' => Icons.restaurant_outlined,
      'transport' => Icons.directions_subway_outlined,
      'housing' => Icons.home_outlined,
      'salary' => Icons.payments_outlined,
      _ => Icons.receipt_long_outlined,
    };
  }
}
