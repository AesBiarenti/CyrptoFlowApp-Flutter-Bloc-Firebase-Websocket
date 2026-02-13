import 'package:cyrpto_flow_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                clientId:
                    '138150514355-01nakoci9881t5hv0l89vq42qmckgqt1.apps.googleusercontent.com',
                //! firebase sayfasında auth sekmesinde sign in method sekmesinde google kısmını düzenleme kısmına gelince orada gözüküyor
              ),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Text("Uygulamaya Hoş Geldiniz"),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
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
