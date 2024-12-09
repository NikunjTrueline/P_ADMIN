import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constants.dart';
import 'package:grocery_app/firebase/firebase_service.dart';
import 'package:grocery_app/views/login/components/signin.dart';
import '../../gen/assets.gen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  void welcome() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Log Out Successfully!'),
        backgroundColor: Color(0Xff21618C),
        shape: OutlineInputBorder(),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style:
              TextStyle(color: Color(0Xff21618C), fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              try {
                FirebaseAuth.instance.signOut();
                welcome();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (route) => false);
              } catch (e) {
                log(e.toString());
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseService().fetchDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1 / 1.2,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppConstant.categoryListView);
                  },
                  child: _buildDashboardTile('Categories', data.totalCategories,
                      Colors.pink.shade100, Assets.images.category.path),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppConstant.productListView);
                  },
                  child: _buildDashboardTile('Items', data.totalItems,
                      Colors.yellow.shade200, Assets.images.item.path),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppConstant.userListView);
                  },
                  child: _buildDashboardTile('Users', data.totalUsers,
                      Colors.blueAccent.shade100, Assets.images.user.path),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppConstant.orderView);
                  },
                  child: _buildDashboardTile('Orders', data.totalOrders,
                      Colors.green.shade200, Assets.images.order.path),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardTile(
      String title, int value, Color color, String image) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(.5),
                child: Image.asset(
                  image,
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '$value',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
