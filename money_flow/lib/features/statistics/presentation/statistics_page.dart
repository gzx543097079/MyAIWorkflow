import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/core/utils/money_formatter.dart';
import 'package:money_flow/features/transaction/data/static_transactions.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final income = staticIncomeTotalCents();
    final expense = staticExpenseTotalCents();
    final balance = income - expense;
    final categoryTotals = _categoryExpenseTotals();

    return SafeArea(
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          const _SectionTitle(title: AppStrings.thisMonth),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: AppStrings.income,
                  value: MoneyFormatter.yuanFromCents(income),
                  icon: Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MetricCard(
                  label: AppStrings.expense,
                  value: MoneyFormatter.yuanFromCents(expense),
                  icon: Icons.arrow_upward,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _MetricCard(
            label: AppStrings.balance,
            value: MoneyFormatter.yuanFromCents(balance),
            icon: Icons.account_balance_wallet_outlined,
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionTitle(title: AppStrings.categoryOverview),
          const SizedBox(height: AppSpacing.md),
          _StatisticsCard(
            child: Column(
              children: [
                for (final item in categoryTotals.entries)
                  _CategoryBar(
                    label: item.key,
                    value: item.value,
                    maxValue: expense,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionTitle(title: AppStrings.spendingTrend),
          const SizedBox(height: AppSpacing.md),
          const _StatisticsCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _TrendBar(label: '04-30', height: 96),
                _TrendBar(label: '05-01', height: 34),
                _TrendBar(label: '05-02', height: 54),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _categoryExpenseTotals() {
    final totals = <String, int>{};
    for (final transaction in staticTransactions.where(
      (item) => !item.isIncome,
    )) {
      totals.update(
        transaction.category,
        (value) => value + transaction.amountCents,
        ifAbsent: () => transaction.amountCents,
      );
    }
    return totals;
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return _StatisticsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadii.card,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(padding: AppSpacing.cardPadding, child: child),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.label,
    required this.value,
    required this.maxValue,
  });

  final String label;
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ratio = maxValue == 0 ? 0.0 : value / maxValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                MoneyFormatter.yuanFromCents(value),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.card,
            child: LinearProgressIndicator(
              minHeight: 8,
              value: ratio,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendBar extends StatelessWidget {
  const _TrendBar({required this.label, required this.height});

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            width: 28,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: AppRadii.card,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
