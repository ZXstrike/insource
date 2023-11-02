import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassInvisible = true;

  bool emailErrorState = false;
  bool passErrorState = false;

  final formKey = GlobalKey<FormState>();

  String? emailErrorMessage;
  String? passErrorMessage;

  late BuildContext context;

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  void passVisibilitiToggle() {
    isPassInvisible = isPassInvisible ? false : true;
    notifyListeners();
  }

  void userLogin() {
    if (formKey.currentState!.validate()) {
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

            emailController.clear();
            passwordController.clear();

            isPassInvisible = false;
          }
        },
      );
    }
  }

  void goToRegister() {
    Navigator.popAndPushNamed(context, '/registerScreen');
  }

  String? validateEmail(value) {
    return value!.isEmpty
        ? 'Enter Your Email'
        : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)
            ? 'Enter a Valid Email'
            : null;
  }

  String? validatePass(value) {
    return value!.isEmpty ? 'Enter Your Password' : null;
  }
}
