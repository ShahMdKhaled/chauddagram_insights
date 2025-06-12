import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/data_list_viewmodel.dart'; // আপনার ফাইল পাথ অনুযায়ী ঠিক করবেন

class SearchPage extends StatefulWidget {
  final String tableName;
  //final List<String> tables;

  const SearchPage({Key? key, required this.tableName, //required this.tables
   }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

final List<Map<String, dynamic>> pages =  [
  {'title': 'জরুরি', 'table': 'emergency_numbers', },
  {'title': 'হাসপাতাল', 'table': 'hospitals', },
  {'title': 'ব্যাংক', 'table': 'banks', },
  {'title': 'অ্যাম্বুলেন্স', 'table': 'ambulances', },
  {'title': 'রক্তদাতা', 'table': 'blood_donors', },
  {'title': 'ডাক্তার', 'table': 'doctors', },
  {'title': 'মিস্ত্রি', 'table': 'mechanics', },
  {'title': 'শিক্ষা প্রতিষ্ঠান', 'table': 'schools', },
  {'title': 'ট্রাক', 'table': 'trucks', },
];

class _SearchPageState extends State<SearchPage> {
  late DataListViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel = DataListViewModel();
    _viewModel.fetchData(widget.tableName);

    _searchController.addListener(() {
      _viewModel.search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DataListViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search List'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or description',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _viewModel.clearSearch();
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ),
        body: Consumer<DataListViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (model.items.isEmpty) {
              return const Center(child: Text('No results found.'));
            }
            return ListView.builder(
              itemCount: model.items.length,

              itemBuilder: (context, index) {
                final item = model.items[index];
                return ListTile(
                  leading: item.imageUrl != null
                      ? Image.network(
                    item.imageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
                  )
                      : const Icon(Icons.info),
                  title: Text(item.name),
                  subtitle: item.description != null && item.description!.isNotEmpty
                      ? Text(item.description!, maxLines: 3,)
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () {
                      // call functionality implement করবেন
                    },
                  ),
                  onTap: () {
                    // কোনো বিস্তারিত দেখানোর জন্য navigation দিতে পারেন
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
