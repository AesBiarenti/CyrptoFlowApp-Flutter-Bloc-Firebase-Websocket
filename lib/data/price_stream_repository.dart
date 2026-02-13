import 'dart:async';
import 'dart:convert';

import 'package:cyrpto_flow_app/data/models/price_update.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Binance public WebSocket for real-time prices (miniTicker).
/// Combined stream: wss://stream.binance.com:9443/stream?streams=btcusdt@miniTicker/...
class BinancePriceStreamRepository {
  BinancePriceStreamRepository();

  static const String _baseUrl = 'wss://stream.binance.com:9443/stream';
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  final StreamController<PriceUpdate> _controller =
      StreamController<PriceUpdate>.broadcast();

  /// Stream of price updates. Subscribe after [connect].
  Stream<PriceUpdate> get stream => _controller.stream;

  /// Build stream name for Binance: BTC -> btcusdt@miniTicker
  static String streamNameForSymbol(String symbol) {
    final s = symbol.toUpperCase().replaceAll(' ', '');
    if (s.isEmpty) return '';
    final pair = '${s.toLowerCase()}usdt';
    return '$pair@miniTicker';
  }

  /// Connect and subscribe to the given symbols (e.g. ['BTC', 'ETH']).
  /// Reconnects if already connected with a different set.
  void connect(List<String> symbols) {
    if (symbols.isEmpty) return;
    disconnect();
    final streamNames = symbols
        .map((s) => streamNameForSymbol(s))
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
    if (streamNames.isEmpty) return;
    final uri = Uri.parse(
      '$_baseUrl?streams=${streamNames.join('/')}',
    );
    _channel = WebSocketChannel.connect(uri);
    _subscription = _channel!.stream.listen(
      _onMessage,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: false,
    );
  }

  void _onMessage(dynamic message) {
    if (message is! String) return;
    try {
      final map = jsonDecode(message) as Map<String, dynamic>;
      final streamName = map['stream'] as String?;
      final data = map['data'];
      if (streamName == null || data is! Map) return;
      // streamName = "btcusdt@miniTicker" -> symbol = "BTC"
      final pair = streamName.split('@').first;
      final symbol = pair.replaceFirst(RegExp(r'usdt$'), '').toUpperCase();
      if (symbol.isEmpty) return;
      final price = (data['c'] ?? data['lastPrice'])?.toString();
      if (price == null || price.isEmpty) return;
      final change = data['P']?.toString(); // 24h change percent
      _controller.add(PriceUpdate(
        symbol: symbol,
        price: price,
        changePercent: change,
      ));
    } catch (_) {
      // ignore parse errors
    }
  }

  void _onError(Object error) {
    // Could trigger reconnect here
  }

  void _onDone() {
    _subscription = null;
    _channel = null;
  }

  void disconnect() {
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
