import 'package:cyrpto_flow_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String _logoAsset = 'assets/cryptoflow.svg';

Future<ByteData?> _loadLogoOnce() async {
  try {
    return await rootBundle.load(_logoAsset);
  } catch (_) {
    return null;
  }
}

final Future<ByteData?> _logoFuture = _loadLogoOnce();

/// Arkaplansız uygulama logosu. Asset yoksa ikon fallback gösterir (açılış çökmesi önlenir).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height, this.width, this.colorFilter});

  final double? height;
  final double? width;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ByteData?>(
      future: _logoFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final bytes = snapshot.data!.buffer.asUint8List();
          return SvgPicture.memory(
            bytes,
            height: height,
            width: width,
            colorFilter: colorFilter,
            fit: BoxFit.contain,
          );
        }
        return _LogoFallback(height: height, width: width);
      },
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback({this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final size = height ?? width ?? 48.0;
    return Icon(
      Icons.show_chart_rounded,
      size: size,
      color: AppTheme.primaryLight,
    );
  }
}
