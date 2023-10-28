import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/model/content_model.dart';
import 'package:insource/services/firebase_services.dart';

class PersonalListViewProvider extends ChangeNotifier {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  List<ContentData> contentList = [];

  PersonalListViewProvider() {
    getContentList();
    notifyListeners();
  }

  void getContentList() async {
    contentList = await FirebaseServices.getPersonalContentList(currentUser!);
    contentList.reversed;

    debugPrint(contentList.toString());
    notifyListeners();
  }

  Future<void> onRefresh() async {
    getContentList();
    notifyListeners();
  }

  void likeContent(index) {}
}

  // void _likedFunction(index) {
  //   if (contentList[index]['liked'].contains(currentUser?.uid)) {
  //     debugPrint(index.toString());
  //     FirebaseFirestore.instance
  //         .collection('contentsData')
  //         .doc(contentList[index]['documentId'])
  //         .update({
  //       'liked': FieldValue.arrayRemove([currentUser?.uid])
  //     }).then((value) {
  //       contentList[index]['liked'].remove(currentUser?.uid);
  //       debugPrint(contentList[index]['liked'].toString());
  //       setState(() {});
  //     }, onError: (e) => debugPrint("Error updating document $e"));
  //     setState(() {});
  //   } else {
  //     debugPrint(index.toString());
  //     FirebaseFirestore.instance
  //         .collection('contentsData')
  //         .doc(contentList[index]['documentId'])
  //         .update({
  //       'liked': FieldValue.arrayUnion([currentUser?.uid])
  //     }).then((value) {
  //       contentList[index]['liked'].add(currentUser?.uid);
  //       debugPrint(contentList[index]['liked'].toString());
  //       setState(() {});
  //     }, onError: (e) => debugPrint("Error updating document $e"));
  //     setState(() {});
  //   }
  // }
