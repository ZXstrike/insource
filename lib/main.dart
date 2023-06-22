//import 'cust_fun.dart';

// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
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
            return MaterialPageRoute(builder: (context) => const SplashPage());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/upload':
            return MaterialPageRoute(
              builder: (context) => UploadContentPage(
                imagePath: settings.arguments.toString(),
              ),
            );
          case '/PostDetail':
            return MaterialPageRoute(
              builder: (context) => PostDetail(
                item: settings.arguments.toString(),
              ),
            );
          case '/accountPage':
            return MaterialPageRoute(builder: (context) => const AccountPage());
        }
        return null;
      },
    ),
  );
}

class ListContentData {
  final String contentTitle;
  final String contentUrl;
  final String contentImageUrl;

  ListContentData(
    this.contentTitle,
    this.contentUrl,
    this.contentImageUrl,
  );
}

class ContentData {
  final String contentCreator;
  final String contentTitle;
  final String contentUrl;
  final String contentImageUrl;
  final int contentLike;
  final bool contentLikeState;
  final bool contentSavedState;

  ContentData(
    this.contentCreator,
    this.contentTitle,
    this.contentUrl,
    this.contentImageUrl,
    this.contentLike,
    this.contentLikeState,
    this.contentSavedState,
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
            ),
          ),
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
            if (index == 0) {
              Navigator.popAndPushNamed(context, "/home");
            } else {
              Navigator.pushNamed(context, "/home");
            }
            break;
          case 1:
            showModalBottomSheet(
              context: context,
              barrierColor: Colors.black87,
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 60,
                        onPressed: () async {
                          getImage() async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.camera);
                            debugPrint('${file?.path}');
                            return file?.path.toString();
                          }

                          String? imagePath = await getImage();
                          if (imagePath != null) {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/upload',
                                arguments: imagePath);
                          }
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 50,
                        ),
                      ),
                      IconButton(
                        iconSize: 60,
                        onPressed: () async {
                          getImage() async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            debugPrint('${file?.path}');
                            return file?.path.toString();
                          }

                          String? imagePath = await getImage();
                          if (imagePath != null) {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/upload',
                                arguments: imagePath);
                          }
                        },
                        icon: const Icon(
                          Icons.image_outlined,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
            break;
          case 2:
            if (index == 2) {
              Navigator.popAndPushNamed(context, "/accountPage");
            } else {
              Navigator.pushNamed(context, '/accountPage');
            }
            break;
        }
      },
    );
  }
}

class FirebaseDataManager {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firedb = FirebaseFirestore.instance;
  final storegedb = FirebaseStorage.instance;

  getCurrentUserID() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return uid;
  }

  getContentDetail(docId) {
    final firedb = FirebaseFirestore.instance;

    firedb.collection('conntent').doc(docId).get().then(
      (document) {
        debugPrint('data : ${document.data() as Map<String, dynamic>}');
        final data = document.data() as Map<String, dynamic>;

        ContentData(data['creator'], data['title'], docId, data['imageUrl'],
            data['like'], false, false);
      },
    );
  }
}

class UploadContentPage extends StatefulWidget {
  final String imagePath;
  const UploadContentPage({super.key, required this.imagePath});

  @override
  State<UploadContentPage> createState() => _UploadContentPageState();
}

class _UploadContentPageState extends State<UploadContentPage> {
  final TextEditingController titleController = TextEditingController();
  Widget _detailForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Image(
            image: FileImage(
              File(widget.imagePath),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: TextField(
            maxLength: 100,
            controller: titleController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Tittle',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(),
          child: TextButton(
            onPressed: () {
              final uuid = const Uuid().v4();

              final storageRef =
                  FirebaseStorage.instance.ref().child('contentImage/$uuid');

              File imageFile = File(widget.imagePath);
              storageRef.putFile(imageFile).snapshotEvents.listen(
                (taskSnapshot) async {
                  switch (taskSnapshot.state) {
                    case TaskState.running:
                      // ...
                      break;
                    case TaskState.paused:
                      // ...
                      break;
                    case TaskState.success:
                      final db = FirebaseFirestore.instance;
                      final contentData = <String, dynamic>{
                        'imageUrl': await storageRef.getDownloadURL(),
                        'title': titleController.text,
                        'date': FieldValue.serverTimestamp(),
                        'creator': FirebaseDataManager().getCurrentUserID(),
                        'likeNumber': 0,
                      };

                      db
                          .collection('ContentData')
                          .doc(uuid)
                          .set(contentData)
                          .then(
                        (_) {
                          db
                              .collection('usersData')
                              .doc(FirebaseDataManager().getCurrentUserID())
                              .update(
                            {
                              'contentCreated': FieldValue.arrayUnion([uuid])
                            },
                          ).then(
                            (value) => debugPrint('data: updated'),
                            onError: (e) =>
                                debugPrint('data: failed to update $e'),
                          );
                        },
                        onError: (e) => debugPrint('data: failed to update $e'),
                      );
                      break;
                    case TaskState.canceled:
                      // ...
                      break;
                    case TaskState.error:
                      // ...
                      break;
                  }
                },
              );
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _detailForm(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ListContentData> contentDataList = [];

  @override
  void initState() {
    super.initState();
    final firedb = FirebaseFirestore.instance;

    firedb.collection('ContentData').get().then(
      (querySnapshot) {
        debugPrint("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
          final doc = docSnapshot.data();
          final data = ListContentData(
            doc['title'],
            docSnapshot.id,
            doc['imageUrl'],
          );
          contentDataList.add(data);
        }
        setState(() {});
        debugPrint(contentDataList.length.toString());
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  Widget _masonryView() {
    return SingleChildScrollView(
      child: MasonryView(
        itemRadius: 0,
        itemPadding: 0,
        listOfItem: contentDataList,
        numberOfColumn: 2,
        itemBuilder: (contentData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/PostDetail',
                    arguments: contentData.contentUrl);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(contentData.contentImageUrl),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      contentData.contentTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _masonryGridView() {
  //   return MasonryGridView.builder(
  //     padding: const EdgeInsets.only(top: 30, right: 4, left: 4, bottom: 6),
  //     physics: const AlwaysScrollableScrollPhysics(),
  //     itemCount: contentDataList.length,
  //     addAutomaticKeepAlives: false,
  //     mainAxisSpacing: 12,
  //     crossAxisSpacing: 8,
  //     gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2),
  //     itemBuilder: (context, index) {
  //       ListContentData contentData = contentDataList[index];
  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.pushNamed(context, '/PostDetail',
  //               arguments: contentData.contentUrl);
  //         },
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(15),
  //               child: Image.network(contentData.contentImageUrl),
  //             ),
  //             Container(
  //               padding: const EdgeInsets.all(6),
  //               alignment: Alignment.centerLeft,
  //               child: Text(
  //                 contentData.contentTitle,
  //                 style: const TextStyle(color: Colors.white, fontSize: 12),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: _masonryView(),
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
  // var contentCreator = '';
  // var contentTitle = '';
  // var contentUrl = '';
  // var contentImageUrl = '';
  // var contentLike = 0;
  // var contentLikeState = false;
  // // var contentSavedState = false;

  // @override
  // void initState() {
  //   super.initState();
  //   final contentData =
  //       FirebaseDataManager().getContentDetil(widget.item).toString();
  //   final firedb = FirebaseFirestore.instance;

  //   firedb.collection('ContentData').doc(widget.item).get().then(
  //     (doc) {
  //       debugPrint('map : ${doc.data()}');
  //       contentCreator = doc['creator'];
  //       contentTitle = doc['title'];
  //       contentUrl = widget.item;
  //       contentImageUrl = doc['imageUrl'];
  //       debugPrint('debug : ${doc['imageUrl']}');
  //       contentLike = doc['like'];

  //       setState(() {});
  //       debugPrint(
  //           '$contentCreator, $contentTitle, $contentUrl, $contentImageUrl');
  //     },
  //     onError: (e) => debugPrint("Error completing: $e"),
  //   );
  // }

  Widget _postContent() {
    final contentData = FirebaseDataManager().getContentDetail(widget.item);
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
                  Image.network(contentData.imageUrl),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 5, right: 15, left: 15),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 15),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blue,
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
      padding: const EdgeInsets.only(top: 15),
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
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'username',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(),
            child: Text(
              '@username',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _masonryView() {
    final listOfItemContent = [];

    return MasonryView(
      listOfItem: listOfItemContent,
      itemPadding: 0,
      itemRadius: 0,
      numberOfColumn: 2,
      itemBuilder: (context) => GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: null, //add image
            ),
            Container(
              padding: const EdgeInsets.all(6),
              alignment: Alignment.centerLeft,
              child: const Text(
                '',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _contentList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text('Created'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Saved'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _masonryView(),
        ),
      ],
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
            MaterialPageRoute(
              builder: (context) => const SplashPage(),
            ),
          ) as Route<Object?>,
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Logout'),
          Icon(Icons.logout_outlined),
        ],
      ),
    );
  }

  Widget _simpleMenuButton() {
    return Container(
      padding: const EdgeInsets.only(top: 45),
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _logoutButton(),
                  ],
                ),
              );
            },
          );
        },
        icon: const Icon(
          Icons.menu_rounded,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _simpleMenuButton(),
          _topAccountDetail(),
          _contentList(),
        ],
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
              labelText: 'Email Address',
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
  final TextEditingController userNameController = TextEditingController();
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
            controller: userNameController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'User Name',
              hintText: '',
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
              labelText: 'Email Address',
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('The password provided is too weak.'),
                    ),
                  );
                } else if (e.code == 'email-already-in-use') {
                  debugPrint('The account already exists for that email.');
                }
              } catch (e) {
                debugPrint(e.toString());
              }

              final db = FirebaseFirestore.instance;
              final newUserData = <String, dynamic>{
                'name': userNameController.text,
                'username': userNameController.text,
                'email': emailController.text,
                'profileUrl': '',
                'contentCreated': [],
                'contentSaved': [],
                'contentLiked': [],
              };

              FirebaseAuth.instance.authStateChanges().listen(
                (User? user) {
                  if (user == null) {
                    debugPrint('User currently signed out!');
                  } else {
                    debugPrint('User is signed in!');

                    db
                        .collection('usersData')
                        .doc(FirebaseDataManager().getCurrentUserID())
                        .set(newUserData, SetOptions(merge: true))
                        .onError(
                          (e, _) => debugPrint('Error writing document: $e'),
                        );

                    Navigator.pushReplacement(
                      context,
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
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
          const Duration(
            seconds: 1,
            milliseconds: 50,
          ),
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
