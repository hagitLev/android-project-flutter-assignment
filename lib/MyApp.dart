import 'package:english_words/english_words.dart'; // Add this line.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_me2/authentication.dart';
import 'package:hello_me2/login.dart';
import 'package:hello_me2/userFavorites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:hello_me2/defaultGrabbing.dart';
import 'package:hello_me2/profilePicture.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;
import 'dart:ui' as ui;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserFavorites>(builder: (context, userFavorites, child) {
      return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const RandomWords(),
      );
    });
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // NEW
  // var _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  var favorites = UserFavorites().favorites;

  @override
  Widget build(BuildContext context) {
    final snappingSheetController = SnappingSheetController();

    return ChangeNotifierProvider(
      create: (context) => ProfileSheet(),
      child: Consumer<UserFavorites>(builder: (context, userFavorites, child) {
        return Consumer<AuthRepository>(
            builder: (context, authRepository, child) {
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
                  return IconButton(
                      icon: authRepository.isAuthenticated
                          ? const Icon(Icons.exit_to_app)
                          : const Icon(Icons.login),
                      tooltip: 'Login',
                      onPressed: authRepository.isAuthenticated
                          ? () {
                              authRepository.signOut();
                              userFavorites.resetFavorites();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  'Successfully logged out',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ));
                            }
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            }
                      // _pushLogin,
                      );
                })
              ],
            ),
            body: !authRepository.isAuthenticated
                ? _buildSuggestions()
                : SnappingSheet(
                    controller: snappingSheetController,
                    lockOverflowDrag: true,
                    grabbingHeight: 50,
                    grabbing: DefaultGrabbing(
                        snappingSheetController: snappingSheetController),
                    child: Consumer<ProfileSheet>(
                        builder: (context, profileSheet, child) {
                      return !profileSheet.snappingSheetOpen
                          ? _buildSuggestions()
                          : Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                _buildSuggestions(),
                                BackdropFilter(
                                  filter: ui.ImageFilter.blur(
                                    sigmaX: profileSheet.snappingSheetOpen
                                        ? 3.0
                                        : 0.0,
                                    sigmaY: profileSheet.snappingSheetOpen
                                        ? 3.0
                                        : 0.0,
                                  ),
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                )
                              ],
                            );
                    }),
                    sheetBelow: SnappingSheetContent(
                        draggable: false,
                        child: Container(
                            color: Colors.white,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<ProfilePicture>(builder:
                                      (context, userProfilePic, child) {
                                    return Container(
                                      margin: EdgeInsets.all(20),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(userProfilePic
                                                    .linkToProfilePic ??
                                                'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                        // ,
                                        ;
                                  }),
                                  Consumer<ProfilePicture>(builder:
                                      (context, userProfilePic, child) {
                                    return Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                child: Text(
                                              '${authRepository.user?.email}',
                                              // softWrap: true,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )),
                                            Flexible(
                                                child: SizedBox(
                                                    width: 150.0,
                                                    child: TextButton(
                                                      onPressed: () async {
                                                        FilePickerResult? res =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                          type: FileType.custom,
                                                          allowedExtensions: [
                                                            'jpg',
                                                            'png',
                                                            'jpeg',
                                                            'svg',
                                                            'webp',
                                                            'apng',
                                                            'avif',
                                                          ],
                                                        );
                                                        if (res != null) {
                                                          String fileName = res
                                                              .files.first.name;
                                                          io.File file =
                                                              io.File(res
                                                                  .files
                                                                  .single
                                                                  .path!);
                                                          try {
                                                            await FirebaseStorage
                                                                .instance
                                                                .ref(
                                                                    'users_profile_pictures/$fileName')
                                                                .putFile(file);
                                                            await FirebaseStorage
                                                                .instance
                                                                .ref(
                                                                    'users_profile_pictures/$fileName')
                                                                .getDownloadURL()
                                                                .then((value) =>
                                                                    userProfilePic
                                                                        .addProfilePicture(
                                                                            authRepository,
                                                                            value))
                                                                .then((value) =>
                                                                    userProfilePic
                                                                        .getProfilePicture(
                                                                            authRepository));
                                                          } catch (e) {
                                                            print(
                                                                "There was a problem with getting the picture");
                                                          }
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Text(
                                                              'No image selected',
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          ));
                                                        }
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        primary: Colors.white,
                                                        backgroundColor:
                                                            Colors.blue,
                                                      ),
                                                      child: const Text(
                                                          'Change avatar'),
                                                    ))),
                                          ],
                                        ),
                                      ),
                                    )
                                        // ,
                                        ;
                                  }),
                                ]))),
                  ),
          );
        });
      }),
    );
  }

  void _pushSaved(UserFavorites userFavorites) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final ConfirmDismissCallback? confirmDismiss;
          // final tiles = _saved.map(
          final tiles = userFavorites.favorites.map(
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
                  color: Theme.of(context).primaryColor,
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
                                onPressed: () => {
                                      Navigator.of(context).pop(true),
                                      // removeSuggestion(pair.toLowerCase().toString()),
                                      userFavorites.removeFromFavorites(
                                          pair, authRepository)
                                    },
                                child: const Text("Yes",
                                    style: TextStyle(color: Colors.white)),
                                color: Theme.of(context).primaryColor);
                          }),
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("No",
                                  style: TextStyle(color: Colors.white)),
                              color: Theme.of(context).primaryColor),
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
    return Consumer<UserFavorites>(builder: (context, userFavorites, child) {
      // final alreadySaved = UserFavorites().favorites.contains(pair);
      final alreadySaved = userFavorites.favorites.contains(pair);
      var splitPair = pair.join(' ').split(' ');
      return Consumer<AuthRepository>(
          builder: (context, authRepository, child) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: Icon(
            // NEW from here...
            alreadySaved ? Icons.star : Icons.star_border,
            color: alreadySaved ? Theme.of(context).primaryColor : null,
            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                userFavorites.removeFromFavorites(pair, authRepository);
                // _saved.remove(pair);
              } else {
                // _saved.add(pair);
                userFavorites.addToFavorites(pair, authRepository);
              }
            });
          },
        );
      });
    });
  }
}
