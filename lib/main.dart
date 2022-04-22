import 'package:english_words/english_words.dart'; // Add this line.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_me2/authentication.dart';
import 'package:hello_me2/MyApp.dart';
import 'package:hello_me2/login.dart';
import 'package:hello_me2/profilePicture.dart';
import 'package:hello_me2/userFavorites.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthRepository.instance()),
      ChangeNotifierProvider(create: (context) => UserFavorites()),
      ChangeNotifierProvider(create: (context) => ProfilePicture()),
      ChangeNotifierProvider(create: (context) => ConfirmPasswordBtn()),
    ],
      child: App(),
    )
    ,
  );
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const MaterialApp(
            title: 'Flutter auth Demo',
            home: MyApp(),
          );
        }
        return const Center(child:CircularProgressIndicator(
          value: 0.8,
        ),
        );
      },
    );
  }
}
