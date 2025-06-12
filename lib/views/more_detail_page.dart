import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/info_item.dart';

class MoreDetailPage extends StatelessWidget {
  final InfoItem item;

  const MoreDetailPage({super.key, required this.item});

  Future<void> _makeCall(String phone, BuildContext context) async {
    try {
      String formattedPhone = phone.replaceAll(' ', '').trim();


      if (!formattedPhone.startsWith('+') && !formattedPhone.startsWith('0')) {
        formattedPhone = '+880$formattedPhone';
      } else if (formattedPhone.startsWith('0')) {
        formattedPhone = '+880${formattedPhone.substring(1)}';
      }

      final Uri uri = Uri(scheme: 'tel', path: formattedPhone);

      // অনুমতি চেক
      if (!await Permission.phone.isGranted) {
        await Permission.phone.request();
      }

      if (await Permission.phone.isGranted) {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch dialer');
        }
      } else {
        throw Exception('Permission denied');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('কল করতে ব্যর্থ: ${e.toString()}')),
      );
    }
  }

  Future<void> _sendSMS(String phone, BuildContext context) async {
    try {
      String formattedPhone = phone.replaceAll(' ', '').trim();

      // বাংলাদেশের জন্য ফোন নম্বর ফরম্যাটিং
      if (!formattedPhone.startsWith('+') && !formattedPhone.startsWith('0')) {
        formattedPhone = '+880$formattedPhone';
      } else if (formattedPhone.startsWith('0')) {
        formattedPhone = '+880${formattedPhone.substring(1)}';
      }

      final Uri uri = Uri(scheme: 'sms', path: formattedPhone);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch SMS app');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('এসএমএস পাঠাতে ব্যর্থ: ${e.toString()}')),
      );
    }
  }

  Future<void> _openMap(String url, BuildContext context) async {
    try {
      if (url.isEmpty) throw Exception('Empty URL');

      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch map');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('মানচিত্র খুলতে ব্যর্থ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color Scheme
    const Color primaryColor = Colors.blueAccent; // Deep Blue
    const Color secondaryColor = Color(0xFF4CAF50); // Green
    const Color accentColor = Color(0xFF00BCD4); // Teal
    const Color backgroundColor = Color(0xFFF5F7FA); // Light Grey
    const Color cardColor = Colors.white;
    const Color textPrimary = Color(0xFF333333);
    const Color textSecondary = Color(0xFF666666);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          item.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withOpacity(0.1),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                            ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildDefaultAvatar(primaryColor),
                        )
                            : _buildDefaultAvatar(primaryColor),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name and Type
                    Column(
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if ((item.type ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              item.type!,
                              style: TextStyle(
                                fontSize: 14,
                                color: textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Blood Type
                    if (item.bloodType != null && item.bloodType!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE), // Light Red
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFEF9A9A), // Light Red Border
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bloodtype,
                                color: Color(0xFFD32F2F), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              item.bloodType!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD32F2F), // Dark Red
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Contact Card
            if (item.phoneNumber != null && item.phoneNumber!.isNotEmpty)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'যোগাযোগ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.phone, color: secondaryColor, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.phoneNumber!,
                              style: TextStyle(
                                fontSize: 16,
                                color: textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.sms, color: accentColor),
                            onPressed: () => _sendSMS(item.phoneNumber!, context),
                          ),
                          IconButton(
                            icon: Icon(Icons.call, color: secondaryColor),
                            onPressed: () => _makeCall(item.phoneNumber!, context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Details Card
            if (item.description != null && item.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'বিস্তারিত',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  if (item.phoneNumber != null && item.phoneNumber!.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () => _sendSMS(item.phoneNumber!, context),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sms, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'এসএমএস',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () => _makeCall(item.phoneNumber!, context),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.call, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'কল করুন',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (item.googleMapLocation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _openMap(item.googleMapLocation!, context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'লোকেশন দেখুন',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/person.svg',
          height: 50,
          width: 50,
          color: color.withOpacity(0.4),
        ),
      ),
    );
  }
}