import 'package:cyrpto_flow_app/cubit/coin_detail_cubit.dart';
import 'package:cyrpto_flow_app/cubit/coins_cubit.dart';
import 'package:cyrpto_flow_app/cubit/watchlist_cubit.dart';
import 'package:cyrpto_flow_app/screens/coin_detail_screen.dart';
import 'package:cyrpto_flow_app/widgets/coin_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinListScreen extends StatelessWidget {
  const CoinListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Flow'),
      ),
      body: BlocBuilder<CoinsCubit, CoinsState>(
        builder: (context, state) {
          if (state.loading && state.coins.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state.coins.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<CoinsCubit>().refresh(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }
          final list = state.coins;
          return RefreshIndicator(
            onRefresh: () => context.read<CoinsCubit>().refresh(),
            child: ListView.builder(
              itemCount: list.length + (state.loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= list.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final coin = list[index];
                return CoinListItem(
                  coin: coin,
                  onTap: () {
                    final watchlistCubit = context.read<WatchlistCubit>();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (ctx) => BlocProvider<WatchlistCubit>.value(
                          value: watchlistCubit,
                          child: BlocProvider(
                            create: (_) => CoinDetailCubit(),
                            child: CoinDetailScreen(coinUuid: coin.uuid),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
