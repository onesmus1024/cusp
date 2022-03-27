import 'package:cusp/screens/home.dart';
import 'package:cusp/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  static const routName = '/sign_in';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoggingIn = true;
  bool isSigningIn = false;
  String userName = '';
  String phoneNumber = '';
  String email = '';
  String password = '';



  final _formKey = GlobalKey<FormState>();

  
  void _setLogginIn() {
    setState(() {
      isLoggingIn = !isLoggingIn;
    });
  }

  Future<bool> _handleForm(BuildContext context) async {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        isSigningIn = true;
      });
      await Future.wait([
        Authenticate(
              userName: userName,
              phoneNumber: phoneNumber,
              email: email,
              password: password,
              isLoggingIn: isLoggingIn)
          .signUp(context)
      ]);
      setState(() {
        isSigningIn = false;
      });
      
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Card(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!isLoggingIn)
                  TextFormField(
                    key: const ValueKey("username"),
                    decoration: const InputDecoration(label: Text("username")),
                    onSaved: (value) {
                      userName = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter a valid username";
                      }
                      return null;
                    },
                  ),
                if (!isLoggingIn)
                  TextFormField(
                    key: const ValueKey("phoneNumber"),
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(label: Text("phone number")),
                    onSaved: (value) {
                      phoneNumber = value!.trim();
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.trim().length != 10) {
                        return "enter a valid phone";
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  key: const ValueKey("email"),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(label: Text("email")),
                  onSaved: (value) {
                    email = value!.trim();
                  },
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return "enter a valid email";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: const ValueKey("password"),
                  obscureText: true,
                  decoration: const InputDecoration(label: Text("password")),
                  onSaved: (value) {
                    password = value!.trim();
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return "enter a valid password";
                    }
                    return null;
                  },
                ),
                if (!isLoggingIn)
                  TextFormField(
                    key: const ValueKey("confirmPassword"),
                    obscureText: true,
                    decoration:
                        const InputDecoration(label: Text("confirm password")),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "password did not match";
                      }
                      return null;
                    },
                  ),
                isSigningIn
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (await _handleForm(context)) {
                            if (FirebaseAuth.instance.currentUser != null) {
                              Navigator.of(context)
                                  .pushReplacementNamed(Home.routName);
                            }
                          }
                        },
                        child: isLoggingIn
                            ? const Text("Login")
                            : const Text("sign up")),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: _setLogginIn,
                    child: isLoggingIn
                        ? const Text("sign in instead?")
                        : const Text("Login instead?"))
              ],
            )),
      ))),
    ));
  }
}
