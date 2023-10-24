import 'package:flutter/material.dart';

class UploadBottomSheet extends StatelessWidget {
  const UploadBottomSheet({
    super.key,
    this.pickFromCamera,
    this.pickFromGallery,
  });

  final void Function()? pickFromCamera;
  final void Function()? pickFromGallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            iconSize: 60,
            color: Colors.white,
            onPressed: pickFromCamera,
            icon: const Icon(
              Icons.camera_alt_outlined,
              size: 50,
            ),
          ),
          IconButton(
            iconSize: 60,
            color: Colors.white,
            onPressed: pickFromGallery,
            icon: const Icon(
              Icons.image_outlined,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
