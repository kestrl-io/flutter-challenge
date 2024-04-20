import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/stock_model.dart';
import '../providers/stock_provider.dart';
import 'components/stocktile.dart';

class StockListScreen extends StatefulWidget {
  const StockListScreen({Key? key}) : super(key: key);

  @override
  _StockListScreenState createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    stockProvider.fetchAndSetStocks();

    return Consumer<StockProvider>(
      builder: (context, stockProvider, _) {
        List<Stock> stocks = stockProvider.stocks;
        List<Stock> filteredStocks = _getFilteredStocks(stocks);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild on text field changes
                },
              ),
            ),
            Expanded(
              child: StockListView(
                filteredStocks: filteredStocks,
                stockProvider: stockProvider,
              ),
            ),
          ],
        );
      },
    );
  }

  List<Stock> _getFilteredStocks(List<Stock> stocks) {
    final query = _searchController.text.toLowerCase();
    return stocks.where((stock) {
      return stock.name.toLowerCase().contains(query) ||
          stock.symbol.toLowerCase().contains(query);
    }).toList();
  }
}
