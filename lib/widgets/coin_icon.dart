import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shows coin icon from [iconUrl]. Supports SVG (via flutter_svg) and raster images.
/// Falls back to [symbol] initial letter when URL is empty or load fails.
class CoinIcon extends StatelessWidget {
  const CoinIcon({
    super.key,
    this.iconUrl,
    required this.symbol,
    this.size = 40,
    this.backgroundColor,
  });

  final String? iconUrl;
  final String symbol;
  final double size;
  final Color? backgroundColor;

  static bool _isSvg(String url) {
    final u = url.toLowerCase();
    return u.endsWith('.svg') || u.contains('.svg?');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fallback = _buildFallback(context, bg);

    if (iconUrl == null || iconUrl!.isEmpty) {
      return fallback;
    }

    final url = iconUrl!;
    if (_isSvg(url)) {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            fallback,
            ClipOval(
              child: SvgPicture.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.contain,
                placeholderBuilder: (context) => fallback,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          fallback,
          ClipOval(
            child: Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, _) => fallback,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallback(BuildContext context, Color bg) {
    final theme = Theme.of(context);
    final letter = (symbol.isNotEmpty ? symbol.substring(0, 1) : '?').toUpperCase();
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: bg,
      child: Text(
        letter,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
