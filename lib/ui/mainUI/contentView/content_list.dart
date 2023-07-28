import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final User? currentUser = FirebaseAuth.instance.currentUser;
  // bool _isLoading = false;

  void _getData() {
    FirebaseFirestore.instance.collection('contentsData').get().then(
      (querySnapshot) {
        debugPrint('Successfully retrive data.');
        for (var docSnapshot in querySnapshot.docs) {
          final doc = docSnapshot.data();
          debugPrint(doc.toString());

          Map<String, dynamic> contentData = {
            'documentId': docSnapshot.id,
            'contentImage': doc['imageUrl'],
            'title': doc['title'],
            'liked': doc['liked'],
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
        contentList.shuffle();
        pageList.addAll(contentList);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _onRefresh() async {
    contentList.clear();
    setState(() {
      contentList.clear();
      pageList.clear();
      _getData();
    });
  }

  void _likedFunction(index) {
    if (pageList[index]['liked'].contains(currentUser?.uid)) {
      debugPrint(index.toString());
      FirebaseFirestore.instance
          .collection('contentsData')
          .doc(pageList[index]['documentId'])
          .update({
        'liked': FieldValue.arrayRemove([currentUser?.uid])
      }).then((value) {
        pageList[index]['liked'].remove(currentUser?.uid);
        debugPrint(pageList[index]['liked'].toString());
        setState(() {});
      }, onError: (e) => debugPrint("Error updating document $e"));
      setState(() {});
    } else {
      debugPrint(index.toString());
      FirebaseFirestore.instance
          .collection('contentsData')
          .doc(pageList[index]['documentId'])
          .update({
        'liked': FieldValue.arrayUnion([currentUser?.uid])
      }).then((value) {
        pageList[index]['liked'].add(currentUser?.uid);
        debugPrint(pageList[index]['liked'].toString());
        setState(() {});
      }, onError: (e) => debugPrint("Error updating document $e"));
      setState(() {});
    }
  }

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
              icon:
                  contentList[index]['liked'].contains(currentUser?.uid) == true
                      ? const Icon(
                          Icons.favorite,
                          size: 35,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.favorite_outline_outlined,
                          size: 35,
                          color: Colors.white,
                        ),
              likeFunction: () => _likedFunction(index),
            ),
          ),
        ),
      );
    }
  }
}
