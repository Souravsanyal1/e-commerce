import 'package:flutter_test/flutter_test.dart';

import 'package:demo_ecommerce_app/main.dart' as app;

void main() {
  testWidgets('app starts on home route', (tester) async {
    app.main();
    await tester.pump();

    expect(find.text('HomeView'), findsWidgets);
  });
}
