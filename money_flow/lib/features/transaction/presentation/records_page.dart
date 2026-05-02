import 'package:flutter/material.dart';
import 'package:money_flow/core/constants/app_strings.dart';
import 'package:money_flow/core/theme/app_radii.dart';
import 'package:money_flow/core/theme/app_spacing.dart';
import 'package:money_flow/features/transaction/data/static_transactions.dart';
import 'package:money_flow/features/transaction/presentation/widgets/transaction_tile.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

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
                  for (final transaction in staticTransactions)
                    TransactionTile(
                      transaction: transaction,
                      category: staticCategoryFor(transaction),
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
