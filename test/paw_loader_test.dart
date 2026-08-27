import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

import 'package:pawhealth/widgets/common/paw_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('paw_loader.json is a valid Lottie composition', () async {
    final data = await rootBundle.load('assets/animations/paw_loader.json');
    final composition = await LottieComposition.fromByteData(data);

    expect(composition.duration.inMilliseconds, greaterThan(0));
    expect(composition.bounds.width, 160);
    expect(composition.bounds.height, 80);
  });

  testWidgets('PawLoader renders with an optional message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PawLoader(message: 'Loading…')),
      ),
    );
    await tester.pump();

    expect(find.byType(Lottie), findsOneWidget);
    expect(find.text('Loading…'), findsOneWidget);
  });
}
