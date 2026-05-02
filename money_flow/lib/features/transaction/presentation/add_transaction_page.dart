import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
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
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: AppStrings.expense,
                label: Text(AppStrings.expense),
                icon: Icon(Icons.arrow_upward),
              ),
              ButtonSegment(
                value: AppStrings.income,
                label: Text(AppStrings.income),
                icon: Icon(Icons.arrow_downward),
              ),
            ],
            selected: const {AppStrings.expense},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: AppSpacing.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppRadii.card,
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: const Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                children: [
                  _StaticField(
                    icon: Icons.payments_outlined,
                    label: AppStrings.amount,
                    value: AppStrings.previewAmount,
                  ),
                  _StaticField(
                    icon: Icons.restaurant_outlined,
                    label: AppStrings.category,
                    value: AppStrings.previewCategory,
                  ),
                  _StaticField(
                    icon: Icons.calendar_today_outlined,
                    label: AppStrings.date,
                    value: AppStrings.previewDate,
                  ),
                  _StaticField(
                    icon: Icons.notes_outlined,
                    label: AppStrings.note,
                    value: AppStrings.previewNote,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check),
            label: const Text(AppStrings.saveRecord),
          ),
          const SizedBox(height: AppSpacing.md),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: AppRadii.card,
            ),
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.staticPreview,
                          style: textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          AppStrings.staticPreviewMessage,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaticField extends StatelessWidget {
  const _StaticField({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
