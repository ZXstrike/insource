import 'package:flutter/material.dart';
import 'package:insource/ui/widgets/input_widget.dart';
import 'package:insource/utils/firebase_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _navigatorFunction() {
    Navigator.popAndPushNamed(context, '/loginScreen');
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
                'Resgister',
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
                inputController: usernameController,
                verticalOutterPadding: 5,
                inputHint: 'User Name',
                radius: 7,
                inputHintStyle:
                    const TextStyle(color: Colors.black, fontSize: 18),
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
                onPressed: () => FireAuth().register(
                  usernameController.text,
                  emailController.text,
                  passwordController.text,
                ),
                radius: 7,
                padding: 10,
                boxColor: Colors.blue,
                verticalOutterPadding: 15,
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              TextButtonSpace(
                mainAlignment: MainAxisAlignment.center,
                crossAlignment: CrossAxisAlignment.center,
                onPressed: () => _navigatorFunction(),
                text: 'Already have an account? ',
                textColor: Colors.white,
                textButton: 'Login',
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
