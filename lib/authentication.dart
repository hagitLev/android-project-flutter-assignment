import 'dart:async';
import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }


class AuthRepository with ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Uninitialized;
  final _fireStore = FirebaseFirestore.instance;
  final _savedSuggestions = <WordPair> {};
  var _localSave = <WordPair>{};


  AuthRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  Status get status => _status;

  User? get user => _user;

  bool get isAuthenticated => status == Status.Authenticated;
  bool get isAuthenticating => status == Status.Authenticating;

  // Set<WordPair> get savedSuggestions => _savedSuggestions;
  //
  // Set<WordPair> get localSave => _localSave;

  Future<UserCredential?> signUp({required String email, required String password}) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<bool> signIn({required String email, required String password}) async { //String email, String password,
    try {
      _status = Status.Authenticating;
      notifyListeners();
      // Timer(const Duration(seconds: 5), () async {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      // });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    // return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  // // Create a CollectionReference called users that references the firestore collection
  // CollectionReference saved = FirebaseFirestore.instance.collection('saved');
  // Future<void> addSuggestion(splitPair) {
  //   // Call the user's CollectionReference to add a new pair
  //   return saved
  //       .add({
  //     'first': splitPair[0],
  //     'second': splitPair[1],
  //     'user': AuthRepository
  //         .instance()
  //         .user
  //         ?.email
  //         .toString(),
  //     'created': Timestamp.now(),
  //   })
  //       .then((value) => print("User suggestion was Added"))
  //   // .then((value) => print('_currentData is : $_currentData'))
  //       .catchError(
  //           (error) => print("Failed to add user's suggestion: $error"));
  // }

  // Future<void> getData() async {
  //   // var _temp = <WordPair>{};
  //   var collection = _fireStore.collection('saved');
  //   var querySnapshot = await collection.get();
  //   for (var doc in querySnapshot.docs) {
  //     Map<String, dynamic> data = doc.data();
  //     if (data['user'] == AuthRepository
  //         .instance()
  //         .user
  //         ?.email) {
  //       final first = data['first'];
  //       final second = data['second'];
  //       final pair = WordPair(first, second);
  //       _savedSuggestions.add(pair);
  //     }
  //     // <-- Retrieving the value.
  //   }
  //   notifyListeners();
  // }

  // Future<void> updateLocalSave(Set<WordPair> saved) async {
  //   _localSave = saved;
  //   notifyListeners();
  // }

}

