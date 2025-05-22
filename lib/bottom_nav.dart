import 'package:chauddagram_insights/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'custom_drawer.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    Center(child: Text('Likes Screen')),
    Center(child: Text('Search Screen')),
    Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chauddagram Insights"),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.black

        ),

        backgroundColor: Colors.white,
        centerTitle: true,

        automaticallyImplyLeading: false,

        // ❌ Default drawer icon বন্ধ করলো
        leading: Builder(
          // ✅ Custom icon clickable রাখার জন্য
          builder:
              (context) => IconButton(
                padding: EdgeInsets.fromLTRB(2, 0, 7, 0),
                icon: Icon(Icons.menu_open),
                // 🔄 Change this to any icon you like
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),

      drawer: const CustomDrawer(),

      // 🔽 এখানে AppBar সরিয়ে দিলে তোমার প্রতিটি স্ক্রিন তার নিজের AppBar রাখতে পারবে
      body: _screens[_currentIndex],

      bottomNavigationBar: Container(
        child: SalomonBottomBar(
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
              icon: Icon(Icons.favorite_border),
              title: Text("Likes"),
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
      ),
    );
  }
}
