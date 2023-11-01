import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/model/content_model.dart';
import 'package:insource/model/open_ai_model.dart';
import 'package:insource/services/firebase_services.dart';
import 'package:insource/services/openai_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreListViewProvider extends ChangeNotifier {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String todaysIdea = "Hmmm... there is something wrong";

  List<ContentData> contentList = [];

  bool isLoading = true;

  ExploreListViewProvider() {
    generateIdeas();
    getRandomizeList();
  }

  void generateIdeas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final GptData recommend = await RecomendationServices.getRecomendation();
    final DateTime currentDate = DateTime.now();
    final savedTime = prefs.getString('currentDate');

    if (savedTime != null) {
      if (daysBetween(currentDate, DateTime.parse(savedTime)) != 0) {
        todaysIdea = recommend.choices[0].text;
        await prefs.setString('currentDate', currentDate.toString());
        await prefs.setString('todaysIdea', todaysIdea);
      } else {
        todaysIdea = prefs.getString('todaysIdea')!;
      }
    } else {
      todaysIdea = recommend.choices[0].text;
      await prefs.setString('currentDate', currentDate.toString());
      await prefs.setString('todaysIdea', todaysIdea);
    }
    notifyListeners();
  }

  void getRandomizeList() async {
    contentList = await FirebaseServices.getContentList();
    contentList.shuffle();
    debugPrint(contentList.toString());
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    isLoading = true;
    notifyListeners();
    contentList.clear();
    getRandomizeList();
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

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
