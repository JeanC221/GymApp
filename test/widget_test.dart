import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartfit/app/smartfit_app.dart';

void main() {
  testWidgets('SmartFit shell renders', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SmartFitApp()));
    await tester.pumpAndSettle();

    expect(find.text('SmartFit'), findsWidgets);
    expect(find.text('Fase 0 iniciada'), findsOneWidget);
  });
}
