// ignore_for_file: unused_local_variable, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:firebase_core/firebase_core.dart';
import 'package:insource/utils/firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:insource/view/screen/authentication_screen/login_screen.dart';
import 'package:insource/view/screen/authentication_screen/register_screen.dart';
import 'package:insource/view/screen/main_screen/main_screen.dart';
import 'package:insource/view/screen/splash_screen/splash_screen.dart';
import 'package:insource/view/screen/upload_screen/upload_screen.dart';
import 'package:insource/viewmodel/account_view_provider.dart';
import 'package:insource/viewmodel/content_list_view_provider.dart';
import 'package:insource/viewmodel/liked_list_view_provider.dart';
import 'package:insource/viewmodel/login_view_provider.dart';
import 'package:insource/viewmodel/main_view_provider.dart';
import 'package:insource/viewmodel/personal_list_view_provider.dart';
import 'package:insource/viewmodel/register_view_provider.dart';
import 'package:insource/viewmodel/splash_screen_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SplashViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExploreListViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PersonalListViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AccountViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LikedListViewProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: "Insource prototype",
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const SplashScreen());
            case '/loginScreen':
              return MaterialPageRoute(
                  builder: (context) => const LoginScreen());
            case '/registerScreen':
              return MaterialPageRoute(
                  builder: (context) => const RegisterScreen());
            case '/homeScreen':
              return MaterialPageRoute(
                  builder: (context) => const MainScreen());
            case '/uploadScreen':
              return MaterialPageRoute(
                builder: (context) => const ContentUploadScreen(),
              );
          }
          return null;
        },
      ),
    );
  }
}
