import 'package:english_words/english_words.dart'; // Add this line.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_me2/authentication.dart';
import 'package:hello_me2/login.dart';
import 'package:hello_me2/userFavorites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserFavorites>(
        builder: (context, userFavorites, child)
    {
      return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          // old colors were here:
          // appBarTheme: const AppBarTheme(
          //   backgroundColor: Colors.white,
          //   foregroundColor: Colors.black,
          // ),
        ),
        home: const RandomWords(),
      );
    });
  }
}

// class SavedSuggestion {
//   SavedSuggestion({required this.pair, required this.user, required this.created});
//
//   SavedSuggestion.fromJson(Map<String, Object?> json)
//       : this(
//     pair: json['pair']! as String,
//     user: json['user']! as String,
//     created: json['created']! as Timestamp,
//   );
//
//   final String pair;
//   final String user;
//   final Timestamp created;
//
//   Map<String, Object?> toJson() {
//     return {
//       'pair': pair,
//       'user': user,
//       'created': created
//     };
//   }
// }

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // NEW
  // var _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  // var _isAuth = AuthRepository.instance().isAuthenticated;
  final _fireStore = FirebaseFirestore.instance;
  var favorites = UserFavorites().favorites;


  @override
  Widget build(BuildContext context) {
    // Future<void> getData() async {
    //   var collection = _fireStore.collection('users').doc(AuthRepository.instance().user?.email).collection('saved');
    //   var querySnapshot = await collection.get();
    //   for (var doc in querySnapshot.docs) {
    //     Map<String, dynamic> data = doc.data();
    //     // if (data['user'] == AuthRepository
    //     //     .instance()
    //     //     .user
    //     //     ?.email) {
    //     final first = data['first'];
    //     final second = data['second'];
    //     final pair = WordPair(first, second);
    //     _saved.add(pair);
    //     // }
    //
    //   }
    // }


    // if (_isAuth) {
    //   // getData();
    // print('this is saved before: $_saved');
    // UserFavorites().getData();
    // // _saved = UserFavorites().favorites;
    // print('this is saved after: $favorites');
    //
    // }
    // print('This is local save: $_localSave');

    return Consumer<UserFavorites>(
        builder: (context, userFavorites, child) {
          return Scaffold(
            // Add from here...
            appBar: AppBar(
              title: const Text('Startup Name Generator'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.star),
                  onPressed: () => _pushSaved(userFavorites),
                  tooltip: 'Saved Suggestions',
                ),
                Consumer<AuthRepository>(
                    builder: (context, authRepository, child) {
                      if (authRepository.isAuthenticated) {
                        userFavorites.getData(authRepository);
                      }
                      return
                        IconButton(
                            icon: authRepository.isAuthenticated
                                ? const Icon(Icons.exit_to_app)
                                : const Icon(Icons.login),
                            tooltip: 'Login',
                            onPressed: authRepository.isAuthenticated ? () {
                              // _isAuth
                              //     ? () {
                              //   setState(() {
                              //     _isAuth = !_isAuth;
                              //   });
                              authRepository.signOut();
                              userFavorites.resetFavorites();
                              // UserFavorites().resetFavorites();

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Successfully logged out',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ));
                            }
                                : () {
                              // AuthRepository.instance().updateLocalSave(_saved);
                              // print(_localSave);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (
                                      context) => const Login()));
                            }
                          // _pushLogin,
                        );
                    })
              ],
            ),
            body: _buildSuggestions(),
          );
        }
    );
  }

  // // Create a CollectionReference called users that references the firestore collection
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  // CollectionReference saved = FirebaseFirestore.instance.collection('users').doc(AuthRepository.instance().user?.email).collection('saved');
  // Future<void> addSuggestion(splitPair) {
  //   // Call the user's CollectionReference to add a new pair
  //   return saved.doc(splitPair[0]+splitPair[1])
  //       .set({
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
  //
  //
  // Future<void> removeSuggestion(pair) {
  //   setState(() {_saved.remove(pair);});
  //   // Call the user's CollectionReference to remove pair
  //   return saved.doc(pair)
  //       .delete()
  //       .then((value) => print("User suggestion was removed"))
  //   // .then((value) => print('_currentData is : $_currentData'))
  //       .catchError(
  //           (error) => print("Failed to remove user's suggestion: $error"));
  // }


  void _pushSaved(UserFavorites userFavorites) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final ConfirmDismissCallback? confirmDismiss;
          // final tiles = _saved.map(
            final tiles =userFavorites.favorites.map(
                (pair) {
              return Dismissible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  ),
                ),
                background: Container(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  child: Row(children: const [
                    SizedBox(width: 10),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Text('Delete Suggestion',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ]),
                ),
                key: ValueKey<WordPair>(pair),
                confirmDismiss: (DismissDirection direction) async {
                  var currPair = pair.asPascalCase;
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Suggestion"),
                        content: Text(
                            'Are you sure you want to delete $currPair from your saved suggestions?'),
                        actions: <Widget>[
                          Consumer<AuthRepository>(
                              builder: (context, authRepository, child) {
                                return FlatButton(
                                    onPressed: () =>
                                    {
                                      Navigator.of(context).pop(true),
                                      // removeSuggestion(pair.toLowerCase().toString()),
                                      userFavorites.removeFromFavorites(
                                          pair, authRepository)
                                    },
                                    child: const Text("Yes",
                                        style: TextStyle(color: Colors.white)),
                                    color: Theme
                                        .of(context)
                                        .primaryColor);
                              }),
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("No",
                                  style: TextStyle(color: Colors.white)),
                              color: Theme
                                  .of(context)
                                  .primaryColor),

                        ],

                      );
                    },
                  );
                },
                onDismissed: (DismissDirection direction) {
                  // add here code to handle deletion
                },
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  // void _pushLogin() {
  //   String? email;
  //   String? password;
  //   Navigator.of(context).push(MaterialPageRoute<void>(
  //     builder: (context) {
  //       return Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Login'),
  //         ),
  //         body: Center(
  //             child: Column(
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
  //               child: Text(
  //                   'Welcome to Startup NamesGenerator, please log in below'),
  //             ),
  //             Padding(
  //                 padding: const EdgeInsets.all(20.0),
  //                 child: TextFormField(
  //                   decoration: const InputDecoration(
  //                     border: UnderlineInputBorder(),
  //                     labelText: 'Email',
  //                   ),
  //                 )),
  //             Padding(
  //                 padding: const EdgeInsets.all(20.0),
  //                 child: TextFormField(
  //                   decoration: const InputDecoration(
  //                     border: UnderlineInputBorder(),
  //                     labelText: 'Password',
  //                   ),
  //                 )),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // final snackBar = SnackBar(
  //                 //   content: const Text('Login is not implemented yet'),
  //                 //   action: SnackBarAction(
  //                 //     label: 'Undo',
  //                 //     onPressed: () {
  //                 //       // Some code to undo the change.
  //                 //     },
  //                 //   ),
  //                 // );
  //                 //
  //                 // // Find the ScaffoldMessenger in the widget tree
  //                 // // and use it to show a SnackBar.
  //                 // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //
  //                 // AuthRepository.instance()
  //                 //     .signIn(email: email, password: password)
  //                 //     .then((result) {
  //                 //   print('****** This is the result:  $result');
  //                 //   if (result == null) {
  //                 //     Navigator.pushReplacement(context,
  //                 //         MaterialPageRoute(builder: (context) => MyApp()));
  //                 //   } else {
  //                 //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //                 //       content: Text(
  //                 //         // result,
  //                 //         'here',
  //                 //         style: TextStyle(fontSize: 16),
  //                 //       ),
  //                 //     ));
  //                 //   }
  //                 // });
  //               },
  //               child: const Text("Log in"),
  //               style: ElevatedButton.styleFrom(
  //                   fixedSize: const Size(320, 30),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(40.0),
  //                   )),
  //             )
  //           ],
  //         )),
  //       );
  //     },
  //   ));
  // }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // The itemBuilder callback is called once per suggested
      // word pairing, and places each suggestion into a ListTile
      // row. For even rows, the function adds a ListTile row for
      // the word pairing. For odd rows, the function adds a
      // Divider widget to visually separate the entries. Note that
      // the divider may be difficult to see on smaller devices.
      itemBuilder: (context, i) {
        // Add a one-pixel-high divider widget before each row
        // in the ListView.
        if (i.isOdd) {
          return const Divider();
        }

        // The syntax "i ~/ 2" divides i by 2 and returns an
        // integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings
        // in the ListView,minus the divider widgets.
        final index = i ~/ 2;
        // If you've reached the end of the available word
        // pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the
          // suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        // generateWordPairs().take(10).toList();

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    // final alreadySaved = _saved.contains(pair);
    return Consumer<UserFavorites>(
        builder: (context, userFavorites, child) {
          // final alreadySaved = UserFavorites().favorites.contains(pair);
          final alreadySaved = userFavorites.favorites.contains(pair);
          var splitPair = pair.join(' ').split(' ');
          return Consumer<AuthRepository>(
              builder: (context, authRepository, child)
          {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
              trailing: Icon(
                // NEW from here...
                alreadySaved ? Icons.star : Icons.star_border,
                color: alreadySaved ? Theme
                    .of(context)
                    .primaryColor : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
              onTap: () {
                setState(() {
                  if (alreadySaved) {
                    userFavorites.removeFromFavorites(pair, authRepository);
                    // _saved.remove(pair);
                    // _isAuth ? userFavorites.removeFromFavorites(pair, authRepository) : null;
                    // // UserFavorites().getData();
                  } else {
                    // _saved.add(pair);
                    userFavorites.addToFavorites(pair, authRepository);
                    // if (_isAuth) {
                    //   userFavorites.addToFavorites(pair, authRepository);
                    //   print('this is current favorites: ${userFavorites.favorites}');
                    //   // UserFavorites().getData();
                    //   // _saved = UserFavorites().favorites;
                    //   // addSuggestion(splitPair);
                    // }
                  }

                  // _saved = _isAuth? UserFavorites().favorites: _saved;
                });
              },
            );
          });
        });

    // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // Widget _buildForm(BuildContext context) {
    //   return Form(
    //     key: _formKey,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         TextFormField(
    //           decoration: const InputDecoration(
    //             hintText: 'Enter your email',
    //           ),
    //           validator: (String? value) {
    //             if (value == null || value.isEmpty) {
    //               return 'Please enter some text';
    //             }
    //             return null;
    //           },
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 16.0),
    //           child: ElevatedButton(
    //             onPressed: () {
    //               // Validate will return true if the form is valid, or false if
    //               // the form is invalid.
    //               if (_formKey.currentState!.validate()) {
    //                 // Process data.
    //               }
    //             },
    //             child: const Text('Submit'),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

  }
}
