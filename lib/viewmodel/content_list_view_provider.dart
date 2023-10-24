import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/model/content_model.dart';
import 'package:insource/services/firebase/firestore_services.dart';

class ExploreListViewProvider extends ChangeNotifier {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  List<ContentData> contentList = [];

  ExploreListViewProvider() {
    getRandomizeList();
  }

  void getRandomizeList() async {
    contentList = await FireStore().getContentList();
    contentList.shuffle();
    debugPrint(contentList.toString());
    notifyListeners();
  }

  Future<void> onRefresh() async {
    contentList.clear();
    getRandomizeList();
  }

  void likeContent(index) {}
}
