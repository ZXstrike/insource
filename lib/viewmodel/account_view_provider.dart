import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/model/user_personal_model.dart';
import 'package:insource/services/firebase/firestore_services.dart';

class AccountViewProvider extends ChangeNotifier {
  User currentUser = FirebaseAuth.instance.currentUser!;
  late final UserPersonalData userData;

  late TabController tabController;

  bool isLoaded = false;

  late BuildContext context;

  AccountViewProvider() {
    getUserData();
  }

  void getUserData() async {
    userData = await FireStore().getUserData(currentUser.uid);
    isLoaded = true;
    notifyListeners();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
