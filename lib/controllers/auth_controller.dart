import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user.dart';
import '../screens/home_screen.dart';

class AuthenticationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(
      String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> sigIn(GlobalKey<FormState> formKey, String email,
      String password, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Fluttertoast.showToast(msg: 'Login Successful');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }).catchError((e) => Fluttertoast.showToast(msg: e!.message));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> postDetailToFireStore(String email, String password,
      String firstName, String secondName, BuildContext context) async {
    //calling our firesotre
    //calling our user model
    //sending these values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    //writing all the value
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstName;
    userModel.secondName = secondName;

    await firebaseFirestore
        .collection('user')
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: 'Account created successfully');
  }
}
