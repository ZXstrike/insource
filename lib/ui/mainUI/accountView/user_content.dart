import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/ui/mainUI/contentView/content_card.dart';

class UserContentList extends StatefulWidget {
  const UserContentList({super.key});

  @override
  State<UserContentList> createState() => _UserContentListState();
}

class _UserContentListState extends State<UserContentList> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map> contentList = [];
  final User? currentUser = FirebaseAuth.instance.currentUser;

  void _getData() {
    FirebaseFirestore.instance
        .collection('contentsData')
        .where("creator", isEqualTo: user?.uid)
        .get()
        .then(
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
          contentList.insert(0, contentData);
        }
        setState(() {});
      },
    );
  }

  void _likedFunction(index) {
    if (contentList[index]['liked'].contains(currentUser?.uid)) {
      debugPrint(index.toString());
      FirebaseFirestore.instance
          .collection('contentsData')
          .doc(contentList[index]['documentId'])
          .update({
        'liked': FieldValue.arrayRemove([currentUser?.uid])
      }).then((value) {
        contentList[index]['liked'].remove(currentUser?.uid);
        debugPrint(contentList[index]['liked'].toString());
        setState(() {});
      }, onError: (e) => debugPrint("Error updating document $e"));
      setState(() {});
    } else {
      debugPrint(index.toString());
      FirebaseFirestore.instance
          .collection('contentsData')
          .doc(contentList[index]['documentId'])
          .update({
        'liked': FieldValue.arrayUnion([currentUser?.uid])
      }).then((value) {
        contentList[index]['liked'].add(currentUser?.uid);
        debugPrint(contentList[index]['liked'].toString());
        setState(() {});
      }, onError: (e) => debugPrint("Error updating document $e"));
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
    _getData();
  }

  Future<void> _onRefresh() async {
    contentList.clear();
    setState(() {
      contentList.clear();
      _getData();
    });
  }

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
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: contentList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ContentCard(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              radius: 15,
              contentImage:
                  NetworkImage(contentList[index]['contentImage'], scale: 0.1),
              profileImage: NetworkImage(contentList[index]['profileImage'],
                  scale: 0.005),
              title: contentList[index]['title'],
              creator: contentList[index]['creator'],
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
