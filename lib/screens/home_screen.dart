import 'package:chat_app_flutter/imageupload/image_upload.dart';
import 'package:chat_app_flutter/imageupload/show_iamges.dart';
import 'package:chat_app_flutter/models/user.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${loggedInUser.firstName} ${loggedInUser.secondName}',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${loggedInUser.email}',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => ImageUpload(
                            userId: loggedInUser.uid,
                          )),
                    ),
                  );
                },
                child: Text('Upload Image'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => ShowUploads(
                            userId: loggedInUser.uid,
                          )),
                    ),
                  );
                },
                child: Text('Show Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logOut() async {
    final logOut = FirebaseAuth.instance;
    await logOut.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((context) => LoginScreen()),
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              onPressed: () {
                logOut();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
