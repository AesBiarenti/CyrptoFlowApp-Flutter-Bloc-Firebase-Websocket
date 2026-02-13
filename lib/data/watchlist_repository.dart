import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistRepository {
  WatchlistRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  DocumentReference<Map<String, dynamic>> _userDoc() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('User not signed in');
    return _users.doc(uid);
  }

  /// Stream of watchlist coin UUIDs for the current user.
  Stream<List<String>> watchlistIdsStream() {
    return _userDoc().snapshots().map((snap) {
      if (!snap.exists) return <String>[];
      final data = snap.data();
      final list = data?['watchlistIds'];
      if (list is List) {
        return list.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
      }
      return <String>[];
    });
  }

  Future<void> addCoin(String coinUuid) async {
    if (coinUuid.isEmpty) return;
    final ref = _userDoc();
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final List<String> ids = [];
      if (snap.exists && snap.data() != null) {
        final list = snap.data()!['watchlistIds'];
        if (list is List) {
          for (final e in list) {
            final s = e.toString();
            if (s.isNotEmpty && !ids.contains(s)) ids.add(s);
          }
        }
      }
      if (ids.contains(coinUuid)) return;
      ids.add(coinUuid);
      tx.set(ref, {'watchlistIds': ids}, SetOptions(merge: true));
    });
  }

  Future<void> removeCoin(String coinUuid) async {
    if (coinUuid.isEmpty) return;
    final ref = _userDoc();
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final List<String> ids = [];
      if (snap.exists && snap.data() != null) {
        final list = snap.data()!['watchlistIds'];
        if (list is List) {
          for (final e in list) {
            final s = e.toString();
            if (s.isNotEmpty && s != coinUuid) ids.add(s);
          }
        }
      }
      tx.set(ref, {'watchlistIds': ids}, SetOptions(merge: true));
    });
  }

  Future<bool> isInWatchlist(String coinUuid) async {
    if (coinUuid.isEmpty) return false;
    final snap = await _userDoc().get();
    if (!snap.exists || snap.data() == null) return false;
    final list = snap.data()!['watchlistIds'];
    if (list is! List) return false;
    return list.any((e) => e.toString() == coinUuid);
  }
}
