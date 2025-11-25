import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../viewmodels/data_list_viewmodel.dart';

import 'components/info_card.dart';

class DataListPage extends StatelessWidget {
  final String tableName;

  final String title;

  const DataListPage({super.key, required this.tableName, required this.title});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataListViewModel()..fetchData(tableName),

      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<DataListViewModel>(context, listen: false)
                    .fetchData(tableName);
              },
            ),
          ],
        ),


        //left side + icon
        //floating action button

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Coming Soon.."),
            ));
          },
          child: const Icon(Icons.add),
        ),



        body: Consumer<DataListViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: Colors.blueAccent,
                      size: 50.0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ডেটা লোড হচ্ছে...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [


                // Search Bar
                //local search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'অনুসন্ধান করুন...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: viewModel.search,
                    ),
                  ),
                ),

                // Filter Chips (opt ional)
                if (viewModel.filters.isNotEmpty)
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: viewModel.filters.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: Text(viewModel.filters[index]),
                            selected: viewModel.selectedFilter == viewModel.filters[index],
                            onSelected: (selected) {
                              viewModel.setFilter(viewModel.filters[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),

                // Data Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        'মোট: ${viewModel.items.length} টি',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Data List
                Expanded(
                  child: viewModel.items.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "কোনো ডেটা পাওয়া যায়নি",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (viewModel.searchQuery.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              viewModel.clearSearch();
                            },
                            child: const Text('সার্চ ক্লিয়ার করুন'),
                          ),
                      ],
                    ),
                  )
                      : RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<DataListViewModel>(context, listen: false)
                          .fetchData(tableName);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: viewModel.items.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 7),
                      itemBuilder: (context, index) => InfoCard(
                        item: viewModel.items[index],
                        // onTap: () {
                        //   // Add navigation to detail page if needed
                        //
                        // },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}