import 'package:cyrpto_flow_app/data/coin_ranking_service.dart';
import 'package:cyrpto_flow_app/data/models/coin_detail.dart';
import 'package:cyrpto_flow_app/data/models/price_history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinDetailCubit extends Cubit<CoinDetailState> {
  CoinDetailCubit({CoinRankingService? service})
      : _service = service ?? CoinRankingService(),
        super(CoinDetailState.initial());

  final CoinRankingService _service;

  Future<void> loadDetail(String uuid) async {
    if (uuid.isEmpty) return;
    emit(state.copyWith(loading: true, error: null));
    final detail = await _service.getCoinDetail(uuid);
    if (detail == null) {
      emit(state.copyWith(loading: false, error: 'Coin bulunamadı'));
      return;
    }
    emit(state.copyWith(
      loading: false,
      coin: detail,
      error: null,
    ));
  }

  Future<void> loadPriceHistory(String uuid, {String timePeriod = '7d'}) async {
    if (uuid.isEmpty) return;
    emit(state.copyWith(historyLoading: true, historyError: null));
    final history = await _service.getPriceHistory(uuid, timePeriod: timePeriod);
    if (history == null) {
      emit(state.copyWith(
        historyLoading: false,
        historyError: 'Fiyat geçmişi yüklenemedi',
      ));
      return;
    }
    emit(state.copyWith(
      historyLoading: false,
      priceHistory: history.history,
      historyTimePeriod: timePeriod,
      historyError: null,
    ));
  }

  Future<void> loadFull(String uuid, {String timePeriod = '7d'}) async {
    await loadDetail(uuid);
    if (state.coin != null) {
      await loadPriceHistory(uuid, timePeriod: timePeriod);
    }
  }

  void clear() {
    emit(CoinDetailState.initial());
  }
}

class CoinDetailState {
  const CoinDetailState({
    this.coin,
    this.loading = false,
    this.error,
    this.priceHistory = const [],
    this.historyLoading = false,
    this.historyError,
    this.historyTimePeriod,
  });

  CoinDetailState.initial() : this();

  final CoinDetail? coin;
  final bool loading;
  final String? error;
  final List<PriceHistoryPoint> priceHistory;
  final bool historyLoading;
  final String? historyError;
  final String? historyTimePeriod;

  CoinDetailState copyWith({
    CoinDetail? coin,
    bool? loading,
    String? error,
    List<PriceHistoryPoint>? priceHistory,
    bool? historyLoading,
    String? historyError,
    String? historyTimePeriod,
  }) {
    return CoinDetailState(
      coin: coin ?? this.coin,
      loading: loading ?? this.loading,
      error: error,
      priceHistory: priceHistory ?? this.priceHistory,
      historyLoading: historyLoading ?? this.historyLoading,
      historyError: historyError,
      historyTimePeriod: historyTimePeriod ?? this.historyTimePeriod,
    );
  }
}
