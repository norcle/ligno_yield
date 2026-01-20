import 'package:flutter_test/flutter_test.dart';

import 'package:ligno_yiled/main.dart';

void main() {
  testWidgets('App starts on the input screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LignoUrozhaiApp());

    expect(find.text('Input Data'), findsOneWidget);
    expect(find.text('Calculate'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(4));
  });
}
