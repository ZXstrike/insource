import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insource/ui/widgets/input_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _registerFunction() {
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
      }
      Fluttertoast.showToast(
        msg: e.code,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: Colors.blue,
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
          User? currentUser = FirebaseAuth.instance.currentUser;
          final userData = <String, dynamic>{
            'userName': usernameController.text,
            'userEmail': emailController.text,
            'profileImageUrl':
                'https://firebasestorage.googleapis.com/v0/b/insource-c4f76.appspot.com/o/personIcon.png?alt=media&token=a1494928-5cba-4fa6-b2f3-97b8908a0002',
          };
          FirebaseFirestore.instance
              .collection('usersData')
              .doc(currentUser?.uid)
              .set(userData);
          debugPrint('User is signed in!');

          Navigator.popAndPushNamed(context, '/homeScreen');
        }
      },
    );
  }

  _navigatorFunction() {
    Navigator.popAndPushNamed(context, '/loginScreen');
  }

  @override
  void dispose() {
    super.dispose();
    usernameController;
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
                onPressed: () => _registerFunction(),
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
