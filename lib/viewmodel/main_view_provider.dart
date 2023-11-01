// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insource/services/firebase_services.dart';
import 'package:insource/view/screen/explore_screen/explore_content_list.dart';
import 'package:insource/view/screen/personal_profile_screen/user_account_view.dart';
import 'package:insource/view/widgets/upload_bottom_sheet.dart';

class MainViewProvider extends ChangeNotifier {
  final List<Widget> pageList = [
    const ContentList(),
    const AccountView(),
  ];

  int currentIndex = 0;

  late Widget currentPage;

  late BuildContext context;

  final TextEditingController contentTitleController = TextEditingController();

  String? selectedImagePath;

  MainViewProvider() {
    currentPage = pageList[0];
  }

  void bottomNavFunction(int index) {
    switch (index) {
      case 0:
        currentPage = pageList[0];
        currentIndex = index;
        break;
      case 1:
        showUploadBottomSheet();
        break;
      case 2:
        currentPage = pageList[1];
        currentIndex = index;
        break;
    }
    notifyListeners();
  }

  Future<String?> cameraImagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    debugPrint('${file?.path}');
    return file?.path.toString();
  }

  Future<String?> galleryImagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    debugPrint('${file?.path}');
    return file?.path.toString();
  }

  Future showUploadBottomSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      barrierColor: Colors.black87,
      builder: (context) => UploadBottomSheet(
        pickFromCamera: () async {
          String? imagePath = await cameraImagePicker();
          if (imagePath != null) {
            selectedImagePath = imagePath;
            Navigator.popAndPushNamed(context, '/uploadScreen');
          }
        },
        pickFromGallery: () async {
          String? imagePath = await galleryImagePicker();
          if (imagePath != null) {
            selectedImagePath = imagePath;
            Navigator.popAndPushNamed(context, '/uploadScreen');
          }
        },
      ),
    );
  }

  void uploadFunction() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    FirebaseServices.uploadContent(
        currentUser!, contentTitleController.text, selectedImagePath!);
    Navigator.pop(context);
  }
}
