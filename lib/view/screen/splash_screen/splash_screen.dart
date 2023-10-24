// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:insource/viewmodel/splash_screen_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashViewProvider splashProvider;

  @override
  void initState() {
    super.initState();
    splashProvider = Provider.of<SplashViewProvider>(context, listen: false);
    splashProvider.context = context;
    splashProvider.getCurrentState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/icons/is.png')),
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
