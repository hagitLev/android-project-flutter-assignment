import 'package:flutter/material.dart';
import 'package:hello_me2/authentication.dart';
import 'package:hello_me2/MyApp.dart';
import 'package:hello_me2/profilePicture.dart';
import 'package:hello_me2/userFavorites.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
        children: const <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: LoginForm(),
          ),
          SizedBox(height: 20),
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
  String? currPassword;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(builder: (context, authRepository, child) {
      return Consumer<UserFavorites>(builder: (context, userFavorites, child) {
        return Consumer<ProfilePicture>(
            builder: (context, userProfilePic, child)
        {
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
                  ),
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
                  ),
                  obscureText: _obscureText,
                  onSaved: (val) {
                    password = val;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 30,
                  width: 320,
                  child:
                  ElevatedButton(
                    onPressed: authRepository.isAuthenticating
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        authRepository
                            .signIn(email: email!, password: password!)
                            .then((result) {
                          if (result) {
                            // userFavorites.setNewUser(authRepository);
                            userFavorites.updateToFavorites(authRepository);
                            userProfilePic.getProfilePicture(authRepository);
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
                      Theme
                          .of(context)
                          .primaryColor,
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
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 30,
                  width: 320,
                  child: Consumer<AuthRepository>(
                      builder: (context1, authRepository, child) {
                        return Consumer<UserFavorites>(
                            builder: (context2, userFavorites, child) {
                              return Consumer<ProfilePicture>(
                                  builder: (context, userProfilePic, child) {
                                    return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                40.0),
                                          ),
                                          primary: Colors.blue,
                                        ),
                                        child: const Text(
                                          'New User? Click to sign up',
                                          // isAuthenticating.toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        onPressed: () {
                                          _formKey.currentState!.save();
                                          showMaterialModalBottomSheet(
                                              expand: false,
                                              context: context,
                                              // backgroundColor: Colors.transparent,
                                              builder: (context) =>
                                                  ShowModal(
                                                      password: password,
                                                      email: email));
                                        }
                                    );
                                  });
                            });
                      }),
                ),
              ],
            ),
          );
        });
      });
    });
  }
}


class ShowModal extends StatefulWidget {
  final password;
  final email;

  const ShowModal({Key? key, required this.password, required this.email})
      : super(key: key);

  @override
  _ShowModalState createState() => _ShowModalState(password, email);
}

class _ShowModalState extends State<ShowModal> {
  final confirmPassword = TextEditingController();
  final password;
  final email;

  _ShowModalState(this.password, this.email);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child:
          Consumer<AuthRepository>(builder: (context1, authRepository, child) {
        return SafeArea(
            top: false,
            child:
                Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(20),
                            // margin: const EdgeInsets.only(top: 20),
                            child: const Text(
                              'Please confirm your password below:',
                              style: TextStyle(
                                  // color: Colors.black,
                                  // fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 20),
                            child: Theme(
                              data: Theme.of(context),
                              child: Consumer<ConfirmPasswordBtn>(
                                  builder: (context0, confirmButton, child) {
                                return Consumer<UserFavorites>(
                                    builder: (context2, userFavorites, child) {
                                  return Consumer<ProfilePicture>(builder:
                                      (context, userProfilePic, child) {
                                    return TextFormField(
                                      decoration: const InputDecoration(
                                        // border: OutlineInputBorder(),
                                        labelText: 'Password',
                                      ),
                                      obscureText: true,
                                      controller: confirmPassword,
                                      validator: (value) {
                                        print("VALUE IS: $value");
                                        print("PASSWORD IS: $password");
                                        if (confirmButton.isConfirm &&
                                            value == password) {
                                          authRepository
                                              .signUp(
                                                  email: email,
                                                  password: password)
                                              .then((value) {
                                            if (value == null) {
                                             Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                  'Error occured, please try again',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ));
                                            } else {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              userFavorites
                                                  .getData(authRepository)
                                                  .then((value) {
                                                userFavorites.updateToFavorites(
                                                    authRepository);
                                              }).then((value) {
                                                userProfilePic
                                                    .updateAnonymousPicture();
                                              });
                                              confirmButton.reset();
                                            }
                                            return null;
                                          });
                                        } else {
                                          setState(() {
                                            confirmButton.reset();
                                          });
                                          return 'Passwords must match';
                                        }
                                      },
                                    );
                                  });
                                });
                                // });
                              }),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 20),
                            child: Consumer<ConfirmPasswordBtn>(
                                builder: (context0, confirmButton, child) {
                              return Consumer<AuthRepository>(
                                  builder: (context1, authRepository, child) {
                                return Consumer<UserFavorites>(
                                    builder: (context2, userFavorites, child) {
                                  return Consumer<ProfilePicture>(builder:
                                      (context3, userProfilePic, child) {
                                    return TextButton(
                                        onPressed: () {
                                          confirmButton.clickConfirm();
                                          _formKey.currentState!.validate();
                                        },
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.blue,
                                            fixedSize: const Size.fromWidth(80)),
                                        child: const Text('Confirm'));
                                  });
                                });
                              });
                            }),
                          )
                        ],
                      ),
                    )));
      }),
    );
  }
}

class ConfirmPasswordBtn extends ChangeNotifier {
  bool _isConfirm;

  ConfirmPasswordBtn() : _isConfirm = false;

  bool get isConfirm => _isConfirm;

  void clickConfirm() {
    _isConfirm = true;
    notifyListeners();
  }

  void reset() {
    _isConfirm = false;
    notifyListeners();
  }
}