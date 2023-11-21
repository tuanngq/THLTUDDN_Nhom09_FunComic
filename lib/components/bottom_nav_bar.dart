import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;


  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // Màu nền của Container
        // borderRadius: BorderRadius.circular(40), // Độ cong của góc
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // Màu shadow
            blurRadius: 10, // Độ mờ
            offset: Offset(0, -5), // Độ lệch theo trục X và Y (để shadow xuất hiện ở phía trên)
          ),
        ],
      ),
      // margin: const EdgeInsets.all(25),
      child: GNav(
      onTabChange: (value) => onTabChange!(value),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      color: Colors.grey[400],
      activeColor: Colors.grey[900],
      // tabBackgroundColor: Colors.grey.shade300,
      // tabBorderRadius: 24,
      // tabActiveBorder: Border.all(color: Colors.white),
      tabs: const [
        GButton(
          icon: Icons.home),
  
        GButton(
          icon: Icons.book_rounded),
        
        GButton(
          icon: Icons.quick_contacts_mail),
        ]
      ),      
    );
  }
}