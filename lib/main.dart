//import 'cust_fun.dart';

// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
        title: "Insource prototype",
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const SplashPage());
            case '/login':
              return MaterialPageRoute(builder: (context) => const LoginPage());
            case '/home':
              return MaterialPageRoute(builder: (context) => const HomePage());
            case '/PostDetail':
              return MaterialPageRoute(
                  builder: (context) =>
                      PostDetail(item: settings.arguments.toString()));
            case '/accountPage':
              return MaterialPageRoute(
                  builder: (context) => const AccountPage());
          }
          return null;
        }),
  );
}

class UIKits {
  Widget customBackButton(context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(150.0)),
        child: Container(
          color: const Color.fromARGB(153, 0, 0, 0),
          padding: const EdgeInsets.all(8),
          child: const Center(
              child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 25,
          )),
        ),
      ),
    );
  }

  Widget bottomNavBar(context, int selectedIndex) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_outlined),
          label: 'Upload',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: 'Account',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, "/home");
            break;
          case 2:
            Navigator.pushNamed(context, '/accountPage');
            break;
        }
      },
    );
  }
}

class FireabseDataManager {}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var indexCount = 16;

  Widget _masonryGridView() {
    return MasonryGridView.builder(
      padding: const EdgeInsets.only(top: 30, right: 4, left: 4, bottom: 6),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: indexCount,
      mainAxisSpacing: 12,
      crossAxisSpacing: 8,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/PostDetail',
              arguments: 'lib/assets/images/${index + 1}.jpg');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                  image: AssetImage('lib/assets/images/${index + 1}.jpg')),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              alignment: Alignment.centerLeft,
              child: Text(
                'lib/assets/images/${index + 1}.jpg',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: _masonryGridView(),
      bottomNavigationBar: UIKits().bottomNavBar(context, 0),
    );
  }
}

class PostDetail extends StatefulWidget {
  const PostDetail({super.key, required this.item});
  final String item;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  Widget _postContent() {
    return Container(
      color: const Color.fromARGB(255, 15, 15, 15),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              color: const Color.fromARGB(255, 36, 36, 36),
              child: Column(
                children: [
                  Image(image: AssetImage(widget.item)),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 5, right: 15, left: 15),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 15),
                          child: CircleAvatar(
                            radius: 25,
                            foregroundImage: AssetImage(widget.item),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.item,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    child: Text(
                      widget.item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 90,
                          child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 90,
                          child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Colors.white),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.redAccent),
                              ),
                              child: const Icon(Icons.favorite_outline)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      appBar: null,
      body: Container(
        padding: const EdgeInsets.only(top: 35),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: _postContent(),
            ),
            Positioned(
                top: 10, left: 10, child: UIKits().customBackButton(context)),
          ],
        ),
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Widget _topAccountDetail() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: null,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: null,
              radius: 65,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'username',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric())
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return TextButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SplashPage()),
          ) as Route<Object?>,
        );
      },
      child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Logout'),
            Icon(Icons.logout_outlined),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_topAccountDetail(), _logoutButton()],
      ),
      bottomNavigationBar: UIKits().bottomNavBar(context, 2),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _userInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'User Name',
              hintText: 'Enter valid mail id as abc@gmail.com',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Password',
              hintText: 'Enter your secure password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: TextButton(
            onPressed: () async {
              try {
                final credntial =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
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
              }

              FirebaseAuth.instance.authStateChanges().listen(
                (User? user) {
                  if (user == null) {
                    debugPrint('User currently signed out!');
                  } else {
                    debugPrint('User is signed in!');

                    Navigator.pushReplacement(
                      context,
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      ) as Route<Object?>,
                    );
                  }
                },
              );
            },
            child: const Text("Login"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Dont have an account?',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationPage(),
                        ),
                      ) as Route<Object?>);
                },
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean uo the controller when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: _userInput(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _userInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'Register',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'User Name',
              hintText: 'Enter valid mail id as abc@gmail.com',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Password',
              hintText: 'Enter your secure password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: TextButton(
            onPressed: () async {
              try {
                final credential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  debugPrint('The password provided is too weak.');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('The password provided is too weak.'),
                  ));
                } else if (e.code == 'email-already-in-use') {
                  debugPrint('The account already exists for that email.');
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

                    Navigator.pushReplacement(
                      context,
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      ) as Route<Object?>,
                    );
                  }
                },
              );
            },
            child: const Text("Signup"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Dont have an account?',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ) as Route<Object?>);
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: _userInput(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        Timer(
          const Duration(seconds: 3),
          () {
            if (user == null) {
              debugPrint('User is currently signed out!');
              Navigator.pushReplacement(
                  context,
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ) as Route<Object?>);
            } else {
              debugPrint('User is signed in!');
              Navigator.pushReplacement(
                  context,
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  ) as Route<Object?>);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}
