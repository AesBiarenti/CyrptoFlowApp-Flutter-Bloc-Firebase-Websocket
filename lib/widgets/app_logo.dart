import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Arkaplansız (şeffaf) uygulama logosu. Splash, auth ve app bar'da kullanılır.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.height,
    this.width,
    this.colorFilter,
  });

  final double? height;
  final double? width;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/cryptoflow.svg',
      height: height,
      width: width,
      colorFilter: colorFilter,
      fit: BoxFit.contain,
    );
  }
}
