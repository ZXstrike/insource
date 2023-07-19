// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:insource/ui/widgets/input_widget.dart';

import '../../utils/firebase_utils.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _loginFunction() {
    FireAuth().login(
      emailController.text,
      passwordController.text,
    );

    FireAuth().stateStatus(Navigator.popAndPushNamed(context, '/homeScreen'));
  }

  _navigatorFunction() {
    Navigator.popAndPushNamed(context, '/registerScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 42,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextInputSpace(
                inputController: emailController,
                verticalOutterPadding: 5,
                inputHint: 'Email',
                radius: 7,
                inputHintStyle:
                    const TextStyle(color: Colors.black, fontSize: 18),
              ),
              TextInputSpace(
                inputController: passwordController,
                verticalOutterPadding: 5,
                inputHint: 'Password',
                hideInput: true,
                radius: 7,
                inputHintStyle:
                    const TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(height: 35),
              ButtonSpace(
                onPressed: () => _loginFunction(),
                radius: 7,
                padding: 10,
                boxColor: Colors.blue,
                verticalOutterPadding: 15,
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              TextButtonSpace(
                mainAlignment: MainAxisAlignment.center,
                crossAlignment: CrossAxisAlignment.center,
                onPressed: () => _navigatorFunction(),
                text: 'Don\'t have an account? ',
                textColor: Colors.white,
                textButton: 'Register',
                fontSize: 16,
                textButtonColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
