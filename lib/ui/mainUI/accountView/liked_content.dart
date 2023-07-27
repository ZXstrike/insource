import 'package:flutter/material.dart';

class LikedContentList extends StatefulWidget {
  const LikedContentList({super.key});

  @override
  State<LikedContentList> createState() => _LikedContentListState();
}

class _LikedContentListState extends State<LikedContentList> {
  List<Map> contentList = [];

  @override
  Widget build(BuildContext context) {
    if (contentList.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 75),
        alignment: Alignment.center,
        child: const Text(
          'There is nothing, Huh?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
