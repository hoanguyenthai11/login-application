import 'package:chat_app_flutter/controllers/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/home_screen.dart';
import '../screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //
  bool _isObscure = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  //
  final AuthenticationController _authentication = AuthenticationController();

  void sigIn() async {
    try {
      await _authentication.sigIn(
          _formKey, _emailController.text, _passwordController.text, context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //email filed
    final emailField = TextFormField(
      autofocus: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@') || !value.endsWith('.com')) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onSaved: (value) {
        _emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          15,
        ),
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final passwordField = TextFormField(
      obscureText: _isObscure,
      autofocus: false,
      controller: _passwordController,
      validator: (value) {
        RegExp regExp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return 'Password is required fo login';
        }
        if (!regExp.hasMatch(value)) {
          return ('Please enter valid Password (Min 6 character)');
        }
        return null;
      },
      onSaved: (value) {
        _passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        suffixIcon: IconButton(
          icon: _isObscure
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          15,
        ),
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          15,
        ),
        minWidth: double.infinity,
        onPressed: () {
          sigIn();
        },
        child: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset(
                      'assets/images/dash_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text(
                    'HELLO AGAIN!',
                    style: TextStyle(fontFamily: 'BebasNeue', fontSize: 52),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Welcome back, you\'ve ben missed!',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  emailField,
                  const SizedBox(
                    height: 25,
                  ),
                  passwordField,
                  const SizedBox(
                    height: 35,
                  ),
                  loginButton,
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? '),
                      GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: ((context) => RegistrationScreen()),
                          //   ),
                          // );
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          )
                              .then((value) {
                            _emailController.clear();
                            _passwordController.clear();
                          });
                        },
                        child: const Text(
                          'Signup',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
