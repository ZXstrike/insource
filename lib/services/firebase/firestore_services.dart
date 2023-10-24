import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insource/const/string.dart';
import 'package:insource/model/content_model.dart';
import 'package:insource/model/user_personal_model.dart';

class FireStore {
  void setUserData(User currentUser, Map<String, dynamic> userData) {
    FirebaseFirestore.instance
        .collection('usersData')
        .doc(currentUser.uid)
        .set(userData);
  }

  Future<UserPersonalData> getUserData(String userid) async {
    UserPersonalData userData = await FirebaseFirestore.instance
        .collection(StringConst.userData)
        .doc(userid)
        .get()
        .then(
          (value) => UserPersonalData.fromMap(
            value.data()!,
          ),
        );
    return userData;
  }

  Future<List<ContentData>> getContentList() async {
    List<ContentData> contentList = [];

    await FirebaseFirestore.instance.collection('contentsData').get().then(
      (value) async {
        debugPrint('FireStore : "Successfully retrive data."');

        for (var userDoc in value.docs) {
          final docData = userDoc.data();

          Map<String, dynamic> contentData = {
            'documentId': userDoc.id,
            'imageUrl': docData['imageUrl'],
            'title': docData['title'],
            'liked': docData['liked'],
            'creatorId': docData['creator'],
          };

          await FirebaseFirestore.instance
              .collection('usersData')
              .doc(docData['creator'])
              .get()
              .then((userDoc) {
            final data = userDoc.data();

            contentData.addAll({
              'creatorName': data?['userName'],
              'creatorPicture': data?['profileImageUrl'],
            });
          });

          debugPrint(contentData.toString());

          contentList.add(ContentData.fromMapToModel(contentData));
        }
      },
    );

    return contentList;
  }

  Future<List<ContentData>> getPersonalContentList(User user) async {
    List<ContentData> contentList = [];

    await FirebaseFirestore.instance
        .collection('contentsData')
        .where("creator", isEqualTo: user.uid)
        .get()
        .then(
      (value) async {
        debugPrint('FireStore : "Successfully retrive data."');

        for (var userDoc in value.docs) {
          final docData = userDoc.data();

          Map<String, dynamic> contentData = {
            'documentId': userDoc.id,
            'imageUrl': docData['imageUrl'],
            'title': docData['title'],
            'liked': docData['liked'],
            'creatorId': docData['creator'],
          };

          await FirebaseFirestore.instance
              .collection('usersData')
              .doc(docData['creator'])
              .get()
              .then((userDoc) {
            final data = userDoc.data();

            contentData.addAll({
              'creatorName': data?['userName'],
              'creatorPicture': data?['profileImageUrl'],
            });
          });

          debugPrint(contentData.toString());

          contentList.add(ContentData.fromMapToModel(contentData));
        }
      },
    );

    return contentList;
  }

  Future<List<ContentData>> getLikedContentList(User user) async {
    List<ContentData> contentList = [];

    await FirebaseFirestore.instance
        .collection('contentsData')
        .where("liked", arrayContains: user.uid)
        .get()
        .then(
      (value) async {
        debugPrint('FireStore : "Successfully retrive data."');

        for (var userDoc in value.docs) {
          final docData = userDoc.data();

          Map<String, dynamic> contentData = {
            'documentId': userDoc.id,
            'imageUrl': docData['imageUrl'],
            'title': docData['title'],
            'liked': docData['liked'],
            'creatorId': docData['creator'],
          };

          await FirebaseFirestore.instance
              .collection('usersData')
              .doc(docData['creator'])
              .get()
              .then((userDoc) {
            final data = userDoc.data();

            contentData.addAll({
              'creatorName': data?['userName'],
              'creatorPicture': data?['profileImageUrl'],
            });
          });

          debugPrint(contentData.toString());

          contentList.add(ContentData.fromMapToModel(contentData));
        }
      },
    );

    return contentList;
  }

  Future searchUser(String query) async {
    FirebaseFirestore.instance
        .collection(StringConst.userData)
        .where('userName',
            isGreaterThanOrEqualTo: query,
            isLessThan: query.substring(0, query.length - 1) +
                String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .get()
        .then((value) => debugPrint(value.toString()));
  }
}
