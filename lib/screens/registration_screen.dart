import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../screens/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final _firstNameEditingController = TextEditingController();
  final _secondNameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _confirmPasswordEditingController = TextEditingController();

  //
  bool _isObscure = true;

  final _auth = FirebaseAuth.instance;
  //
  bool _isLoading = false;
  void signUp() async {
    setState(() {
      _isLoading = true;
    });
    AuthenticationController _auth = AuthenticationController();
    var sigUpUser = await _auth
        .signUp(_formKey, _emailEditingController.text,
            _passwordEditingController.text)
        .then((value) {
      _auth.postDetailToFireStore(
          _emailEditingController.text,
          _passwordEditingController.text,
          _firstNameEditingController.text,
          _secondNameEditingController.text,
          context);
      setState(() {
        _isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: _firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regExp = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ('First name cannot be Empty');
        }
        if (!regExp.hasMatch(value)) {
          return ('Enter valid name (Min 3characters)');
        }
        return null;
      },
      onSaved: (value) {
        _firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          15,
        ),
        hintText: 'First Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final secondNameField = TextFormField(
      autofocus: false,
      controller: _secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ('Second name cannot be Empty');
        }
        return null;
      },
      onSaved: (value) {
        _secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          15,
        ),
        hintText: 'Second Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: _emailEditingController,
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
        _emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
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
      controller: _passwordEditingController,
      validator: (value) {
        RegExp regExp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return 'Password is required fo signup';
        }
        if (!regExp.hasMatch(value)) {
          return ('Please enter valid Password (Min 6 character)');
        }
        return null;
      },
      onSaved: (value) {
        _passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          15,
        ),
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
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final confirmPasswordField = TextFormField(
      obscureText: _isObscure,
      autofocus: false,
      controller: _confirmPasswordEditingController,
      validator: ((value) {
        if (_confirmPasswordEditingController.text.length > 6 &&
            value != _passwordEditingController.text) {
          return 'Password dont match';
        }
        return null;
      }),
      onSaved: (value) {
        _confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          15,
        ),
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
        hintText: 'Confirm Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final signupButton = Material(
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
          signUp();
        },
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text(
                'Signup',
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
                    height: 150,
                    child: Image.asset(
                      'assets/images/dash_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  firstNameField,
                  const SizedBox(
                    height: 20,
                  ),
                  secondNameField,
                  const SizedBox(
                    height: 20,
                  ),
                  emailField,
                  const SizedBox(
                    height: 20,
                  ),
                  passwordField,
                  const SizedBox(
                    height: 20,
                  ),
                  confirmPasswordField,
                  const SizedBox(
                    height: 35,
                  ),
                  signupButton,
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Login',
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
