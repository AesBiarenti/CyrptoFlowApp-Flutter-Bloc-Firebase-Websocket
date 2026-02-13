import 'package:cyrpto_flow_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              if (googleClientId.isNotEmpty)
                GoogleProvider(
                  clientId: googleClientId,
                ),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Text("Uygulamaya Hoş Geldiniz"),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: action == AuthAction.signIn
                    ? const Text("Lütfen Oturum aç")
                    : const Text("Lütfen Kaydol"),
              );
            },
          );
        }
        return const HomeScreen();
      },
    );
  }
}
