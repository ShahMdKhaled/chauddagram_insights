import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/info_item.dart';

class MoreDetailPage extends StatelessWidget {
  final InfoItem item;

  const MoreDetailPage({super.key, required this.item});

  void _launchCall(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Optional Image Section
            // if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
            //   Container(
            //
            //     height: 100,
            //     width: 100,
            //     decoration: BoxDecoration(
            //
            //       borderRadius: BorderRadius.circular(20),
            //
            //       image: DecorationImage(
            //         image: NetworkImage(item.imageUrl!),
            //         fit: BoxFit.cover,
            //
            //       ),
            //     ),
            //   )
            //
            // else
            //   Container(
            //
            //     height: 100,
            //     width: 100,
            //
            //
            //     child:  SvgPicture.asset(
            //       'assets/icons/person.svg',
            //       height: 50,
            //       width: 50,
            //     ),
            //
            //   ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [





                      if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                        Container(

                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(20),

                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl!),
                              fit: BoxFit.cover,

                            ),
                          ),
                        )

                      else
                        Container(

                          height: 100,
                          width: 100,


                          child:  SvgPicture.asset(
                            'assets/icons/person.svg',
                            height: 50,
                            width: 50,
                          ),

                        ),

                      Text(
                        item.name,

                        style: const TextStyle(

                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Phone Row
                      if (item.phoneNumber != null && item.phoneNumber!.isNotEmpty)
                      Row(
                        children: [
                          // const Icon(Icons.phone, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(item.phoneNumber,
                                style: const TextStyle(fontSize: 16)),
                          ),
                          IconButton(
                            onPressed: () => _launchCall(item.phoneNumber),
                            icon: const Icon(Icons.call, color: Colors.green),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Blood Type
                      if (item.bloodType != null && item.bloodType!.isNotEmpty)
                        Row(

                          children: [

                            const SizedBox(width: 8),
                            Text(
                              " ${item.bloodType}",
                              style: const TextStyle(fontSize: 16),
                            ),

                            Spacer(),

                            const Icon(Icons.bloodtype, color: Colors.red),
                          ],
                        ),


                      const SizedBox(height: 16),

                      // Description
                      if (item.description != null &&
                          item.description!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description!,
                              style: const TextStyle(fontSize: 15, height: 1.5),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
