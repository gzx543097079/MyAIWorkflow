import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/core/utils/money_formatter.dart';
import 'package:money_flow/features/category/domain/category.dart';
import 'package:money_flow/features/category/domain/category_lookup.dart';
import 'package:money_flow/features/statistics/domain/monthly_statistics.dart';
import 'package:money_flow/features/transaction/domain/transaction.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({
    required this.transactions,
    required this.categories,
    super.key,
  });

  final List<Transaction> transactions;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final statistics = MonthlyStatistics(
      transactions: transactions,
      referenceDate: DateTime.now(),
    );
    final categoryTotals = statistics.categoryExpenseTotals;
    final dailyTotals = statistics.dailyExpenseTotals;

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
                  value: MoneyFormatter.yuanFromCents(statistics.incomeCents),
                  icon: Icons.arrow_downward,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MetricCard(
                  label: AppStrings.expense,
                  value: MoneyFormatter.yuanFromCents(statistics.expenseCents),
                  icon: Icons.arrow_upward,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _MetricCard(
            label: AppStrings.balance,
            value: MoneyFormatter.yuanFromCents(statistics.balanceCents),
            icon: Icons.account_balance_wallet_outlined,
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionTitle(title: AppStrings.categoryOverview),
          const SizedBox(height: AppSpacing.md),
          _StatisticsCard(
            child: categoryTotals.isEmpty
                ? const _EmptyStatistics(message: AppStrings.emptyCategoryStats)
                : Column(
                    children: [
                      for (final item in categoryTotals)
                        _CategoryBar(
                          label: categoryById(categories, item.categoryId).name,
                          value: item.amountCents,
                          maxValue: statistics.expenseCents,
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionTitle(title: AppStrings.spendingTrend),
          const SizedBox(height: AppSpacing.md),
          _StatisticsCard(
            child: dailyTotals.isEmpty
                ? const _EmptyStatistics(message: AppStrings.emptyTrendStats)
                : _TrendChart(dailyTotals: dailyTotals),
          ),
        ],
      ),
    );
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

class _EmptyStatistics extends StatelessWidget {
  const _EmptyStatistics({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.insights_outlined, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
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

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.dailyTotals});

  final List<DailyExpenseTotal> dailyTotals;

  @override
  Widget build(BuildContext context) {
    final maxValue = dailyTotals.fold<int>(
      0,
      (value, item) => item.amountCents > value ? item.amountCents : value,
    );

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final item in dailyTotals)
            _TrendBar(
              label: item.monthDayLabel,
              value: item.amountCents,
              maxValue: maxValue,
            ),
        ],
      ),
    );
  }
}

class _TrendBar extends StatelessWidget {
  const _TrendBar({
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
    final height = 24 + ratio * 76;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            MoneyFormatter.yuanFromCents(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
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
