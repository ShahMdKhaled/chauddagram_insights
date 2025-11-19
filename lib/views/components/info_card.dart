import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/info_item.dart';
import '../more_detail_page.dart';

class InfoCard extends StatelessWidget {
  final InfoItem item;



  const InfoCard({super.key, required this.item});

  Future<void> _makeCall(String phone, BuildContext context) async {
    String formattedPhone = phone.replaceAll(' ', '').trim();

    formattedPhone = formattedPhone;

    // if (!formattedPhone.startsWith('+') && !formattedPhone.startsWith('0')) {
    //   formattedPhone = '+880$formattedPhone';
    // }


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
          SnackBar(content: Text('Could not call $formattedPhone')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Call permission denied')),
      );
    }
  }

  void _openMap(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch map')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoreDetailPage(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              Center(
                child: item.imageUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    item.imageUrl!,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => SvgPicture.asset(
                      'assets/icons/person.svg',
                      height: 45,
                      width: 45,
                    ),
                  ),
                )
                    : SvgPicture.asset(
                  'assets/icons/person.svg',
                  height: 45,
                  width: 45,
                ),
              ),
              const SizedBox(width: 10),

              // Name & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((item.type ?? '').trim().isNotEmpty)
                      Text(
                        item.type!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      item.description ?? '',
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Trailing actions
              Wrap(
                spacing: 4,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (item.bloodType != null && item.bloodType!.isNotEmpty)
                    Text(
                      item.bloodType!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  if (item.googleMapLocation != null &&
                      item.googleMapLocation!.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.pin_drop, color: Colors.blue, size: 22),
                      onPressed: () => _openMap(item.googleMapLocation!, context),
                    ),
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.green, size: 22),
                    onPressed: () => _makeCall(item.phoneNumber, context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
