import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insource/ui/mainUI/contentView/content_card.dart';

class ContentList extends StatefulWidget {
  const ContentList({super.key});

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  final ScrollController _scrollController = ScrollController();
  List<Map> contentList = [];
  List<Map> pageList = [];
  // bool _isLoading = false;

  void _getData() {
    FirebaseFirestore.instance.collection('contentsData').get().then(
      (querySnapshot) {
        debugPrint('Successfully retrive data.');
        for (var docSnapshot in querySnapshot.docs) {
          final doc = docSnapshot.data();
          debugPrint(doc.toString());

          Map<String, dynamic> contentData = {
            'contentImage': doc['imageUrl'],
            'title': doc['title'],
          };

          FirebaseFirestore.instance
              .collection('usersData')
              .doc(doc['creator'])
              .get()
              .then((userDoc) {
            final data = userDoc.data();

            contentData.addAll({
              'creator': data?['userName'],
              'profileImage': data?['profileImageUrl'],
            });
            setState(() {});
          });

          debugPrint('list data: $contentData');
          contentList.add(contentData);
        }

        if (contentList.length > 999) {
          for (var i = 0; i < 10; i++) {
            int randomIndex = Random().nextInt(contentList.length);
            pageList.add(contentList[randomIndex]);
            contentList.removeAt(randomIndex);
            debugPrint(i.toString());
          }
        } else {
          contentList.shuffle();
          pageList.addAll(contentList);
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
    _getData();
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     _loadMore();
  //   }
  // }

  Future<void> _onRefresh() async {
    contentList.clear();
    setState(() {
      contentList.clear();
      pageList.clear();
      _getData();
    });
  }

  // void _loadMore() async {
  //   if (!_isLoading) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     if (contentList.length > 10) {
  //       for (var i = 0; i < 10; i++) {
  //         int randomIndex = Random().nextInt(contentList.length);
  //         pageList.add(contentList[randomIndex]);
  //         contentList.removeAt(randomIndex);
  //         debugPrint(i.toString());
  //       }
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (contentList.isEmpty) {
      return const Center(
        child: Text(
          'There is nothing, Huh?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: pageList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ContentCard(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              radius: 15,
              contentImage:
                  NetworkImage(pageList[index]['contentImage'], scale: 0.1),
              profileImage:
                  NetworkImage(pageList[index]['profileImage'], scale: 0.005),
              title: pageList[index]['title'],
              creator: pageList[index]['creator'],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      );
    }
  }
}
