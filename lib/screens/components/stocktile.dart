import 'package:flutter/material.dart';

import '../../models/stock_model.dart';
import '../../providers/stock_provider.dart';

class StockListView extends StatelessWidget {
  const StockListView({
    super.key,
    required this.filteredStocks,
    required this.stockProvider,
  });

  final List<Stock> filteredStocks;
  final StockProvider stockProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filteredStocks.length,
      itemBuilder: (context, index) {
        Stock stock = filteredStocks[index];
        Color backgroundColor = Colors.white;
        if (stock.stockPrice.priceChange > 0) {
          backgroundColor = Colors.green
              .withOpacity(0.24); // Green background for positive price change
        } else if (stock.stockPrice.priceChange < 0) {
          backgroundColor = Colors.red
              .withOpacity(0.24); // Red background for negative price change
        }
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: backgroundColor,
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                child: Image.network(
                  stock.logoUrl,
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(
                stock.symbol,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                stock.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${stock.stockPrice.currentPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: stock.stockPrice.priceChange > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        stock.stockPrice.priceChange > 0
                            ? '+${stock.stockPrice.percentageChange.toStringAsFixed(2)}%'
                            : '${stock.stockPrice.percentageChange.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: stock.stockPrice.priceChange > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      stock.isFavorite ? Icons.star : Icons.star_border,
                      color: stock.isFavorite
                          ? const Color.fromARGB(255, 139, 84, 149)
                          : null,
                    ),
                    onPressed: () {
                      // Toggle the favorite status of the stock
                      stockProvider.toggleFavorite(stock);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
