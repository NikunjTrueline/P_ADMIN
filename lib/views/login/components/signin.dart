import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/views/home/home_view.dart';
import 'package:grocery_app/views/login/components/signup_form.dart';
import '../../../shared_pref/prefrence_servicies.dart';
import '../../../widget/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? emailError, passwordError;

  void resetFocus() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    String email = _emailController.text.toString().trim();
    String password = _passwordController.text.toString().trim();

    resetFocus();

    if (!Utils.isEmailValid(email)) {
      // show an error
      setState(() {
        emailError = "Enter  valid email";
      });
    } else if (!Utils.isPasswordValid(password)) {
      // show an password error
      setState(() {
        passwordError = "Enter valid password";
      });
    } else {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeView(),
              ),
              (route) => false);
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/images/signup1.png",
                height: 200,
                width: 400,
              ),
              TextField(
                cursorHeight: 32,
                cursorWidth: 2,
                cursorColor: Colors.blueAccent,
                controller: _emailController,
                decoration: InputDecoration(
                  errorText: emailError,
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  suffixIcon: const Icon(
                    Icons.email,
                    color: Colors.blueAccent,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                cursorHeight: 32,
                cursorWidth: 2,
                cursorColor: Colors.blueAccent,
                controller: _passwordController,
                decoration: InputDecoration(
                  errorText: passwordError,
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  suffixIcon: IconButton(
                    icon: _isHidden
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    color: Colors.blueAccent.shade200,
                    onPressed: _toggleVisibility,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                obscureText: _isHidden,
              ),
              const SizedBox(height: 60.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade100,
                ),
                onPressed: () => _signInWithEmailAndPassword(context),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserDetailView(),
                      ),
                      (route) => false);
                },
                child: const Text("don't have an account ?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*


 */
