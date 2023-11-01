import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/model/content_model.dart';
import 'package:insource/services/firebase_services.dart';

class SavedListViewProvider extends ChangeNotifier {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  bool isLoading = true;

  List<ContentData> contentList = [];

  SavedListViewProvider() {
    getContentList();
  }

  void getContentList() async {
    contentList = await FirebaseServices.getSavedContentList(currentUser!);
    contentList.reversed;
    debugPrint(contentList.toString());
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    isLoading = true;
    notifyListeners();
    contentList.clear();
    getContentList();
  }

  void likeContent(int index) {
    final selectedContent = contentList[index];

    FirebaseServices.likeContent(
      currentUser!,
      selectedContent.documentId,
      selectedContent.liked.contains(currentUser!.uid),
    );

    if (selectedContent.liked.contains(currentUser!.uid)) {
      selectedContent.liked.remove(currentUser!.uid);
    } else {
      selectedContent.liked.add(currentUser!.uid);
    }
    notifyListeners();
  }

  void saveContent(int index) async {
    final selectedContent = contentList[index];

    await FirebaseServices.saveContent(
      currentUser!,
      selectedContent.documentId,
      selectedContent.saved.contains(currentUser!.uid),
    );

    if (selectedContent.saved.contains(currentUser!.uid)) {
      selectedContent.saved.remove(currentUser!.uid);
    } else {
      selectedContent.saved.add(currentUser!.uid);
    }
    notifyListeners();
  }
}
