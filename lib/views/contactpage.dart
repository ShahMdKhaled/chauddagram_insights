import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});


  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Header Text Section
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Any question or remarks? \n Just write us a message!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),



            // Contact Form Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Send us a message',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Message',
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(Icons.message),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle form submission
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Message sent successfully!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('SEND MESSAGE'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Direct Contact Section
            const Text(
              'Or contact us directly',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Contact Methods
            ContactMethodTile(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '+8801636182924',
              onTap: () => _launchURL('tel:+8801636182924'),
            ),
            ContactMethodTile(
              icon: Icons.email,
              title: 'Email Us',
              subtitle: 'noorsoftsolution@gmail.com',
              onTap: () => _launchURL('mailto:noorsoftsolution@gmail.com'),
            ),
            ContactMethodTile(
              icon: Icons.location_on,
              title: 'Visit Us',
              subtitle: 'Chauddagram Bazar, Cumilla, Bangladesh',
              onTap: () => _launchURL('https://maps.app.goo.gl/WmRkkdvcyeFH9vYu7'),
            ),
            const SizedBox(height: 20),

            // Social Media Links
            const Text(
              'Connect with us on social media',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //       icon: Image.asset('assets/facebook.png', height: 30),
            //       onPressed: () => _launchURL('https://facebook.com/bloodapp'),
            //     ),
            //     IconButton(
            //       icon: Image.asset('assets/twitter.png', height: 30),
            //       onPressed: () => _launchURL('https://twitter.com/bloodapp'),
            //     ),
            //     IconButton(
            //       icon: Image.asset('assets/instagram.png', height: 30),
            //       onPressed: () => _launchURL('https://instagram.com/bloodapp'),
            //     ),
            //     IconButton(
            //       icon: Image.asset('assets/whatsapp.png', height: 30),
            //       onPressed: () => _launchURL('https://wa.me/8801234567890'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class ContactMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ContactMethodTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Theme.of(context).primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}