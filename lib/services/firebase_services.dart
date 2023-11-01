import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:insource/const/string.dart';
import 'package:insource/model/content_model.dart';
import 'package:insource/model/user_personal_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices {
  static void setUserData(User currentUser, Map<String, dynamic> userData) {
    FirebaseFirestore.instance
        .collection('usersData')
        .doc(currentUser.uid)
        .set(userData);
  }

  static Future<UserPersonalData> getUserData(String userid) async {
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

  static Future<List<ContentData>> getContentList() async {
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
            'saved': docData['saved'],
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

  static Future<List<ContentData>> getPersonalContentList(User user) async {
    List<ContentData> contentList = [];

    await FirebaseFirestore.instance
        .collection('contentsData')
        .where("creator", isEqualTo: user.uid)
        .orderBy('date', descending: true)
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
            'saved': docData['saved'],
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

  static Future<List<ContentData>> getSavedContentList(User user) async {
    List<ContentData> contentList = [];

    await FirebaseFirestore.instance
        .collection('contentsData')
        .where("saved", arrayContains: user.uid)
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
            'saved': docData['saved'],
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

  static Future<void> uploadContent(
      User currentUser, String title, String selectedImagePath) async {
    final uuid = const Uuid().v4();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('contentImage/${currentUser.uid}/$uuid');

    File imageFile = File(selectedImagePath);

    storageRef.putFile(imageFile).snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // ...
          break;
        case TaskState.paused:
          // ...
          break;
        case TaskState.success:
          final contentData = <String, dynamic>{
            'imageUrl': await storageRef.getDownloadURL(),
            'title': title,
            'date': FieldValue.serverTimestamp(),
            'creator': currentUser.uid,
            'liked': [],
            'saved': [],
          };
          FirebaseFirestore.instance
              .collection('contentsData')
              .doc(uuid)
              .set(contentData)
              .then(
                (value) => debugPrint('Upload Status: ${taskSnapshot.state}'),
                onError: (e) => debugPrint('Upload Status: $e'),
              );
          break;
        case TaskState.canceled:
          // ...
          break;
        case TaskState.error:
          // ...
          break;
      }
    });
  }

  static Future<void> likeContent(
      User currentUser, String docId, bool state) async {
    final newState = state
        ? {
            'liked': FieldValue.arrayRemove([currentUser.uid])
          }
        : {
            'liked': FieldValue.arrayUnion([currentUser.uid])
          };
    await FirebaseFirestore.instance
        .collection('contentsData')
        .doc(docId)
        .update(newState)
        .then((value) {}, onError: (e) => debugPrint('=> $e'));
  }

  static Future<void> saveContent(
      User currentUser, String docId, bool state) async {
    final Map<String, dynamic> newState = state
        ? {
            'saved': FieldValue.arrayRemove([currentUser.uid])
          }
        : {
            'saved': FieldValue.arrayUnion([currentUser.uid])
          };
    await FirebaseFirestore.instance
        .collection('contentsData')
        .doc(docId)
        .update(newState)
        .then((value) {}, onError: (e) => debugPrint('=> $e'));
  }

  static Future<void> delete(contentId) async {
    await FirebaseFirestore.instance
        .collection('contetsData')
        .doc(contentId)
        .delete();
  }
}
