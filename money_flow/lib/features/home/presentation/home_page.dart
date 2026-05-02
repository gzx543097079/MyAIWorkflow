import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: SafeArea(
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
                      AppStrings.zeroAmount,
                      style: textTheme.displaySmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Row(
                      children: [
                        Expanded(
                          child: _SummaryItem(
                            label: AppStrings.income,
                            value: AppStrings.zeroAmount,
                          ),
                        ),
                        SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: _SummaryItem(
                            label: AppStrings.expense,
                            value: AppStrings.zeroAmount,
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
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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
                    Icon(
                      Icons.receipt_long_outlined,
                      color: colorScheme.primary,
                      size: 40,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppStrings.emptyTransactionTitle,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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
                ),
              ),
            ),
          ],
        ),
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
