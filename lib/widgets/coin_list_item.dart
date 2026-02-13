import 'package:cyrpto_flow_app/core/theme/app_theme.dart';
import 'package:cyrpto_flow_app/data/models/coin.dart';
import 'package:cyrpto_flow_app/widgets/coin_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinListItem extends StatelessWidget {
  const CoinListItem({
    super.key,
    required this.coin,
    this.onTap,
  });

  final Coin coin;
  final VoidCallback? onTap;

  static final _priceFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
    customPattern: '\$#,##0.00',
  );

  static final _percentFormat = NumberFormat.percentPattern('en_US');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final price = double.tryParse(coin.price ?? '0') ?? 0;
    final change = double.tryParse(coin.change ?? '0') ?? 0;
    final isPositive = change >= 0;
    final changeColor = isPositive ? AppTheme.success : AppTheme.error;

    return ListTile(
      onTap: onTap,
      leading: CoinIcon(
        iconUrl: coin.iconUrl,
        symbol: coin.symbol,
        size: 40,
        backgroundColor: colorScheme.surfaceContainerHighest,
      ),
      title: Text(
        coin.name,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        coin.symbol,
        style: textTheme.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _priceFormat.format(price),
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            _percentFormat.format(change / 100),
            style: textTheme.bodySmall?.copyWith(
              color: changeColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
