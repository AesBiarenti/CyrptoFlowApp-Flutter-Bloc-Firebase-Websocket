import 'package:cyrpto_flow_app/cubit/coins_cubit.dart';
import 'package:cyrpto_flow_app/cubit/watchlist_cubit.dart';
import 'package:cyrpto_flow_app/screens/coin_list_screen.dart';
import 'package:cyrpto_flow_app/screens/profile_screen.dart';
import 'package:cyrpto_flow_app/screens/watchlist_screen.dart';
import 'package:cyrpto_flow_app/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFlow extends StatefulWidget {
  const HomeFlow({super.key});

  @override
  State<HomeFlow> createState() => _HomeFlowState();
}

class _HomeFlowState extends State<HomeFlow> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CoinsCubit()..loadCoins()),
        BlocProvider(create: (_) => WatchlistCubit()),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            CoinListScreen(),
            WatchlistScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: CustomBottomBar(
          selectedIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}
