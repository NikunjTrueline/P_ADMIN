import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/admin.dart';
import 'package:grocery_app/views/home/home_view.dart';
import 'package:grocery_app/views/login/components/signin.dart';

class UserDetailView extends StatefulWidget {
  const UserDetailView({super.key});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _contactNo = TextEditingController();

  String? _errorMessage;

  String _email = '';
  final String _password = '';

  bool _isHidden = true;
  bool _isHidden1 = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleVisibility1() {
    setState(() {
      _isHidden1 = !_isHidden1;
    });
  }

  void register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        AdminModel adminModel = AdminModel(
            email: _emailController.text.toString(),
            name: _nameController.text.toString(),
            contactNo: _contactNo.text.toString(),
            password: _passwordController.text.toString(),
            confirmPassword: _confirmPasswordController.text.toString(),
            isActive: true,
            id: userCredential.user!.uid);

        // Store user data in Firebase Realtime Database
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child("admin");
        userRef.child(userCredential.user!.uid).set(adminModel.toJson());

        // Navigate to home screen or do any other action
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } else {
      print("call else blocked ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Image.asset(
                "assets/images/signup1.png",
                height: 200,
                width: 400,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Complete your profile',
                        style: TextStyle(
                            fontSize: 25,
                            color: Color(0Xff21618C),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter valid name";
                          } else {
                            return null;
                          }
                        },
                        cursorHeight: 32,
                        cursorWidth: 2,
                        cursorColor: Colors.blueAccent,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      TextFormField(
                        cursorHeight: 32,
                        cursorWidth: 2,
                        cursorColor: Colors.blueAccent,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.blueAccent,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _email = value ?? '';
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid contact number';
                          }
                          return null;
                        },
                        cursorHeight: 32,
                        cursorWidth: 2,
                        cursorColor: Colors.blueAccent,
                        controller: _contactNo,
                        decoration: const InputDecoration(
                          labelText: 'Contact Number',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          suffixIcon: Icon(
                            Icons.phone,
                            color: Colors.blueAccent,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      TextFormField(
                        cursorHeight: 32,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid password';
                          }
                          return null;
                        },
                        cursorWidth: 2,
                        cursorColor: Colors.blueAccent,
                        controller: _passwordController,
                        decoration: InputDecoration(
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
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty ||
                              _confirmPasswordController.text !=
                                  _passwordController.text) {
                            return "Please enter valid confirm password";
                          } else {
                            return null;
                          }
                        },
                        cursorHeight: 32,
                        cursorWidth: 2,
                        cursorColor: Colors.blueAccent,
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          suffixIcon: IconButton(
                            icon: _isHidden1
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            color: Colors.blueAccent.shade200,
                            onPressed: _toggleVisibility1,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        obscureText: _isHidden1,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade100,
                        ),
                        onPressed: () {
                          register(context);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ));
                          },
                          child: const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.blueAccent),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    // _nameController.dispose();
    // _emailController.dispose();
    super.dispose();
  }
}

/*
TextFormField(
                          cursorHeight: 32,
                          cursorWidth: 2,
                          cursorColor: Colors.blueAccent,
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.person,color: Colors.blueAccent,),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          cursorHeight: 32,
                          cursorWidth: 2,
                          cursorColor: Colors.blueAccent,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email,color: Colors.blueAccent,),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                !RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                                    .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          title: 'Create Account',
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          callback: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, save the form and proceed
                              _formKey.currentState!.save();
                              // var result = await FirebaseService().createUser(UserData(
                              //     id: widget.credential.user!.uid,
                              //     contact: widget.credential.user!.phoneNumber!,
                              //     name: _nameController.text.trim(),
                              //     email: _emailController.text.trim(),
                              //     createdAt:
                              //     DateTime.now().millisecondsSinceEpoch));

                              if(true){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView(),));
                              }

                            }
                          },
                        ),
 */
