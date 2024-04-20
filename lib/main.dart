// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/homeScreen.dart';
import 'providers/stock_provider.dart'; // Import StockScreen

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StockProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stockify',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    ),
  );
}
