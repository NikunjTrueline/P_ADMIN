import 'package:flutter/material.dart';
import 'package:grocery_app/views/login/components/signup_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: UserDetailView(),
          )
        ],
      )),
    );
  }
}
