import 'package:flutter_test/flutter_test.dart';
import 'package:money_flow/app.dart';
import 'package:money_flow/core/constants/app_strings.dart';

void main() {
  testWidgets('shows the V0.2 MoneyFlow app shell', (tester) async {
    await tester.pumpWidget(const MoneyFlowApp());

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.monthlyOverview), findsOneWidget);
    expect(find.text(AppStrings.currentBalance), findsOneWidget);
    expect(find.text(AppStrings.home), findsOneWidget);
    expect(find.text(AppStrings.records), findsOneWidget);
    expect(find.text(AppStrings.addTransaction), findsOneWidget);
    expect(find.text(AppStrings.statistics), findsOneWidget);
    expect(find.text(AppStrings.settings), findsOneWidget);
  });

  testWidgets('switches to records page from bottom navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const MoneyFlowApp());

    await tester.tap(find.text(AppStrings.records));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.allRecords), findsOneWidget);
    expect(find.text('工资'), findsWidgets);
  });
}
