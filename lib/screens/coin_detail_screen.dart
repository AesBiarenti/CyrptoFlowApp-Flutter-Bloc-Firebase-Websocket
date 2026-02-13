import 'package:cyrpto_flow_app/core/theme/app_theme.dart';
import 'package:cyrpto_flow_app/cubit/coin_detail_cubit.dart';
import 'package:cyrpto_flow_app/cubit/watchlist_cubit.dart';
import 'package:cyrpto_flow_app/widgets/app_button.dart';
import 'package:cyrpto_flow_app/widgets/coin_icon.dart';
import 'package:cyrpto_flow_app/widgets/price_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CoinDetailScreen extends StatefulWidget {
  const CoinDetailScreen({
    super.key,
    required this.coinUuid,
  });

  final String coinUuid;

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  String _selectedPeriod = '7d';
  static const _periods = ['24h', '7d', '30d', '3m', '1y'];

  @override
  void initState() {
    super.initState();
    context.read<CoinDetailCubit>().loadFull(widget.coinUuid, timePeriod: _selectedPeriod);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<CoinDetailCubit>();
    if (cubit.state.coin == null && !cubit.state.loading) {
      cubit.loadFull(widget.coinUuid, timePeriod: _selectedPeriod);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoinDetailCubit, CoinDetailState>(
      listener: (context, state) {},
      builder: (context, state) {
        final coin = state.coin;
        if (state.loading && coin == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detay')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state.error != null && coin == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detay')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  AppButton(
                    onPressed: () => context.read<CoinDetailCubit>().loadFull(widget.coinUuid, timePeriod: _selectedPeriod),
                    label: 'Tekrar Dene',
                  ),
                ],
              ),
            ),
          );
        }

        final priceFormat = NumberFormat.currency(
          locale: 'en_US',
          symbol: '\$',
          decimalDigits: 4,
          customPattern: '\$#,##0.00',
        );
        final percentFormat = NumberFormat.percentPattern('en_US');
        final price = double.tryParse(coin?.price ?? '0') ?? 0;
        final change = double.tryParse(coin?.change ?? '0') ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: Text(coin?.name ?? 'Detay'),
            actions: [
              BlocConsumer<WatchlistCubit, WatchlistState>(
                listenWhen: (a, b) => a.ids != b.ids,
                listener: (context, state) {},
                buildWhen: (a, b) => a.ids != b.ids,
                builder: (context, wState) {
                  final inList = wState.ids.contains(widget.coinUuid);
                  return IconButton(
                    icon: Icon(inList ? Icons.star : Icons.star_border),
                    onPressed: () async {
                      final wc = context.read<WatchlistCubit>();
                      if (inList) {
                        await wc.removeCoin(widget.coinUuid);
                      } else {
                        await wc.addCoin(widget.coinUuid);
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoinIcon(
                  iconUrl: coin?.iconUrl,
                  symbol: coin?.symbol ?? '?',
                  size: 64,
                ),
                const SizedBox(height: 8),
                Text(
                  coin?.name ?? '',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  priceFormat.format(price),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  percentFormat.format(change / 100),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: change >= 0 ? AppTheme.success : AppTheme.error,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  children: _periods.map((p) {
                    final selected = p == _selectedPeriod;
                    return ChoiceChip(
                      label: Text(p),
                      selected: selected,
                      onSelected: (v) {
                        if (v) {
                          setState(() => _selectedPeriod = p);
                          context.read<CoinDetailCubit>().loadPriceHistory(widget.coinUuid, timePeriod: p);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                PriceChart(
                  history: state.priceHistory,
                  loading: state.historyLoading,
                ),
                if (coin?.description != null && coin!.description!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Hakkında',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(coin.description!),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
