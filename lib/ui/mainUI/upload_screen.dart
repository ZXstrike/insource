// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:insource/ui/widgets/input_widget.dart';
import 'package:uuid/uuid.dart';

class ContentUploadScreen extends StatefulWidget {
  const ContentUploadScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ContentUploadScreen> createState() => _ContentUploadScreenState();
}

class _ContentUploadScreenState extends State<ContentUploadScreen> {
  final TextEditingController contentTitleController = TextEditingController();

  _uploadFunction() {
    final uuid = const Uuid().v4();
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('contentImage/${currentUser?.uid}/$uuid');

    File imageFile = File(widget.imagePath);

    storageRef.putFile(imageFile).snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // ...
          break;
        case TaskState.paused:
          // ...
          break;
        case TaskState.success:
          final contentData = <String, dynamic>{
            'imageUrl': await storageRef.getDownloadURL(),
            'title': contentTitleController.text,
            'date': FieldValue.serverTimestamp(),
            'creator': currentUser?.uid,
            'liked': []
          };
          FirebaseFirestore.instance
              .collection('contentsData')
              .doc(uuid)
              .set(contentData)
              .then(
                (value) => debugPrint('Upload Status: ${taskSnapshot.state}'),
                onError: (e) => debugPrint('Upload Status: $e'),
              );
          Navigator.popAndPushNamed(context, '/homeScreen');
          break;
        case TaskState.canceled:
          // ...
          break;
        case TaskState.error:
          // ...
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(10, 10, 10, 255),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Image(image: FileImage(File(widget.imagePath))),
            ),
            TextInputSpace(
              verticalOutterPadding: 20,
              radius: 10,
              inputController: contentTitleController,
              inputHint: 'Title',
              inputHintStyle: const TextStyle(fontSize: 18),
            ),
            ButtonSpace(
              radius: 5,
              onPressed: _uploadFunction,
              child: const Text(
                'Upload',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
