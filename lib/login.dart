import 'package:flutter/material.dart';

// import 'package:flutter_firebase_auth/authentication.dart';
// import 'package:flutter_firebase_auth/MyApp.dart';
// import 'package:flutter_firebase_auth/signup.dart';
import 'package:hello_me2/authentication.dart';
import 'package:hello_me2/MyApp.dart';
import 'package:hello_me2/signUp.dart';

// class Login extends StatelessWidget {
//   String? email;
//   String? password;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Center(
//           child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
//             child:
//                 Text('Welcome to Startup NamesGenerator, please log in below'),
//           ),
// Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   border: UnderlineInputBorder(),
//                   labelText: 'Email',
//                 ),
//                 onSaved: (val) {
//                   email = val;
//                 },
//               )),
//           Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   border: UnderlineInputBorder(),
//                   labelText: 'Password',
//                 ),
//                 onSaved: (val) {
//                   password = val;
//                 },
//               )),
//           ElevatedButton(
//             onPressed: () {
//               // final snackBar = SnackBar(
//               //   content: const Text('Login is not implemented yet'),
//               //   action: SnackBarAction(
//               //     label: 'Undo',
//               //     onPressed: () {
//               //       // Some code to undo the change.
//               //     },
//               //   ),
//               // );
//               //
//               // // Find the ScaffoldMessenger in the widget tree
//               // // and use it to show a SnackBar.
//               // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//
//               AuthRepository.instance()
//                   .signIn(email: email!, password: password!)
//                   .then((result) {
//                 print('****** This is the result:  $result');
//                 if (result == null) {
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) =>const MyApp()));
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     content: Text(
//                       // result,
//                       'here',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ));
//                 }
//               });
//             },
//             child: const Text("Log in"),
//             style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(320, 30),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(40.0),
//                 )),
//           )
//         ],
//       )),
//     );
//   }
// //     return Scaffold(
// //       body: ListView(
// //         padding: EdgeInsets.all(8.0),
// //         children: <Widget>[
// //           SizedBox(height: 80),
// //           // logo
// //           Column(
// //             children: [
// //               FlutterLogo(
// //                 size: 55,
// //               ),
// //               SizedBox(height: 50),
// //               Text(
// //                 'Welcome back!',
// //                 style: TextStyle(fontSize: 24),
// //               ),
// //             ],
// //           ),
// //
// //           SizedBox(
// //             height: 50,
// //           ),
// //
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: LoginForm(),
// //           ),
// //
// //           SizedBox(height: 20),
// //
// //           Row(
// //             children: <Widget>[
// //               SizedBox(width: 30),
// //               Text('New here ? ',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
// //               GestureDetector(
// //                 onTap: () {
// //                   // Navigator.pushNamed(context, '/signup');
// //                   Navigator.push(context,
// //                       MaterialPageRoute(builder: (context) => MyApp()));
// //                       // MaterialPageRoute(builder: (context) => Signup()));
// //                 },
// //                 child: Text('Get Registered Now!!',
// //                     style: TextStyle(fontSize: 20, color: Colors.blue)),
// //               )
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //
// }

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoginForm(),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              const SizedBox(width: 30),
              const Text('New here ? ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, '/signup');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: const Text('Get Registered Now!!',
                    style: const TextStyle(fontSize: 20, color: Colors.blue)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  // bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('Welcome to Startup NamesGenerator, please log in below'),
          const SizedBox(
            height: 20,
          ),
          // email
          TextFormField(
            // initialValue: 'Input text',
            decoration: const InputDecoration(
              // prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email',
              // border: OutlineInputBorder(
              // borderRadius: BorderRadius.all(
              //   const Radius.circular(100.0),
              // ),
              // ),
            ),
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     return 'Please enter some text';
            //   }
            //   return null;
            // },
            onSaved: (val) {
              email = val;
            },
          ),
          const SizedBox(
            height: 20,
          ),

          // password
          TextFormField(
            // initialValue: 'Input text',
            decoration: const InputDecoration(
              labelText: 'Password',
              // prefixIcon: Icon(Icons.lock_outline),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.all(
              //     const Radius.circular(100.0),
              //   ),
              // ),
              // suffixIcon: GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       _obscureText = !_obscureText;
              //     });
              //   },
              //   child: Icon(
              //     _obscureText ? Icons.visibility_off : Icons.visibility,
              //   ),
              // ),
            ),
            // obscureText: _obscureText,
            onSaved: (val) {
              password = val;
            },
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     return 'Please enter some text';
            //   }
            //   return null;
            // },
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 30,
            width: 320,
            child: ElevatedButton(
              onPressed:
                  AuthRepository.instance().status == Status.Authenticating
                      ? null
                      : () {
                          // Respond to button press

                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            AuthRepository.instance()
                                .signIn(email: email!, password: password!)
                                .then((result) {
                              if (result) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp()));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    'There was an error logging into the app',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ));
                              }
                            });
                          }
                        },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                primary:
                    AuthRepository.instance().status == Status.Authenticating
                        ? Colors.white54
                        : Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Log in',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
