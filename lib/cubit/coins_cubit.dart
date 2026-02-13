import 'dart:async';

import 'package:cyrpto_flow_app/data/coin_ranking_service.dart';
import 'package:cyrpto_flow_app/data/models/coin.dart';
import 'package:cyrpto_flow_app/data/models/price_update.dart';
import 'package:cyrpto_flow_app/data/price_stream_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinsCubit extends Cubit<CoinsState> {
  CoinsCubit({
    CoinRankingService? service,
    BinancePriceStreamRepository? priceStreamRepository,
  })  : _service = service ?? CoinRankingService(),
        _priceStream = priceStreamRepository ?? BinancePriceStreamRepository(),
        super(CoinsState.initial());

  final CoinRankingService _service;
  final BinancePriceStreamRepository _priceStream;
  StreamSubscription<PriceUpdate>? _priceSubscription;

  static const int _pageSize = 50;

  Future<void> loadCoins() async {
    emit(state.copyWith(loading: true, error: null));
    final result = await _service.getCoins(limit: _pageSize, offset: 0);
    if (result.error != null) {
      emit(state.copyWith(loading: false, error: result.error));
      return;
    }
    emit(state.copyWith(
      loading: false,
      coins: result.coins,
      hasNextPage: result.hasNextPage,
      nextCursor: result.nextCursor,
      error: null,
    ));
    _subscribeToPriceStream(result.coins);
  }

  void _subscribeToPriceStream(List<Coin> coins) {
    _priceSubscription?.cancel();
    _priceStream.disconnect();
    if (coins.isEmpty) return;
    final symbols = coins.map((c) => c.symbol).where((s) => s.isNotEmpty).toList();
    if (symbols.isEmpty) return;
    _priceStream.connect(symbols);
    _priceSubscription = _priceStream.stream.listen(_onPriceUpdate);
  }

  void _onPriceUpdate(PriceUpdate update) {
    if (isClosed) return;
    final coins = state.coins;
    if (coins.isEmpty) return;
    final symbol = update.symbol.toUpperCase();
    final index = coins.indexWhere(
      (c) => c.symbol.toUpperCase() == symbol,
    );
    if (index < 0) return;
    final updated = coins[index].copyWith(
      price: update.price,
      change: update.changePercent,
    );
    final newList = List<Coin>.from(coins)..[index] = updated;
    emit(state.copyWith(coins: newList));
  }

  Future<void> refresh() async {
    await loadCoins();
  }

  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    _priceStream.disconnect();
    _priceStream.dispose();
    return super.close();
  }
}

class CoinsState {
  const CoinsState({
    this.coins = const [],
    this.loading = false,
    this.error,
    this.hasNextPage = false,
    this.nextCursor,
  });

  CoinsState.initial() : this();

  final List<Coin> coins;
  final bool loading;
  final String? error;
  final bool hasNextPage;
  final String? nextCursor;

  CoinsState copyWith({
    List<Coin>? coins,
    bool? loading,
    String? error,
    bool? hasNextPage,
    String? nextCursor,
  }) {
    return CoinsState(
      coins: coins ?? this.coins,
      loading: loading ?? this.loading,
      error: error,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }
}
