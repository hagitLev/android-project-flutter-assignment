import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_me2/authentication.dart';

class ProfilePicture extends ChangeNotifier {
  String? _linkToProfilePic;
  bool _loading;

  ProfilePicture() : _linkToProfilePic = null, _loading = false;

  String? get linkToProfilePic => _linkToProfilePic;
  bool get loading => _loading;

  void updateAnonymousPicture() {
    _linkToProfilePic = null;
    notifyListeners();
  }

  Future<void> addProfilePicture(
      AuthRepository authRepository, String profileURL) async {
    var userCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(authRepository.user?.email);
    try {
      _loading = true;
      notifyListeners();
      await userCollection.set({'ProfilePicture': profileURL});
      notifyListeners();
    } catch (e) {
      print("couldn't upload profile picture");
    }
  }

  Future<void> getProfilePicture(AuthRepository authRepository) async {
    var userCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(authRepository.user?.email);
    try {

      var querySnapshot = await userCollection.get();
      Map<String, dynamic>? data = querySnapshot.data();
      _loading = false;
      _linkToProfilePic = data?["ProfilePicture"];
      notifyListeners();
    } catch (e) {
      _loading = false;
      _linkToProfilePic = null;
      notifyListeners();
    }
  }
//   }
// }
}
