class Stock {
  final int id;
  final String symbol;
  final String name;
  final String logoUrl;
  final StockPrice stockPrice;
  bool isFavorite;

  Stock({
    required this.id,
    required this.symbol,
    required this.name,
    required this.logoUrl,
    required this.stockPrice,
    this.isFavorite = false,
  });

  // Named constructor to parse JSON and initialize Stock object
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      logoUrl: json['logo_url'],
      stockPrice: StockPrice.fromJson(json['stock_price']),
    );
  }
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

class StockPrice {
  final double currentPrice;
  final double priceChange;
  final double percentageChange;

  StockPrice({
    required this.currentPrice,
    required this.priceChange,
    required this.percentageChange,
  });

  // Named constructor to parse JSON and initialize StockPrice object
  factory StockPrice.fromJson(Map<String, dynamic> json) {
    return StockPrice(
      currentPrice: double.parse(json['current_price']['amount']),
      priceChange: json['price_change'].toDouble(),
      percentageChange: json['percentage_change'].toDouble(),
    );
  }
}
