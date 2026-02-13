import 'package:cyrpto_flow_app/cubit/coin_detail_cubit.dart';
import 'package:cyrpto_flow_app/cubit/watchlist_cubit.dart';
import 'package:cyrpto_flow_app/screens/coin_detail_screen.dart';
import 'package:cyrpto_flow_app/widgets/coin_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Takip Listesi')),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (context, state) {
          if (state.loading && state.coins.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.coins.isEmpty && state.ids.isEmpty) {
            return const Center(
              child: Text(
                'Takip listesi boş.\nCoin detay sayfasından yıldız ile ekleyebilirsiniz.',
                textAlign: TextAlign.center,
              ),
            );
          }
          final list = state.coins;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
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
          );
        },
      ),
    );
  }
}
