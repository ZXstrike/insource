import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/services/firebase_services.dart';

class RegisterViewProvider extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassInvisible = true;

  bool usernameErrorState = false;
  bool emailErrorState = false;
  bool passErrorState = false;

  String? usernameErrorMessage;
  String? emailErrorMessage;
  String? passErrorMessage;

  late BuildContext context;

  @override
  void dispose() {
    super.dispose();

    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void passVisibilitiToggle() {
    isPassInvisible = isPassInvisible ? false : true;
    notifyListeners();
  }

  void userRegister() {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
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
          User? currentUser = FirebaseAuth.instance.currentUser;
          final userData = <String, dynamic>{
            'userName': usernameController.text,
            'userEmail': emailController.text,
            'profileImageUrl':
                'https://firebasestorage.googleapis.com/v0/b/insource-c4f76.appspot.com/o/personIcon.png?alt=media&token=a1494928-5cba-4fa6-b2f3-97b8908a0002',
          };

          FirebaseServices.setUserData(currentUser!, userData);
          debugPrint('User is signed in!');

          Navigator.popAndPushNamed(context, '/homeScreen');
        }
      },
    );
  }

  void goToLogin() {
    Navigator.popAndPushNamed(context, '/loginScreen');
  }
}
