import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/constants/constants.dart';
import 'package:grocery_app/gen/assets.gen.dart';
import 'package:grocery_app/views/login/components/signin.dart';

import '../../firebase/firebase_service.dart';
import '../home/home_view.dart';
import '../login/components/signup_form.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigator.pushReplacementNamed(context, AppConstant.loginView);
      var auth = FirebaseAuth.instance.currentUser;
      FirebaseService().getUserData1().then((admin) {
        if (admin != null && admin.isActive) {
          if (auth == null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ));
          } else {
            welcome();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
          }
        } else {
          if (auth == null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ));
          } else {
            showRestrictedDialog(context);
          }
        }
      });
    });
  }

  void welcome() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wel-come to Admin Panel!'),
        backgroundColor: Color(0Xff21618C),
        shape: OutlineInputBorder(),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  showRestrictedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Access Restricted'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have been restricted by the admin.'),
                Text('Please try again later.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                SystemNavigator.pop(); // Attempts to close the application
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: Center(
        child: Assets.images.appLogo.image(),
      ),
    );
  }
}
