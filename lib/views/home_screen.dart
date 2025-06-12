import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../bottom_nav.dart';
import '../viewmodels/data_list_viewmodel.dart';
import '../models/info_item.dart';
import 'data_list_page.dart';
import 'more_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imgList = const[
    'assets/images/c2.jpg',
    'assets/images/c3.jpg',
    'assets/images/c4.jpg',
    'assets/images/c.jpg',
  ];

  final List<Map<String, dynamic>> pages = const [
    {'title': 'জরুরি', 'table': 'emergency_numbers', 'icon': Icons.call, 'color': Colors.redAccent},
    {'title': 'হাসপাতাল', 'table': 'hospitals', 'icon': Icons.local_hospital, 'color': Colors.green},
    {'title': 'ব্যাংক', 'table': 'banks', 'icon': Icons.account_balance, 'color': Colors.blue},
    {'title': 'অ্যাম্বুলেন্স', 'table': 'ambulances', 'icon': Icons.local_shipping, 'color': Colors.orange},
    {'title': 'রক্তদাতা', 'table': 'blood_donors', 'icon': Icons.bloodtype, 'color': Colors.pink},
    {'title': 'ডাক্তার', 'table': 'doctors', 'icon': Icons.person, 'color': Colors.teal},
    {'title': 'মিস্ত্রি', 'table': 'mechanics', 'icon': Icons.build, 'color': Colors.deepPurple},
    {'title': 'শিক্ষা প্রতিষ্ঠান', 'table': 'schools', 'icon': Icons.school, 'color': Colors.indigo},
    {'title': 'ট্রাক', 'table': 'trucks', 'icon': Icons.fire_truck, 'color': Colors.amber},
  ];



  int _currentCarouselIndex = 0;
  late DataListViewModel _bloodDonorViewModel;


  @override
  void initState() {
    super.initState();

    _bloodDonorViewModel = DataListViewModel();

    // Delay the data fetch to prevent blocking initial UI render
    Future.delayed(const Duration(milliseconds: 2000), () {
      _bloodDonorViewModel.fetchData('blood_donors');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Carousel Slider at the very top
          SliverToBoxAdapter(
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                    enlargeCenterPage: true,
                    viewportFraction: 0.81,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentCarouselIndex = index;
                      });
                    },
                  ),
                  items: imgList.map((item) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(item, fit: BoxFit.cover),
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



                const SizedBox(height: 8),

                AnimatedSmoothIndicator(
                  activeIndex: _currentCarouselIndex,
                  count: imgList.length,
                  effect: const ExpandingDotsEffect(
                    dotWidth: 8,
                    dotHeight: 8,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                  ),
                ),


                const SizedBox(height: 3),
              ],
            ),
          ),




          // Grid Menu
          SliverPadding(
            padding: const EdgeInsets.all(15),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: pages[index]['color'].withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              pages[index]['icon'],
                              size: 24,
                              color: pages[index]['color'],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pages[index]['title'],
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: pages.length,
              ),
            ),
          ),

          // Blood Donors Section Header
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'নতুন রক্তদাতা',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  InkWell(
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Text(
                        'সকল দেখুন',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Blood Donors List
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ChangeNotifierProvider<DataListViewModel>.value(
                value: _bloodDonorViewModel,
                child: Consumer<DataListViewModel>(
                  builder: (context, viewModel, _) {
                    if (viewModel.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final sortedList = List<InfoItem>.from(viewModel.items)
                      ..sort(
                            (a, b) =>
                        b.createdAt?.compareTo(
                          a.createdAt ?? DateTime.now(),
                        ) ??
                            0,
                      );

                    final recentDonors = sortedList.take(10).toList();

                    if (recentDonors.isEmpty) {
                      return const Center(
                        child: Text(
                          'কোনো রক্তদাতা পাওয়া যায়নি',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: recentDonors.length,
                      itemBuilder: (context, index) {
                        final donor = recentDonors[index];
                        return Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MoreDetailPage(item: donor
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      donor.imageUrl != null && donor.imageUrl!.isNotEmpty
                                          ? CachedNetworkImage(
                                        imageUrl: donor.imageUrl!,
                                        imageBuilder: (context, imageProvider) => CircleAvatar(
                                          radius: 30,
                                          backgroundImage: imageProvider,
                                          backgroundColor: Colors.grey[200],
                                        ),
                                        placeholder: (context, url) => CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey[200],
                                          child: const CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                        errorWidget: (context, url, error) => CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey[200],
                                          child: SvgPicture.asset(
                                            'assets/icons/person.svg',
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      )
                                          : CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey[200],
                                        child: SvgPicture.asset(
                                          'assets/icons/person.svg',
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      Text(
                                        donor.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),

                                      const SizedBox(height: 6),

                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          donor.bloodType ?? '',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ]

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
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}