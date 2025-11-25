import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chauddagram_insights/secret/secrets.dart';



// contact us controller
final nameController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

void sendEmail() async {
  String username = email; //came from secret.dart
  String password = emailPassword; //came from secret.dart

  final smtpServer = gmail(username, password);

      final message =
          Message()
            ..from = Address(username, 'Chauddagram Insights')
            ..recipients.add(sentemail) //email came from secret.dart
            ..subject = 'New Contact Form Message'
            ..text = """
Name: ${nameController.text}
Email: ${emailController.text}
Message: ${messageController.text}
""";


  try {
          await send(message, smtpServer);
          print('Message sent!');
        } catch (e) {
          print('Error: $e');
        }
  }


class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      print('Launching $url');
    } else {
      print('Could not launch $url');
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Any question or remarks? \n Just write us a message!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      controller: nameController,
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
                      controller: emailController,
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
                      controller: messageController,
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
                      onPressed: () async{
                        sendEmail();
                        // wait until email is sent
                        // Clear form fields after sending
                        nameController.clear();
                        emailController.clear();
                        messageController.clear();


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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              onTap: () => _launchURL('mailto:noorsoftsolution@gmail.com?subject=Hello&body=Hi%20there'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: SvgPicture.asset('assets/icons/fblogo.svg',width: 40, height: 40),
                  onPressed: () => _launchURL('https://www.facebook.com/Shahmdkhaled1'),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: SvgPicture.asset('assets/icons/teleg.svg', width: 40, height: 40),
                  onPressed: () => _launchURL('https://t.me/shahmdkhaled'),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: SvgPicture.asset('assets/icons/insta.svg', width: 40, height: 40),
                  onPressed: () => _launchURL('https://www.instagram.com/shahmdkhaled1'),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: SvgPicture.asset('assets/icons/wp.svg', width: 40, height: 40),
                  onPressed: () => _launchURL('https://wa.me/8801636182924'),
                ),
              ],
            ),
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