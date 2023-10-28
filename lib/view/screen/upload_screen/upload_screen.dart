// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insource/view/widgets/input_widget.dart';
import 'package:insource/viewmodel/main_view_provider.dart';
import 'package:provider/provider.dart';

class ContentUploadScreen extends StatefulWidget {
  const ContentUploadScreen({super.key});

  @override
  State<ContentUploadScreen> createState() => _ContentUploadScreenState();
}

class _ContentUploadScreenState extends State<ContentUploadScreen> {
  late MainViewProvider providers;

  @override
  void initState() {
    super.initState();
    providers = Provider.of<MainViewProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(10, 10, 10, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Image(
                image: FileImage(File(providers.selectedImagePath!)),
                fit: BoxFit.cover,
              ),
            ),
            TextInputSpace(
              verticalOutterPadding: 20,
              radius: 10,
              inputController: providers.contentTitleController,
              inputHint: 'Title',
              inputHintStyle: const TextStyle(fontSize: 18),
            ),
            ButtonSpace(
              radius: 5,
              onPressed: providers.uploadFunction,
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
