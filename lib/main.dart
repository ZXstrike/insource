//import 'cust_fun.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
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
              return MaterialPageRoute(builder: (context) => const HomePage());
            case '/PostDetail':
              return MaterialPageRoute(
                  builder: (context) =>
                      PostDetail(item: settings.arguments.toString()));
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

  Widget bottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined), label: 'Upload'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined), label: 'Account'),
      ],
    );
  }
}

class FireabseDataLoader {}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var indexCount = 16;
  late ScrollController _controller;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(
        () {},
      );
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  Widget _masonryGridView() {
    return MasonryGridView.builder(
      controller: _controller,
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
      bottomNavigationBar: UIKits().bottomNavBar(),
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
  Widget _acacount_detail() {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            padding: null,
            child: const CircleAvatar(image)
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: null,
      bottomNavigationBar: UIKits().bottomNavBar(),
    );
  }
}
