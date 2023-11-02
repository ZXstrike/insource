import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insource/view/screen/authentication_screen/login_screen.dart';
import 'package:insource/viewmodel/login_view_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  testWidgets('Testing Login Screen', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(ChangeNotifierProvider<LoginViewProvider>(
        create: (context) => LoginViewProvider(),
        builder: (context, child) => const MaterialApp(
          home: LoginScreen(),
        ),
      ));

      expect(find.text('Login'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });
  });
}
