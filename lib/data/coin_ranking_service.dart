import 'package:cyrpto_flow_app/data/models/coin.dart';
import 'package:cyrpto_flow_app/data/models/coin_detail.dart';
import 'package:cyrpto_flow_app/data/models/price_history.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinRankingService {
  CoinRankingService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = dotenv.env['COIN_RANK_API_KEY'] ?? '';
        if (token.isNotEmpty) {
          options.headers['x-access-token'] = token;
        }
        return handler.next(options);
      },
    ));
  }

  static const String _baseUrl = 'https://api.coinranking.com/v2';
  late final Dio _dio;

  /// GET /coins — limit (max 100 on free), optional offset, timePeriod
  Future<CoinsListResult> getCoins({
    int limit = 50,
    int offset = 0,
    String timePeriod = '24h',
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/coins',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'timePeriod': timePeriod,
        },
      );
      final data = response.data;
      if (data == null || data['status'] != 'success') {
        return CoinsListResult(error: 'Invalid response');
      }
      final dataObj = data['data'];
      if (dataObj == null || dataObj is! Map<String, dynamic>) {
        return CoinsListResult(error: 'Invalid data');
      }
      final coinsJson = dataObj['coins'];
      final list = coinsJson is List
          ? (coinsJson)
              .map((e) => Coin.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : <Coin>[];
      final pagination = dataObj['pagination'] is Map<String, dynamic>
          ? dataObj['pagination'] as Map<String, dynamic>
          : null;
      final hasNext = pagination?['hasNextPage'] == true;
      final nextCursor = pagination?['nextCursor'] as String?;
      return CoinsListResult(
        coins: list,
        hasNextPage: hasNext,
        nextCursor: nextCursor,
      );
    } on DioException catch (e) {
      return CoinsListResult(
        error: e.response?.data?['message']?.toString() ?? e.message ?? 'Network error',
      );
    } catch (e) {
      return CoinsListResult(error: e.toString());
    }
  }

  /// GET /coin/:uuid
  Future<CoinDetail?> getCoinDetail(String uuid) async {
    if (uuid.isEmpty) return null;
    try {
      final response = await _dio.get<Map<String, dynamic>>('/coin/$uuid');
      final data = response.data;
      if (data == null || data['status'] != 'success') return null;
      final dataObj = data['data'];
      if (dataObj == null || dataObj is! Map<String, dynamic>) return null;
      final coinJson = dataObj['coin'];
      if (coinJson == null || coinJson is! Map<String, dynamic>) return null;
      return CoinDetail.fromJson(coinJson);
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /coin/:uuid/price-history
  Future<PriceHistoryResponse?> getPriceHistory(
    String uuid, {
    String timePeriod = '7d',
  }) async {
    if (uuid.isEmpty) return null;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/coin/$uuid/price-history',
        queryParameters: {'timePeriod': timePeriod},
      );
      final data = response.data;
      if (data == null || data['status'] != 'success') return null;
      final dataObj = data['data'];
      if (dataObj == null || dataObj is! Map<String, dynamic>) return null;
      return PriceHistoryResponse.fromJson(dataObj);
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// GET /coins with uuids filter — for watchlist details
  Future<List<Coin>> getCoinsByUuids(List<String> uuids) async {
    if (uuids.isEmpty) return [];
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/coins',
        queryParameters: {
          'limit': uuids.length.clamp(1, 100),
          'uuids[]': uuids,
        },
        options: Options(
          listFormat: ListFormat.multiCompatible,
        ),
      );
      final data = response.data;
      if (data == null || data['status'] != 'success') return [];
      final dataObj = data['data'];
      if (dataObj == null || dataObj is! Map<String, dynamic>) return [];
      final coinsJson = dataObj['coins'];
      if (coinsJson is! List) return [];
      return (coinsJson)
          .map((e) => Coin.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (_) {
      return [];
    } catch (_) {
      return [];
    }
  }
}

class CoinsListResult {
  const CoinsListResult({
    this.coins = const [],
    this.hasNextPage = false,
    this.nextCursor,
    this.error,
  });

  final List<Coin> coins;
  final bool hasNextPage;
  final String? nextCursor;
  final String? error;
}
