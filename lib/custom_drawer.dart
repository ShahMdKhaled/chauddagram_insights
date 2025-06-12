import 'package:chauddagram_insights/bottom_nav.dart';
import 'package:chauddagram_insights/views/data_list_page.dart';

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  final List<Map<String, dynamic>> _drawerPages = const [
    {'title': 'Emergency', 'table': 'emergency_numbers', 'icon': Icons.call},
    {'title': 'Blood Donors', 'table': 'blood_donors', 'icon': Icons.bloodtype},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //  Drawer Header
          Container(
            height: 160,
            color: Colors.blueAccent,
            // 👇 left, top, right, bottom
            padding: EdgeInsets.fromLTRB(16, 23, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔵 Logo (left side)
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  // ✅ replace with your link
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 16),

                // 📛 App name & slogan (right side)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chauddagram Insights',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'সকল সেবা একই সাথে',
                      style: TextStyle(color: Colors.yellow, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔷 Group: Dashboard
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "DASHBOARD",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              // বর্তমান ড্রয়ার বন্ধ করুন
              Navigator.pop(context);
              // Homepage এ নেভিগেট করুন
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNav(),
                ), // <-- এখানে Homepage উইজেটটি যুক্ত করুন
              );
            },
          ),


          ..._drawerPages.map((pageData) {
            return ListTile(
              leading: Icon(pageData['icon']),
              title: Text(pageData['title']),
              onTap: () {
                Navigator.pop(context); // ড্রয়ার বন্ধ করুন
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DataListPage(
                      tableName: pageData['table'],
                      title: pageData['title'],
                    ),
                  ),
                );
              },
            );
          }).toList(),


          ListTile(
            leading: Icon(Icons.add_home),
            title: Text("To late"),
            onTap: () {},
          ),


          Divider(),

          // 🔷 Group: Settings
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "SETTINGS",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Preferences"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text("Security"),
            onTap: () {},
          ),
          Divider(),

          // 🔷 Group: Account
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "ACCOUNT",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              // Use your logout logic here
            },
          ),
        ],
      ),
    );
  }
}
