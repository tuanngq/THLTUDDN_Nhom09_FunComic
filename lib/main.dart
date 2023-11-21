import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thltuddn01/authentication/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBcK3QFTl3O0IZFxHRGcYDmSjDxDo6eDFc",
      appId: "1:652953257504:android:1e6392fd96cfd2b666de45", 
      messagingSenderId: "652953257504", 
      projectId: "thltuddn-27cd8",
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}