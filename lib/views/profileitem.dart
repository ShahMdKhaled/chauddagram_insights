import 'package:chauddagram_insights/bottom_nav.dart';
import 'package:chauddagram_insights/views/privacy_policy.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'data_list_page.dart';

class ProfileItem extends StatelessWidget {
  ProfileItem({super.key});



  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'জরুরি যোগাযোগ', 'table': 'emergency_numbers', 'icon': Icons.call},
    {'title': 'রক্তদাতা', 'table': 'blood_donors', 'icon': Icons.bloodtype},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(),
            ),
          ),
          SliverToBoxAdapter(child: _buildSection('Quick Actions')),
          _buildActionGrid(context),
          SliverToBoxAdapter(child: _buildSection('Services')),
          SliverList(
            delegate: SliverChildListDelegate(_buildServiceTiles(context)),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 14)),
          SliverToBoxAdapter(child: _buildSection('Others')),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildothersTile(
                context,
                icon: Icons.policy_rounded,
                title: "গোপনীয়তা নীতি",
                subtitle: "আপনার তথ্য ব্যবস্থাপনা সম্পর্কে জানুন",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy(
                        title: "গোপনীয়তা নীতি",
                        url: "https://www.termsfeed.com/live/532e63a8-6d6a-4999-bf2b-24fc66159163",
                      ),
                    ),
                  );
                },
              ),
              _buildothersTile(
                context,
                icon: Icons.share_outlined,
                title: "শেয়ার করুন",
                subtitle: "অ্যাপক সম্পর্কে বন্ধুদের জানান",

                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("This feature will be available soon."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
              ),
              _buildothersTile(
                context,
                icon: Icons.logout,
                title: "অ্যাপ বন্ধ",
                subtitle: "অ্যাপ বন্ধ করতে এখানে চাপুন",
                color: Colors.red,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("This feature will be available soon."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  // Header Section
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[800]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20,
            bottom: 20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.account_circle, size: 150, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome Back,',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Section Title
  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Quick Action Grid using Sliver
  SliverPadding _buildActionGrid(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildListDelegate([
          _buildActionCard(
            icon: Icons.home,
            color: Colors.blue,
            title: "Home",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNav()),
              );
            },
          ),
          _buildActionCard(
            icon: Icons.history,
            color: Colors.orange,
            title: "History",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("This feature will be available soon."),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ]),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
      ),
    );
  }

  // Action Cards
  Widget _buildActionCard({
    required IconData icon,
    required Color color,
    required String title,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Service Tiles List
  List<Widget> _buildServiceTiles(BuildContext context) {
    return _menuItems.map((item) {
      return _buildServiceTile(
        context,
        icon: item['icon'] as IconData,
        title: item['title'] as String,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DataListPage(
                tableName: item['table'] as String,
                title: item['title'] as String,
              ),
            ),
          );
        },
      );
    }).toList();
  }

  // Individual Service Tile
  Widget _buildServiceTile(BuildContext context,
      {required IconData icon, required String title, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          onTap: onTap,
        ),
      ),
    );
  }

  // Others Tiles
  Widget _buildothersTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        Color color = Colors.blue,
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color == Colors.red ? Colors.red : null,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          onTap: onTap
        ),
      ),
    );
  }
}
