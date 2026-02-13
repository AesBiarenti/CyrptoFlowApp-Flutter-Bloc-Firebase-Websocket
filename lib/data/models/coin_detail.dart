/// Single coin from GET /coin/:uuid
class CoinDetail {
  const CoinDetail({
    required this.uuid,
    required this.symbol,
    required this.name,
    this.description,
    this.color,
    this.iconUrl,
    this.websiteUrl,
    this.marketCap,
    this.price,
    this.change,
    this.rank,
    this.sparkline,
    this.volume24h,
    this.fullyDilutedMarketCap,
  });

  final String uuid;
  final String symbol;
  final String name;
  final String? description;
  final String? color;
  final String? iconUrl;
  final String? websiteUrl;
  final String? marketCap;
  final String? price;
  final String? change;
  final int? rank;
  final List<String>? sparkline;
  final String? volume24h;
  final String? fullyDilutedMarketCap;

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    final sparklineJson = json['sparkline'];
    return CoinDetail(
      uuid: json['uuid'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      color: json['color'] as String?,
      iconUrl: json['iconUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      marketCap: json['marketCap'] as String?,
      price: json['price'] as String?,
      change: json['change'] as String?,
      rank: json['rank'] as int?,
      sparkline: sparklineJson is List
          ? (sparklineJson).map((e) => e.toString()).toList()
          : null,
      volume24h: json['24hVolume'] as String?,
      fullyDilutedMarketCap: json['fullyDilutedMarketCap'] as String?,
    );
  }
}
