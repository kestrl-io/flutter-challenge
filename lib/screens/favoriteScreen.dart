import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/stock_provider.dart';
import 'components/stocktile.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final favoriteStocks =
        stockProvider.stocks.where((stock) => stock.isFavorite).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 36),

        // good morning bro
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Good morning,',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 142, 123, 146),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Let's track your stocks",
            style: GoogleFonts.notoSerif(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 133, 65, 145),
            ),
          ),
        ),

        const SizedBox(height: 28),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Favorites Stocks",
            style: GoogleFonts.notoSerif(
              //fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        favoriteStocks.isEmpty
            ? _buildEmptyFavoritesMessage()
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: StockListView(
                    filteredStocks: favoriteStocks,
                    stockProvider: stockProvider,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyFavoritesMessage() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'You have no favorite stocks yet. Check list of stocks on discover page',
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
