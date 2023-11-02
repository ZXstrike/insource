import 'package:flutter/material.dart';
import 'package:insource/view/widgets/input_widget.dart';
import 'package:insource/viewmodel/register_view_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterViewProvider regisProvider;

  @override
  void initState() {
    super.initState();

    regisProvider = Provider.of<RegisterViewProvider>(context, listen: false);

    regisProvider.context = context;
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
          child: Form(
            key: regisProvider.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Register',
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
                  validator: (value) => regisProvider.validatingName(value),
                  keyboardType: TextInputType.name,
                  controller: regisProvider.usernameController,
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
                      Icons.person_2_outlined,
                      color: Colors.white,
                    ),
                    label: const Text('Username'),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) => regisProvider.validateEmail(value),
                  keyboardType: TextInputType.emailAddress,
                  controller: regisProvider.emailController,
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
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Consumer<RegisterViewProvider>(
                  builder: (context, value, child) => TextFormField(
                    validator: (value) => regisProvider.validatePass(value),
                    keyboardType: TextInputType.visiblePassword,
                    controller: regisProvider.passwordController,
                    obscureText: regisProvider.isPassInvisible,
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
                        onTap: regisProvider.passVisibilitiToggle,
                        child: Icon(
                          value.isPassInvisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      label: const Text('Password'),
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
                  onPressed: regisProvider.userRegister,
                  radius: 15,
                  boxColor: Colors.blue,
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButtonSpace(
                  mainAlignment: MainAxisAlignment.center,
                  crossAlignment: CrossAxisAlignment.center,
                  onPressed: regisProvider.goToLogin,
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
      ),
    );
  }
}
