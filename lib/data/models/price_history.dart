/// Single point from GET /coin/:uuid/price-history
class PriceHistoryPoint {
  const PriceHistoryPoint({
    required this.price,
    required this.timestamp,
  });

  final String price;
  final int timestamp;

  factory PriceHistoryPoint.fromJson(Map<String, dynamic> json) {
    return PriceHistoryPoint(
      price: json['price']?.toString() ?? '0',
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }
}

/// Response from GET /coin/:uuid/price-history
class PriceHistoryResponse {
  const PriceHistoryResponse({
    this.change,
    required this.history,
  });

  final String? change;
  final List<PriceHistoryPoint> history;

  factory PriceHistoryResponse.fromJson(Map<String, dynamic> json) {
    final historyJson = json['history'];
    return PriceHistoryResponse(
      change: json['change'] as String?,
      history: historyJson is List
          ? (historyJson)
              .map((e) => PriceHistoryPoint.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }
}
