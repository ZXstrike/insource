import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

initFirebaseOption() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class FireAuth {
  Future<bool> getSessionStatus() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  logout() {
    FirebaseAuth.instance.signOut();
  }

  login(email, password) async {
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email address.');
        debugPrint(e.code);
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password for that email user.');
        debugPrint(e.code);
      } else {
        debugPrint(e.code);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  register(username, email, password) {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class FireStore {}
