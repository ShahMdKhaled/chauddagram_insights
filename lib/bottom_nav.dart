import 'package:chauddagram_insights/views/contactpage.dart';
import 'package:chauddagram_insights/views/home_screen.dart';
import 'package:chauddagram_insights/views/profileitem.dart';
import 'package:chauddagram_insights/views/search_page.dart';
import 'package:flutter/material.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'custom_drawer.dart';

class BottomNav extends StatefulWidget {

  const BottomNav({super.key });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;


  final List<Map<String, dynamic>> pages =  [
    {'title': 'জরুরি', 'table': 'emergency_numbers', },
    {'title': 'হাসপাতাল', 'table': 'hospitals', },
    {'title': 'ব্যাংক', 'table': 'banks', },
    {'title': 'অ্যাম্বুলেন্স', 'table': 'ambulances', },
    {'title': 'রক্তদাতা', 'table': 'blood_donors', },
    {'title': 'ডাক্তার', 'table': 'doctors', },
    {'title': 'মিস্ত্রি', 'table': 'mechanics', },
    {'title': 'শিক্ষা প্রতিষ্ঠান', 'table': 'schools', },
    {'title': 'ট্রাক', 'table': 'trucks', },
  ];

  final List<Widget> _screens = [
    HomeScreen(),
    ContactPage(),
    SearchPage(tableName: 'emergency_numbers'),
    ProfileItem()
  ];




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
        title: SizedBox(
          height: 55,

          child: Image.asset(
            'assets/images/headerlogo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text("Logo not found", style: TextStyle(color: Colors.red));
            },
          ),
        ),
        automaticallyImplyLeading: false,

        // ❌ Default drawer icon বন্ধ করলো
        // leading: Builder(
        //   // ✅ Custom icon clickable রাখার জন্য
        //   builder:
        //       (context) => IconButton(
        //         padding: EdgeInsets.fromLTRB(2, 0, 7, 0),
        //         icon: Icon(Icons.menu_open),
        //         // 🔄 Change this to any icon you like
        //         onPressed: () => Scaffold.of(context).openDrawer(),
        //       ),
        // ),



      ),

      drawer: const CustomDrawer(),


      body: _screens[_currentIndex],

      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        itemPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.contact_mail_outlined),
            title: Text("Contacts"),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
