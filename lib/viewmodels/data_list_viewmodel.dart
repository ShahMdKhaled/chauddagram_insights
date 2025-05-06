import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/info_item.dart';
import 'package:chauddagram_insights/local_database_helper.dart';

class DataListViewModel extends ChangeNotifier {
  List<InfoItem> items = [];
  bool isLoading = false;

  final DBHelper _dbHelper = DBHelper();

  Future<void> fetchData(String tableName) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://subturk.xyz/backend-dashboard/api/get_data.php?table=$tableName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Parse and save data locally
        final List<InfoItem> fetchedItems =
        data.map((e) => InfoItem.fromJson(e, tableName)).toList();

        await _dbHelper.clearItems(tableName); // Clear old
        for (var item in fetchedItems) {
          await _dbHelper.insertItem(item, tableName);
        }

        items = fetchedItems;
      } else {
        items = await _dbHelper.getItems(tableName); // fallback to local
      }

    } catch (e) {
      // On error, load from local DB
      items = await _dbHelper.getItems(tableName);
    }

    isLoading = false;
    notifyListeners();
  }
}
