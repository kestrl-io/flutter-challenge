// Import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'stock.dart'; // Import the Stock class

// Main entry point of the Flutter application
void main() {
  // Initialize the application by running the MyApp widget
  runApp(MyApp());
}

// MyApp is a stateless widget that acts as the root of the application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp wraps the app and provides common functionality such as theming
    return MaterialApp(
      title: 'Stock Screener', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets the primary color theme
      ),
      home: StockListScreen(), // Sets the home screen to StockListScreen
    );
  }
}

// Stateful widget that displays a list of stocks and includes a search bar
class StockListScreen extends StatefulWidget {
  @override
  _StockListScreenState createState() =>
      _StockListScreenState(); // Create the state for this screen
}

// State class for StockListScreen
class _StockListScreenState extends State<StockListScreen> {
  // Lists to hold the stocks and filtered stocks
  List<Stock> stocks = [];
  List<Stock> filteredStocks = [];

  // Loading state
  bool isLoading = true;

  // Controller for the search bar
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load stocks when the screen initializes
    fetchStocks();
    // Add a listener to the search controller to call _onSearchChanged when the text changes
    searchController.addListener(_onSearchChanged);
  }

  // Dispose the search controller when the widget is disposed
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function to load stocks from JSON file
  Future<void> fetchStocks() async {
    try {
      // Load the JSON file from assets
      final String jsonString =
          await rootBundle.loadString('assets/stocks.json');

      // Parse the JSON data
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> data = jsonData['stocks'];

      // Convert JSON data to a list of Stock objects
      setState(() {
        stocks = data
            .map((stockData) => Stock(
                  id: stockData['id'],
                  symbol: stockData['symbol'],
                  name: stockData['name'],
                  logoUrl: stockData['logo_url'],
                  currentPrice: double.parse(
                      stockData['stock_price']['current_price']['amount']),
                  priceChange:
                      stockData['stock_price']['price_change'].toDouble(),
                  percentageChange:
                      stockData['stock_price']['percentage_change'].toDouble(),
                ))
            .toList();

        // Initially, filtered stocks is the same as all stocks
        filteredStocks = List.from(stocks);
        isLoading = false; // Loading is complete
      });
    } catch (e) {
      // Print an error message if loading fails
      print('Error loading stocks: $e');
    }
  }

  // Function that runs every time the text in the search bar changes
  void _onSearchChanged() {
    setState(() {
      // Get the query from the search bar and convert it to lowercase
      final query = searchController.text.toLowerCase().trim();

      // Filter stocks based on the query matching the start of the name or symbol
      filteredStocks = stocks.where((stock) {
        // Check if the stock's name or symbol starts with the query
        final nameStartsWith = stock.name.toLowerCase().startsWith(query);
        final symbolStartsWith = stock.symbol.toLowerCase().startsWith(query);
        return nameStartsWith || symbolStartsWith;
      }).toList();
    });
  }

  // Build the user interface for the screen
  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Screener'), // Title of the app bar
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            // Search bar TextField
            child: TextField(
              controller: searchController, // Uses the search controller
              decoration: InputDecoration(
                hintText:
                    'Search by company name or symbol...', // Placeholder text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),

      // Display loading indicator or the list of stocks
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
              itemCount: filteredStocks.length, // Number of items in the list
              itemBuilder: (context, index) {
                final stock = filteredStocks[index];

                // Display each stock item
                return ListTile(
                  // Display the stock's logo image
                  leading: Image.network(
                    stock.logoUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        // If loading is complete, return the image
                        return child;
                      } else {
                        // Otherwise, show a loading indicator
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Show an error icon if the image fails to load
                      return CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.error, color: Colors.white),
                      );
                    },
                  ),

                  // Display the stock's name and current price
                  title: Text(stock.name),
                  subtitle: Text(
                      '${stock.symbol} - \$${stock.currentPrice.toStringAsFixed(2)}'),

                  // Change the background color based on price change
                  tileColor: stock.priceChange >= 0
                      ? Colors.green[50]
                      : Colors.red[50],

                  // Display the stock's price change and percentage change
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${stock.priceChange.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: stock.priceChange >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        '${stock.percentageChange.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: stock.percentageChange >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
