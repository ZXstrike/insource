import 'package:flutter/material.dart';
import 'package:insource/view/widgets/input_widget.dart';
import 'package:insource/viewmodel/login_view_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginViewProvider loginProvider;

  @override
  void initState() {
    super.initState();

    loginProvider = Provider.of<LoginViewProvider>(context, listen: false);

    loginProvider.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: Padding(
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
              height: 35,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: loginProvider.emailController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                icon: const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                label: const Text('Email'),
                hintText: "",
                filled: true,
                fillColor: Colors.white,
                hintStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Consumer<LoginViewProvider>(
              builder: (context, value, child) => TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: loginProvider.passwordController,
                obscureText: loginProvider.isPassInvisible,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  icon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: loginProvider.passVisibilitiToggle,
                    child: Icon(
                      value.isPassInvisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  label: const Text('Password'),
                  hintText: "",
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ButtonSpace(
              onPressed: loginProvider.userLogin,
              radius: 15,
              padding: 10,
              boxColor: Colors.blue,
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButtonSpace(
              mainAlignment: MainAxisAlignment.center,
              crossAlignment: CrossAxisAlignment.center,
              onPressed: loginProvider.goToRegister,
              text: 'Don\'t have an account? ',
              textColor: Colors.white,
              textButton: 'Register',
              fontSize: 16,
              textButtonColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
