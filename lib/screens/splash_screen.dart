import 'package:cyrpto_flow_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Minimal splash screen. Auth check is handled in step 4.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Crypto Flow',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
