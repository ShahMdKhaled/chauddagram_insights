import 'package:chauddagram_insights/views/more_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/info_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoCard extends StatelessWidget {
  final InfoItem item;

  const InfoCard({super.key, required this.item});

  Future<void> _makeCall(String phone, BuildContext context) async {
    String formattedPhone = phone.replaceAll(' ', '').trim();

    //call button condition
    if (!formattedPhone.startsWith('+') && !formattedPhone.startsWith('0')) {
      formattedPhone = '$formattedPhone';
    }

    final Uri uri = Uri(scheme: 'tel', path: formattedPhone);

    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    if (status.isGranted) {
      try {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch dialer');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $formattedPhone')),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Call permission denied')));
    }
  }

  //map button condition
  void _openMap(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      ); // Optional for map
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch map')));
    }
  }




  @override
  Widget build(BuildContext context) {
    return Card(

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoreDetailPage(item: item),
            ),
          );
        },


        leading:
            item.imageUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    item.imageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress==null)
                        return child;
                        return SvgPicture.asset(
                        'assets/icons/person.svg',
                        height: 50,
                        width: 50,
                        );


                    },
                    errorBuilder:
                        (_, __, ___) => SvgPicture.asset(
                          'assets/icons/person.svg',
                          height: 50,
                          width: 50,
                        ),
                  ),
                )
                //: const Icon(Icons.person_outline, size: 50,),
                : SvgPicture.asset(
                  'assets/icons/person.svg',
                  height: 50,
                  width: 50,
                ),

        title: Text(
          item.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        subtitle: Text(item.description ?? 'No description', maxLines: 1),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.bloodType != null)
              Text(
                item.bloodType ?? 'No Blood Type',
                maxLines: 1,
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),

            if (item.googleMapLocation != null)
              IconButton(
                icon: const Icon(Icons.pin_drop, color: Colors.blue),
                onPressed: () => _openMap(item.googleMapLocation!, context),
              ),
            IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () => _makeCall(item.phoneNumber, context),
            ),
          ],
        ),
      ),
    );
  }
}
