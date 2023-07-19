import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insource/ui/homeUI/account_view.dart';
import 'package:insource/ui/homeUI/mansory_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;

  Future uploadModals() {
    return showModalBottomSheet(
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
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: screenIndex == 0 ? const MansoryList() : const AccountView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex,
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
              setState(() {
                screenIndex = 0;
              });
              break;
            case 1:
              uploadModals();
              break;
            case 2:
              setState(() {
                screenIndex = 2;
              });
              break;
          }
        },
      ),
    );
  }
}
