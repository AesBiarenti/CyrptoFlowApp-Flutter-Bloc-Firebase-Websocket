/// List item from GET /coins
class Coin {
  const Coin({
    required this.uuid,
    required this.symbol,
    required this.name,
    this.color,
    this.iconUrl,
    this.marketCap,
    this.price,
    this.change,
    this.rank,
    this.sparkline,
    this.volume24h,
  });

  final String uuid;
  final String symbol;
  final String name;
  final String? color;
  final String? iconUrl;
  final String? marketCap;
  final String? price;
  final String? change;
  final int? rank;
  final List<String>? sparkline;
  final String? volume24h;

  factory Coin.fromJson(Map<String, dynamic> json) {
    final sparklineJson = json['sparkline'];
    return Coin(
      uuid: json['uuid'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      color: json['color'] as String?,
      iconUrl: json['iconUrl'] as String?,
      marketCap: json['marketCap'] as String?,
      price: json['price'] as String?,
      change: json['change'] as String?,
      rank: json['rank'] as int?,
      sparkline: sparklineJson is List
          ? (sparklineJson).map((e) => e.toString()).toList()
          : null,
      volume24h: json['24hVolume'] as String?,
    );
  }

  Coin copyWith({
    String? uuid,
    String? symbol,
    String? name,
    String? color,
    String? iconUrl,
    String? marketCap,
    String? price,
    String? change,
    int? rank,
    List<String>? sparkline,
    String? volume24h,
  }) {
    return Coin(
      uuid: uuid ?? this.uuid,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      color: color ?? this.color,
      iconUrl: iconUrl ?? this.iconUrl,
      marketCap: marketCap ?? this.marketCap,
      price: price ?? this.price,
      change: change ?? this.change,
      rank: rank ?? this.rank,
      sparkline: sparkline ?? this.sparkline,
      volume24h: volume24h ?? this.volume24h,
    );
  }
}
