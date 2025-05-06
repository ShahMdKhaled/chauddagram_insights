import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: Consumer<DataListViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return Center(
                child: SpinKitCubeGrid(
                  color: Colors.red, // Customize color
                  size: 60.0, // Customize size
                ),
              );
            }

            if (viewModel.items.isEmpty) {
              return Center(child: Text("কোনো ডেটা পাওয়া যায়নি"));
            }


            return ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) =>
                  InfoCard(item: viewModel.items[index]),
            );
          },
        ),
      ),
    );
  }
}
