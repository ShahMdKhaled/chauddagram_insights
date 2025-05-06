import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //  Drawer Header
          Container(
            height: 160, // 👇 Jemon height chai, set koro (default er cheye kom)
            color: Colors.blueAccent,
            // 👇 left, top, right, bottom
            padding: EdgeInsets.fromLTRB(16, 23, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔵 Logo (left side)
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/logo.png'),  // ✅ replace with your link
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
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          // 🔷 Group: Dashboard
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("DASHBOARD",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.contact_emergency),
            title: Text("Emergency"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.add_home),
            title: Text("To late"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.bloodtype),
            title: Text("Blood Bank"),
            onTap: () {},
          ),

          Divider(),

          // 🔷 Group: Settings
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("SETTINGS",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
            child: Text("ACCOUNT",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
