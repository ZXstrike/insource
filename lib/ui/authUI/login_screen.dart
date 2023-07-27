import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insource/ui/widgets/input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _loginFunction() {
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email address.');
        debugPrint(e.code);
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password for that email user.');
        debugPrint(e.code);
      } else {
        debugPrint(e.code);
      }
      Fluttertoast.showToast(
        msg: e.code,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          debugPrint('User currently signed out!');
        } else {
          debugPrint('User is signed in!');

          Navigator.popAndPushNamed(context, '/homeScreen');
        }
      },
    );
  }

  void _navigatorFunction() {
    Navigator.popAndPushNamed(context, '/registerScreen');
  }

  @override
  void dispose() {
    super.dispose();
    emailController;
    passwordController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
