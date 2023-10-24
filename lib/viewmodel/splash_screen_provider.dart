import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashViewProvider extends ChangeNotifier {
  late BuildContext context;

  void getCurrentState() {
    Timer(
      const Duration(seconds: 2),
      () async {
        if (FirebaseAuth.instance.currentUser != null) {
          debugPrint('User sign in!');
          Navigator.popAndPushNamed(context, '/homeScreen');
        } else {
          debugPrint('User sign out!');
          Navigator.popAndPushNamed(context, '/loginScreen');
        }
      },
    );
  }
}
