import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/auth_controller.dart';
import '../models/user.dart';
import '../screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel userModel = UserModel();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  logOut() async {
    final AuthenticationController auth = AuthenticationController();
    await auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((context) => const LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome Back',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BebasNeue'),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/images/dash_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'User name:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${userModel.firstName} ${userModel.secondName}',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Email:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${userModel.email}',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
