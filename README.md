# cyrpto_flow_app

A new Flutter project.

## Kurulum (ilk çalıştırmadan önce)

### 1. Firebase

Config dosyaları repoda yok. Lokal üretmek için:

```bash
dart run flutterfire configure
```

Bu komut `lib/firebase_options.dart` ve `android/app/google-services.json` oluşturur.

### 2. Google Client ID (.env)

`.env.example` dosyasını `.env` olarak kopyalayıp Google Web Client ID’nizi yazın:

```bash
cp .env.example .env
```

`.env` içinde `GOOGLE_CLIENT_ID` değerini doldurun (Firebase Console → Authentication → Sign-in method → Google → Web SDK configuration).

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
