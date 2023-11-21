import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thltuddn01/pages/library_page.dart';

import '../components/bottom_nav_bar.dart';
import '../const.dart';
import 'contact_page.dart';
import 'book_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // navigate bottom bar
  int _selectedIndex = 0;
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages
  final List<Widget> _pages = [
    // shop page
    BookPage(userId: FirebaseAuth.instance.currentUser!.email),

    // cart page
    LibraryPage(userId: FirebaseAuth.instance.currentUser!.email),

    // contact page
    ContactPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_selectedIndex],

    );
    
  }
}



