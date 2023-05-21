import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';

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

List shuffle(List items) {
  var random = Random();

  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
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
  final _imageItems = [
    'lib/assets/images/1.jpg',
    'lib/assets/images/2.jpg',
    'lib/assets/images/3.jpg',
    'lib/assets/images/4.jpg',
    'lib/assets/images/5.jpg',
    'lib/assets/images/6.png',
    'lib/assets/images/7.jpg',
    'lib/assets/images/8.jpg',
    'lib/assets/images/9.jpg',
    'lib/assets/images/10.jpg',
    'lib/assets/images/11.jpg',
    'lib/assets/images/12.jpg',
    'lib/assets/images/13.jpg',
    'lib/assets/images/14.jpeg',
    'lib/assets/images/15.jpg',
    'lib/assets/images/16.jpg',
  ];

  Widget _masonExploreImages(imagesList) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 30),
      child: MasonryView(
        listOfItem: shuffle(imagesList),
        itemRadius: 0,
        itemPadding: 4.5,
        numberOfColumn: 2,
        itemBuilder: (item) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/PostDetail', arguments: item);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(image: AssetImage(item)),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: _masonExploreImages(_imageItems),
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
