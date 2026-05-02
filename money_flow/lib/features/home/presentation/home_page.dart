import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/core/utils/money_formatter.dart';
import 'package:money_flow/features/transaction/data/static_transactions.dart';
import 'package:money_flow/features/transaction/presentation/widgets/transaction_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final income = staticIncomeTotalCents();
    final expense = staticExpenseTotalCents();
    final balance = income - expense;

    return SafeArea(
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          Text(
            AppStrings.monthlyOverview,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: AppRadii.card,
            ),
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.currentBalance,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.82),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    MoneyFormatter.yuanFromCents(balance),
                    style: textTheme.displaySmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryItem(
                          label: AppStrings.income,
                          value: MoneyFormatter.yuanFromCents(income),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: _SummaryItem(
                          label: AppStrings.expense,
                          value: MoneyFormatter.yuanFromCents(expense),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            AppStrings.recentRecords,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
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
                  for (final transaction in staticTransactions.take(3))
                    TransactionTile(transaction: transaction),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: onPrimary.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
