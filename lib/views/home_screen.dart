import 'package:chauddagram_insights/views/more_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import '../viewmodels/data_list_viewmodel.dart';
import '../models/info_item.dart';

import 'data_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imgList = [
    'https://www.pixelstalk.net/wp-content/uploads/2016/07/Download-Free-Pictures-3840x2160.jpg',
    'https://www.pixelstalk.net/wp-content/uploads/2016/07/Download-Free-Pictures-3840x2160.jpg',
    'https://www.pixelstalk.net/wp-content/uploads/2016/07/Download-Free-Pictures-3840x2160.jpg',
  ];

  final List<Map<String, dynamic>> pages = [
    {'title': 'Emergency', 'table': 'emergency_numbers', 'icon': Icons.call},
    {'title': 'Hospitals', 'table': 'hospitals', 'icon': Icons.local_hospital},
    {'title': 'Banks', 'table': 'banks', 'icon': Icons.account_balance},
    {'title': 'Ambulances', 'table': 'ambulances', 'icon': Icons.local_shipping},
    {'title': 'Blood Donors', 'table': 'blood_donors', 'icon': Icons.bloodtype},
    {'title': 'Doctors', 'table': 'doctors', 'icon': Icons.person},
    {'title': 'Mechanics', 'table': 'mechanics', 'icon': Icons.build},
    {'title': 'Education', 'table': 'schools', 'icon': Icons.school},
    {'title': 'Trucks', 'table': 'trucks', 'icon': Icons.fire_truck},
  ];




  late DataListViewModel _bloodDonorViewModel;

  @override
  void initState() {
    super.initState();
    _bloodDonorViewModel = DataListViewModel();
    _bloodDonorViewModel.fetchData('blood_donors');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Slider
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 150.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                ),
                items: imgList.map((item) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(item, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // Grid Menu item view design
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: pages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DataListPage(
                            tableName: pages[index]['table'],
                            title: pages[index]['title'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(

                          colors: [Colors.blueAccent, Colors.blueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            pages[index]['icon'],
                            size: 32,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pages[index]['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),


                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // বাম ও ডানে আলাদা করে
                children: [
                  Text(
                    'নতুন রক্তদাতা',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DataListPage(
                            tableName: 'blood_donors',
                            title: 'Blood Donors',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'সকল >',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),



            // Blood Donor List
            SizedBox(
              height: 150,
              child: ChangeNotifierProvider<DataListViewModel>.value(
                value: _bloodDonorViewModel,
                child: Consumer<DataListViewModel>(
                  builder: (context, viewModel, _) {
                    if (viewModel.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final sortedList = List<InfoItem>.from(viewModel.items)
                      ..sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);

                    final recentDonors = sortedList.take(10).toList();

                    if (recentDonors.isEmpty) {
                      return const Center(child: Text('কোনো রক্তদাতা পাওয়া যায়নি', style: TextStyle(fontSize: 16)));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentDonors.length,
                      itemBuilder: (context, index) {
                        final donor = recentDonors[index];
                        return Container(
                          width: 140,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MoreDetailPage(item: donor),

                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: donor.imageUrl != null
                                          ? NetworkImage(donor.imageUrl!)
                                          : null,
                                      child: donor.imageUrl == null
                                          ? SvgPicture.asset(
                                        'assets/icons/person.svg',
                                        height: 50,
                                        width: 50,
                                      )
                                          : null,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      donor.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      donor.bloodType ?? '',
                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
