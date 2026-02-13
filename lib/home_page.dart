import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text("Ana Ekran")),
      body: Center(
        child: Column(
          children: [
            Text("Hoş Geldiniz ${user?.displayName ?? user?.email} !"),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text("Çıkış Yap"),
            ),
            //* firestore ile etkileşime geçmek için buraya widgetler ekleyebiliriz.
          ],
        ),
      ),
    );
  }
}
