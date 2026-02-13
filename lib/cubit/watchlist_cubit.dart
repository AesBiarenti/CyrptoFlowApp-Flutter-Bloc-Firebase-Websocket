import 'dart:async';

import 'package:cyrpto_flow_app/data/coin_ranking_service.dart';
import 'package:cyrpto_flow_app/data/models/coin.dart';
import 'package:cyrpto_flow_app/data/watchlist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit({
    WatchlistRepository? repository,
    CoinRankingService? service,
  })  : _repository = repository ?? WatchlistRepository(),
        _service = service ?? CoinRankingService(),
        super(WatchlistState.initial()) {
    _subscription = _repository.watchlistIdsStream().listen(_onIdsUpdated);
  }

  final WatchlistRepository _repository;
  final CoinRankingService _service;
  StreamSubscription<List<String>>? _subscription;

  void _onIdsUpdated(List<String> ids) {
    emit(state.copyWith(ids: ids));
    if (ids.isNotEmpty) {
      loadCoinsForIds(ids);
    } else {
      emit(state.copyWith(coins: []));
    }
  }

  Stream<List<String>> watchlistIdsStream() => _repository.watchlistIdsStream();

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> addCoin(String coinUuid) async {
    try {
      await _repository.addCoin(coinUuid);
    } catch (_) {
      // ignore; stream will update or user not signed in
    }
  }

  Future<void> removeCoin(String coinUuid) async {
    try {
      await _repository.removeCoin(coinUuid);
    } catch (_) {
      // ignore
    }
  }

  Future<bool> isInWatchlist(String coinUuid) async {
    try {
      return await _repository.isInWatchlist(coinUuid);
    } catch (_) {
      return false;
    }
  }

  Future<void> loadCoinsForIds(List<String> ids) async {
    if (ids.isEmpty) {
      emit(state.copyWith(coins: [], loading: false));
      return;
    }
    emit(state.copyWith(loading: true));
    final coins = await _service.getCoinsByUuids(ids);
    if (!isClosed) {
      emit(state.copyWith(coins: coins, loading: false));
    }
  }
}

class WatchlistState {
  const WatchlistState({
    this.ids = const [],
    this.coins = const [],
    this.loading = false,
    this.error,
  });

  WatchlistState.initial() : this();

  final List<String> ids;
  final List<Coin> coins;
  final bool loading;
  final String? error;

  WatchlistState copyWith({
    List<String>? ids,
    List<Coin>? coins,
    bool? loading,
    String? error,
  }) {
    return WatchlistState(
      ids: ids ?? this.ids,
      coins: coins ?? this.coins,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
