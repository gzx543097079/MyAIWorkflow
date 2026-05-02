import 'package:flutter_test/flutter_test.dart';
import 'package:money_flow/app.dart';
import 'package:money_flow/core/constants/app_strings.dart';

void main() {
  testWidgets('shows the V0.1 MoneyFlow home shell', (tester) async {
    await tester.pumpWidget(const MoneyFlowApp());

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.monthlyOverview), findsOneWidget);
    expect(find.text(AppStrings.currentBalance), findsOneWidget);
    expect(find.text(AppStrings.emptyTransactionTitle), findsOneWidget);
  });
}
