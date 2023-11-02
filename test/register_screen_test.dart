import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insource/view/screen/authentication_screen/register_screen.dart';
import 'package:insource/viewmodel/register_view_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  testWidgets('Testing Register', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(ChangeNotifierProvider<RegisterViewProvider>(
        create: (context) => RegisterViewProvider(),
        builder: (context, child) => const MaterialApp(
          home: RegisterScreen(),
        ),
      ));

      expect(find.text('Login'), findsWidgets);
      expect(find.text('Username'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });
  });
}
