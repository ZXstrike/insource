import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insource/view/screen/splash_screen/splash_screen.dart';
import 'package:insource/viewmodel/splash_screen_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  testWidgets('Testing Splash Screen', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(ChangeNotifierProvider<SplashViewProvider>(
        create: (context) => SplashViewProvider(),
        builder: (context, child) => const MaterialApp(
          home: SplashScreen(),
        ),
      ));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Insource'), findsOneWidget);
    });
  });
}
