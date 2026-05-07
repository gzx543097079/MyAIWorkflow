import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_spacing.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    super.key,
  });

  final DateTime month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left),
          tooltip: AppStrings.previousMonth,
        ),
        Expanded(
          child: Text(
            '${month.year}年${month.month.toString().padLeft(2, '0')}月',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right),
          tooltip: AppStrings.nextMonth,
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
