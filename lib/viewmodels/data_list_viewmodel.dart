import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/info_item.dart';
import 'package:chauddagram_insights/local_database_helper.dart';

class DataListViewModel extends ChangeNotifier {
  List<InfoItem> _allItems = []; // Original full list
  List<InfoItem> items = [];     // Filtered list shown in UI
  bool isLoading = false;
  String searchQuery = '';

  final DBHelper _dbHelper = DBHelper();

  // Filters
  List<String> filters = [];
  String? selectedFilter;

  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = '';
    items = _allItems;
    notifyListeners();
  }

  // ============================================================
  // NEW: LOAD DATA WITH CACHE (24 HOUR CHECK)
  // ============================================================
  Future<void> loadDataWithCache(String tableName) async {
    isLoading = true;
    notifyListeners();

    // Get last update timestamp
    DateTime? lastUpdate = await _dbHelper.getLastUpdateTime();

    // If last update exists and is less than 24 hours old
    if (lastUpdate != null) {
      Duration diff = DateTime.now().difference(lastUpdate);

      if (diff.inHours < 24) {
        // Load from local DB
        items = await _dbHelper.getItems(tableName);
        _allItems = items;

        isLoading = false;
        notifyListeners();
        return;
      }
    }

    // Else fetch fresh API data
    await fetchData(tableName);

    // Save last update timestamp
    await _dbHelper.saveLastUpdateTime();

    isLoading = false;
    notifyListeners();
  }

  // ============================================================
  // EXISTING: Fetch data from API or Local DB
  // ============================================================
  Future<void> fetchData(String tableName) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://subturk.xyz/backend-dashboard/api/get_data.php?table=$tableName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<InfoItem> fetchedItems =
        data.map((e) => InfoItem.fromJson(e, tableName)).toList();

        await _dbHelper.clearItems(tableName);

        for (var item in fetchedItems) {
          await _dbHelper.insertItem(item, tableName);
        }

        _allItems = fetchedItems;
        items = fetchedItems;
      } else {
        _allItems = await _dbHelper.getItems(tableName);
        items = _allItems;
      }
    } catch (e) {
      _allItems = await _dbHelper.getItems(tableName);
      items = _allItems;
    }

    isLoading = false;
    notifyListeners();
  }

  // ============================================================
  // Search Filter
  // ============================================================
  void search(String query) {
    searchQuery = query;
    if (query.isEmpty) {
      items = _allItems;
    } else {
      final lowerQuery = query.toLowerCase();
      items = _allItems.where((item) {
        final nameMatch = item.name.toLowerCase().contains(lowerQuery);
        final descriptionMatch =
            item.description?.toLowerCase().contains(lowerQuery) ?? false;
        return nameMatch || descriptionMatch;
      }).toList();
    }
    notifyListeners();
  }
}
