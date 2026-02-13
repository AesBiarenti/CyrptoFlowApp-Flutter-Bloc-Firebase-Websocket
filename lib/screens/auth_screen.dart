import 'package:cyrpto_flow_app/core/theme/app_theme.dart';
import 'package:cyrpto_flow_app/screens/home_flow.dart';
import 'package:cyrpto_flow_app/widgets/app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const HomeFlow()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: SignInScreen(
          providers: [
            EmailAuthProvider(),
            if (googleClientId.isNotEmpty)
              GoogleProvider(clientId: googleClientId),
          ],
          styles: {
            EmailFormStyle(
              signInButtonVariant: ButtonVariant.filled,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primary,
                    width: 1.5,
                  ),
                ),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ),
          },
          headerBuilder: (context, constraints, shrinkOffset) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(height: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Uygulamaya Hoş Geldiniz',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
          subtitleBuilder: (context, action) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                action == AuthAction.signIn
                    ? 'Lütfen Oturum aç'
                    : 'Lütfen Kaydol',
                style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
