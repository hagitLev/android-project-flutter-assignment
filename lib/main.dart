import 'package:english_words/english_words.dart'; // Add this line.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_me2/authentication.dart';
import 'package:hello_me2/MyApp.dart';
import 'package:provider/provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  //
  runApp(
    ChangeNotifierProvider<AuthRepository>(
      create: (_) => AuthRepository.instance() ,
      child: App(),
    ),
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
        return const Center(child: CircularProgressIndicator(color: Colors.purple,));
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Startup Name Generator',
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         // old colors were here:
//         // appBarTheme: const AppBarTheme(
//         //   backgroundColor: Colors.white,
//         //   foregroundColor: Colors.black,
//         // ),
//       ),
//       home: const RandomWords(),
//     );
//   }
// }
//
// class RandomWords extends StatefulWidget {
//   const RandomWords({Key? key}) : super(key: key);
//
//   @override
//   State<RandomWords> createState() => _RandomWordsState();
// }
//
// class _RandomWordsState extends State<RandomWords> {
//   final _suggestions = <WordPair>[]; // NEW
//   final _saved = <WordPair>{};
//   final _biggerFont = const TextStyle(fontSize: 18);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Add from here...
//       appBar: AppBar(
//         title: const Text('Startup Name Generator'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.star),
//             onPressed: _pushSaved,
//             tooltip: 'Saved Suggestions',
//           ),
//           IconButton(
//             icon: const Icon(Icons.login),
//             tooltip: 'Login',
//             onPressed: _pushLogin,
//           ),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }
//
//   void _pushSaved() {
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (context) {
//           final ConfirmDismissCallback? confirmDismiss;
//           final tiles = _saved.map(
//             (pair) {
//               return Dismissible(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ListTile(
//                     title: Text(
//                       pair.asPascalCase,
//                       style: _biggerFont,
//                     ),
//                   ),
//                 ),
//                 background: Container(
//                   color: Theme.of(context).primaryColor,
//                   child: Row(children: const [
//                     SizedBox(width: 10),
//                     Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                     ),
//                     SizedBox(width: 20),
//                     Text('Delete Suggestion',
//                         style: TextStyle(color: Colors.white, fontSize: 18)),
//                   ]),
//                 ),
//                 key: ValueKey<WordPair>(pair),
//                 // confirmDismiss: (DismissDirection dismissDirection) async {
//                 // final snackBar = SnackBar(
//                 //   content: const Text('Deletion is not implemented yet'),
//                 //   action: SnackBarAction(
//                 //     label: '',
//                 //     onPressed: () {
//                 //       // Some code to undo the change.
//                 //     },
//                 //   ),
//                 // );
//                 //
//                 // // Find the ScaffoldMessenger in the widget tree
//                 // // and use it to show a SnackBar.
//                 // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 //
//                 //   return false;
//                 // },
//                 confirmDismiss: (DismissDirection direction) async {
//                   var currPair = pair.asPascalCase;
//                   return await showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: const Text("Delete Suggestion"),
//                         content: Text(
//                             'Are you sure you want to delete $currPair from your saved suggestions?'),
//                         actions: <Widget>[
//                           FlatButton(
//                               onPressed: () => Navigator.of(context).pop(true),
//                               child: const Text("Yes",
//                                   style: TextStyle(color: Colors.white)),
//                               color: Theme.of(context).primaryColor),
//                           FlatButton(
//                               onPressed: () => Navigator.of(context).pop(false),
//                               child: const Text("No",
//                                   style: TextStyle(color: Colors.white)),
//                               color: Theme.of(context).primaryColor),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 onDismissed: (DismissDirection direction) {
//                   // add here code to handle deletion
//                 },
//               );
//             },
//           );
//           final divided = tiles.isNotEmpty
//               ? ListTile.divideTiles(
//                   context: context,
//                   tiles: tiles,
//                 ).toList()
//               : <Widget>[];
//
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Saved Suggestions'),
//             ),
//             body: ListView(children: divided),
//           );
//         },
//       ),
//     );
//   }
//
//   void _pushLogin() {
//     String? email;
//     String? password;
//     Navigator.of(context).push(MaterialPageRoute<void>(
//       builder: (context) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Login'),
//           ),
//           body: Center(
//               child: Column(
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
//                 child: Text(
//                     'Welcome to Startup NamesGenerator, please log in below'),
//               ),
//               Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: TextFormField(
//                     decoration: const InputDecoration(
//                       border: UnderlineInputBorder(),
//                       labelText: 'Email',
//                     ),
//                   )),
//               Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: TextFormField(
//                     decoration: const InputDecoration(
//                       border: UnderlineInputBorder(),
//                       labelText: 'Password',
//                     ),
//                   )),
//               ElevatedButton(
//                 onPressed: () {
//                   // final snackBar = SnackBar(
//                   //   content: const Text('Login is not implemented yet'),
//                   //   action: SnackBarAction(
//                   //     label: 'Undo',
//                   //     onPressed: () {
//                   //       // Some code to undo the change.
//                   //     },
//                   //   ),
//                   // );
//                   //
//                   // // Find the ScaffoldMessenger in the widget tree
//                   // // and use it to show a SnackBar.
//                   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//
//                   AuthRepository.instance()
//                       .signIn(email: email, password: password)
//                       .then((result) {
//                         print('****** This is the result:  $result');
//                     if (result == null) {
//                       Navigator.pushReplacement(context,
//                           MaterialPageRoute(builder: (context) => MyApp()));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                         content: Text(
//                           // result,
//                           'here',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ));
//                     }
//                   });
//                 },
//                 child: const Text("Log in"),
//                 style: ElevatedButton.styleFrom(
//                     fixedSize: const Size(320, 30),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(40.0),
//                     )),
//               )
//             ],
//           )),
//         );
//       },
//     ));
//   }
//
//   Widget _buildSuggestions() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       // The itemBuilder callback is called once per suggested
//       // word pairing, and places each suggestion into a ListTile
//       // row. For even rows, the function adds a ListTile row for
//       // the word pairing. For odd rows, the function adds a
//       // Divider widget to visually separate the entries. Note that
//       // the divider may be difficult to see on smaller devices.
//       itemBuilder: (context, i) {
//         // Add a one-pixel-high divider widget before each row
//         // in the ListView.
//         if (i.isOdd) {
//           return const Divider();
//         }
//
//         // The syntax "i ~/ 2" divides i by 2 and returns an
//         // integer result.
//         // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
//         // This calculates the actual number of word pairings
//         // in the ListView,minus the divider widgets.
//         final index = i ~/ 2;
//         // If you've reached the end of the available word
//         // pairings...
//         if (index >= _suggestions.length) {
//           // ...then generate 10 more and add them to the
//           // suggestions list.
//           _suggestions.addAll(generateWordPairs().take(10));
//         }
//         // generateWordPairs().take(10).toList();
//
//         return _buildRow(_suggestions[index]);
//       },
//     );
//   }
//
//   Widget _buildRow(WordPair pair) {
//     final alreadySaved = _saved.contains(pair);
//     return ListTile(
//       title: Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//       trailing: Icon(
//         // NEW from here...
//         alreadySaved ? Icons.star : Icons.star_border,
//         color: alreadySaved ? Theme.of(context).primaryColor : null,
//         semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
//       ),
//       onTap: () {
//         // NEW lines from here...
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//           } else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   }
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   Widget _buildForm(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           TextFormField(
//             decoration: const InputDecoration(
//               hintText: 'Enter your email',
//             ),
//             validator: (String? value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 // Validate will return true if the form is valid, or false if
//                 // the form is invalid.
//                 if (_formKey.currentState!.validate()) {
//                   // Process data.
//                 }
//               },
//               child: const Text('Submit'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
