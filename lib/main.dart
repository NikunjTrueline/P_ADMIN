import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/routing/app_route.dart';
import 'package:grocery_app/themes/app_theme.dart';
import 'constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDxmJJqOeomorlF7sxRhC45L_r3t5LefmQ',
      appId: '1:972977394163:android:d838070f365ccf9bab0286',
      messagingSenderId: '972977394163',
      projectId: 'medical-management-6c653',
      storageBucket: 'medical-management-6c653.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: AppConstant.splashView,
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
