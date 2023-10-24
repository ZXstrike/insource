import 'package:flutter/material.dart';
import 'package:insource/viewmodel/main_view_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainViewProvider mainProvider;

  int screenIndex = 0;

  @override
  void initState() {
    super.initState();
    mainProvider = Provider.of<MainViewProvider>(context, listen: false);
    mainProvider.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        body: Consumer<MainViewProvider>(
          builder: (context, value, child) => value.currentPage,
        ),
        bottomNavigationBar: Consumer<MainViewProvider>(
          builder: (context, value, child) => BottomNavigationBar(
            currentIndex: mainProvider.currentIndex,
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
            onTap: (index) => mainProvider.bottomNavFunction(index),
          ),
        ));
  }
}
