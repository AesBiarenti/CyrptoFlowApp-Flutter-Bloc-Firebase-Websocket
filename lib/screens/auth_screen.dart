import 'package:cyrpto_flow_app/core/theme/app_theme.dart';
import 'package:cyrpto_flow_app/screens/home_flow.dart';
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SignInScreen(
        providers: [
          EmailAuthProvider(),
          if (googleClientId.isNotEmpty)
            GoogleProvider(clientId: googleClientId),
        ],
        headerBuilder: (context, constraints, shrinkOffset) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Uygulamaya Hoş Geldiniz',
              style: Theme.of(context).textTheme.headlineMedium,
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          );
        },
      ),
    );
  }
}
