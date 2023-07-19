// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/firebase_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      if (await FireAuth().getSessionStatus()) {
        debugPrint('User sign in!');
        Navigator.popAndPushNamed(context, '/homeScreen');
      } else {
        debugPrint('User sign out!');
        Navigator.popAndPushNamed(context, '/loginScreen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('lib/assets/icons/is.png')),
            Text(
              'Insource',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
