import 'package:flutter/material.dart';

// import 'package:flutter_firebase_auth/authentication.dart';
// import 'package:flutter_firebase_auth/MyApp.dart';
// import 'package:flutter_firebase_auth/signup.dart';
import 'package:hello_me2/authentication.dart';
import 'package:hello_me2/MyApp.dart';
import 'package:hello_me2/signUp.dart';
import 'package:hello_me2/userFavorites.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: LoginForm(),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              const SizedBox(width: 30),
              const Text('New here ? ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, '/signup');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: const Text('Get Registered Now!!',
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  // bool loading = AuthRepository.instance().isAuthenticating;

  // bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(builder: (context, authRepository, child) {
      var isAuthenticating = authRepository.isAuthenticating;
      print('###### status is: ${authRepository.status} ############');
      return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text(
                'Welcome to Startup NamesGenerator, please log in below'),
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
              child:Consumer<UserFavorites>(
    builder: (context, userFavorites, child) {
      return ElevatedButton(
        onPressed: authRepository.isAuthenticating? null : () {
          // Respond to button press

          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            authRepository
                .signIn(email: email!, password: password!)
                .then((result) {
              if (result) {
                // userFavorites.setNewUser(authRepository);
                userFavorites.updateToFavorites(authRepository);
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
          // authRepository.status == Status.Authenticating
          //     ? Colors.white54
          //     :
          Theme.of(context).primaryColor,
        ),
        child: authRepository.isAuthenticating
            ? const CircularProgressIndicator(
          value: 0.8,
          color: Colors.white54,
        )
            : const Text(
          'Log in',
          // isAuthenticating.toString(),
          style: TextStyle(fontSize: 16),
        ),
      );
    }),
            ),
          ],
        ),
      );
    });
  }
}
