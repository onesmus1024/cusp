import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Authenticate {
  Authenticate(
      {required this.userName,
      required this.phoneNumber,
      required this.email,
      required this.password,
      required this.isLoggingIn});
  String userName;
  String phoneNumber;
  String email;
  String password;
  bool isLoggingIn;
  // ignore: prefer_typing_uninitialized_variables
  var authenticateResult;

  Future<void> login(BuildContext context) async {
    try {
      authenticateResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString().replaceRange(e.toString().indexOf('['),
                    e.toString().indexOf(']') + 1, '')),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("try again"))
                ],
              ));
    }
  }

  Future<void> createNewUser(BuildContext context) async {
    try {
      authenticateResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(authenticateResult.user.uid)
          .set({
        'email': email,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString().replaceRange(e.toString().indexOf('['),
                    e.toString().indexOf(']') + 1, '')),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("try again"))
                ],
              ));
              
    }
  }

  Future<void> signUp(BuildContext context) async {
    if (isLoggingIn) {
      login(context);
    } else {
      createNewUser(context);
    }
  }
}
