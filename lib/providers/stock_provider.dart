import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Services to access asset files

import '../models/stock_model.dart'; // Import Stock model

class StockProvider extends ChangeNotifier {
  List<Stock> _stocks = []; // List of stocks

  List<Stock> get stocks => _stocks; // Getter to access stocks

  // Method to fetch and set stocks data from stocks.json
  Future<void> fetchAndSetStocks() async {
    try {
      // Load stocks.json file from assets
      String jsonData = await rootBundle.loadString('assets/stocks.json');

      // Parse JSON data
      final jsonList = json.decode(jsonData)['stocks'] as List;

      // Map JSON data to list of Stock objects
      _stocks = jsonList.map((json) => Stock.fromJson(json)).toList();

      // Notify listeners that the data has been updated
      notifyListeners();
    } catch (error) {
      // Handle error if any
      print('Error fetching stocks data: $error');
    }
  }

  // Method to toggle the favorite status of a stock
  void toggleFavorite(Stock stock) {
    stock.isFavorite = !stock.isFavorite;
    notifyListeners(); // Notify listeners that the favorite status has changed
  }
}
