import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:habit_tracker/example.dart';
import 'package:habit_tracker/firebase_options.dart';


import 'Routes/routes.dart';
import 'fb_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final plugin = FacebookLogin(debug: true);
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
     //home : FacebookLoginAuth()
      title: 'Habit Tracker',
      initialRoute: '/splash',
      getPages: Routes.routes,
    );
  }
}


