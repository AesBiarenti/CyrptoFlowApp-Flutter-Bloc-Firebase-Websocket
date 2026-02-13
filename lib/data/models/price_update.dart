/// Single price update from WebSocket (e.g. Binance miniTicker).
class PriceUpdate {
  const PriceUpdate({
    required this.symbol,
    required this.price,
    this.changePercent,
  });

  final String symbol;
  final String price;
  final String? changePercent;

  @override
  String toString() => 'PriceUpdate($symbol, $price)';
}
