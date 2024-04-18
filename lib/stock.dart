class Stock {
  final int id;
  final String symbol;
  final String name;
  final String logoUrl;
  final double currentPrice;
  final double priceChange;
  final double percentageChange;

  Stock({
    required this.id,
    required this.symbol,
    required this.name,
    required this.logoUrl,
    required this.currentPrice,
    required this.priceChange,
    required this.percentageChange,
  });
}
