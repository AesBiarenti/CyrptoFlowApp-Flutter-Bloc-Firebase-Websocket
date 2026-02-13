import 'package:cyrpto_flow_app/screens/auth_screen.dart';
import 'package:cyrpto_flow_app/widgets/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user?.photoURL != null)
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(user!.photoURL!),
                )
              else
                CircleAvatar(
                  radius: 48,
                  child: Text(
                    (user?.displayName ?? user?.email ?? '?')
                        .substring(0, 1)
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                user?.displayName ?? user?.email ?? 'Kullanıcı',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (user?.email != null) ...[
                const SizedBox(height: 8),
                Text(
                  user!.email!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              AppButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: Icons.logout_rounded,
                label: 'Çıkış Yap',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
