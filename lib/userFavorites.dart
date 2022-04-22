import 'package:english_words/english_words.dart'; // Add this line.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_me2/authentication.dart';
import 'package:hello_me2/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class UserFavorites extends ChangeNotifier{
  var _favories ;

  UserFavorites(): _favories = <WordPair> {};
  Set<WordPair> get favorites => _favories;

  void addToFavorites(WordPair pair, AuthRepository authRepository){
    _favories.add(pair);
    if (authRepository.isAuthenticated) {
      var splitPair = pair.join(' ').split(' ');
      addSuggestion(splitPair, authRepository);
      getData(authRepository);
      // print('from add: $_favories');
    }
    notifyListeners();
  }

  void removeFromFavorites(WordPair pair, AuthRepository authRepository){
    _favories.remove(pair);
    if (authRepository.isAuthenticated) {
      removeSuggestion(pair, authRepository);
      getData(authRepository);
    }
    notifyListeners();
  }

  void resetFavorites(){
    _favories.clear();
    print('favorites is now: $_favories');
    notifyListeners();
  }

// Create a CollectionReference called users that references the firestore collection
//   CollectionReference favorites = FirebaseFirestore.instance.collection('saved');
//   var favoritesCollection = FirebaseFirestore.instance.collection('users').doc(AuthRepository.instance().user?.email).collection('saved');
  Future<void> addSuggestion(splitPair, AuthRepository authRepository) {
    var favoritesCollection = FirebaseFirestore.instance.collection('users').doc(authRepository.user?.email).collection('saved');
    // Call the user's CollectionReference to add a new pair
    return favoritesCollection.doc(splitPair[0]+splitPair[1])
        .set({
      'first': splitPair[0],
      'second': splitPair[1],
      'user': authRepository
          .user
          ?.email
          .toString(),
      'created': Timestamp.now(),
    })
        .then((value) => print("User suggestion was Added"))
    // .then((value) => print('_currentData is : $_currentData'))
        .catchError(
              (error) => print("Failed to add user's suggestion: $error"));
    }

  Future<void> removeSuggestion(pair, AuthRepository authRepository) {
    var favoritesCollection = FirebaseFirestore.instance.collection('users').doc(authRepository.user?.email).collection('saved');
    // Call the user's CollectionReference to remove pair
    return favoritesCollection.doc(pair.toString())
        .delete()
        .then((value) => print("User suggestion was removed"))
    // .then((value) => print('_currentData is : $_currentData'))
        .catchError(
            (error) => print("Failed to remove user's suggestion: $error"));
  }

  Future<void> setNewUser(AuthRepository authRepository) async {
      var favoritesCollection = FirebaseFirestore.instance.collection('users').doc(authRepository.user?.email).collection('saved');
      // var querySnapshot = await favoritesCollection.get();
      print("User was added");

  }

  Future<void> updateToFavorites(AuthRepository authRepository) async {
    var favoritesCollection = FirebaseFirestore.instance.collection('users').doc(authRepository.user?.email).collection('saved');
    // Call the user's CollectionReference to add a new pair
    for (var pair in favorites) {
      var splitPair = pair.join(' ').split(' ');
      favoritesCollection.doc(splitPair[0]+splitPair[1])
          .set({
        'first': splitPair[0],
        'second': splitPair[1],
        'user': authRepository
            .user
            ?.email
            .toString(),
        'created': Timestamp.now(),
      })
          .then((value) => print("User suggestion was Added"))
      // .then((value) => print('_currentData is : $_currentData'))
          .catchError(
              (error) => print("Failed to add user's suggestion: $error"));
    };
  }


  Future<void> getData(AuthRepository authRepository) async {
    var favoritesCollection = FirebaseFirestore.instance.collection('users').doc(authRepository.user?.email).collection('saved');
    // var collection = FirebaseFirestore.instance.collection('users').doc(AuthRepository.instance().user?.email).collection('saved');
    var querySnapshot = await favoritesCollection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      final first = data['first'];
      final second = data['second'];
      final pair = WordPair(first, second);
      // print(pair);
      _favories.add(pair);
    }
    notifyListeners();
  }

}