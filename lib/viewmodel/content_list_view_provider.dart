import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/model/content_model.dart';
import 'package:insource/model/open_ai.dart';
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
      if (daysBetween(currentDate, DateTime.parse(savedTime)) >= 1) {
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

  void likeContent(index) {}

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inDays).round();
  }
}
