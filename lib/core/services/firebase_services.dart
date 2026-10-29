import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:out_split_in/core/services/network_service.dart';
import 'package:out_split_in/core/services/offline_storage_service.dart';
import 'package:out_split_in/feature/home/model/transation_model.dart';

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final OfflineStorageService offlineStorage;
  final NetworkService networkService;

  FirebaseServices({
    OfflineStorageService? offlineStorageService,
    NetworkService? networkService,
  })  : offlineStorage = offlineStorageService ?? OfflineStorageService(),
        networkService = networkService ?? NetworkService();

  String _getCurrentUserId() {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User is not authenticated');
    }
    return userId;
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await auth.signOut();
  }

  /// Authenticate using Google Account Sign-In.
  /// Obtains OAuth tokens from Google and signs in with Firebase Auth.
  /// Automatically provisions the user document in Firestore if new.
  Future<UserCredential?> signInWithGoogle() async {
    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) {
      throw 'No internet connection. Please check your network and try again.';
    }

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId:
            '228699203727-pt4s23j24jcggjl7qdqi4l886vjc06jg.apps.googleusercontent.com',
      );

      // Sign out first to ensure the account picker is always presented
      try {
        await googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('Google Sign-In canceled by user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        try {
          final userDoc = await firestore.collection('users').doc(user.uid).get();
          if (!userDoc.exists) {
            final name = user.displayName ?? googleUser.displayName ?? 'User';
            final email = user.email ?? googleUser.email;
            await firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'name': name.trim(),
              'email': email.trim(),
              'photoUrl': user.photoURL,
              'created_at': FieldValue.serverTimestamp(),
            });
          }
        } catch (e) {
          debugPrint('Warning: Could not sync Google user profile to Firestore: $e');
        }
      }

      return userCredential;
    } on PlatformException catch (e) {
      debugPrint('PlatformException during Google Sign-In: ${e.code} - ${e.message}');
      if (e.message != null && e.message!.contains('10')) {
        throw 'Google Sign-In configuration error (ApiException 10). The SHA-1 certificate fingerprint is missing or misconfigured in Firebase Console.';
      }
      throw 'Google Sign-In failed: ${e.message ?? e.code}';
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during Google Sign-In: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  Future<void> createUser(
    String email,
    String password,
    String username,
  ) async {
    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) {
      throw 'No internet connection. Please check your network and try again.';
    }

    try {
      final userCred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user != null) {
        if (username.trim().isNotEmpty) {
          try {
            await user.updateDisplayName(username.trim());
          } catch (e) {
            debugPrint('Error updating display name: $e');
          }
        }
        try {
          await firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': username.trim(),
            'email': email.trim(),
            'created_at': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint('Warning: Could not save user profile to Firestore: $e');
          // Important: Firebase Auth user is ALREADY created!
          // We do not rethrow firestore permission errors here,
          // because doing so causes the UI to report sign-up failure,
          // and the user\'s immediate retry will fail with "email-already-in-use"!
        }
        try {
          await user.reload();
        } catch (_) {}
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  Future<String?> getUsername(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['name'] as String?;
      } else {
        debugPrint('User document does not exist for uid: $uid');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching username: $e');
      return null;
    }
  }

  Future<void> updateUsername(String newName) async {
    try {
      final user = auth.currentUser;
      if (user == null) return;
      await user.updateDisplayName(newName.trim());
      await firestore.collection('users').doc(user.uid).set({
        'name': newName.trim(),
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await user.reload();
    } catch (e) {
      debugPrint('Error updating username: $e');
      rethrow;
    }
  }

  Future<void> loginUser(String email, String password) async {
    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) {
      throw 'No internet connection. Please check your network and try again.';
    }

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error logging in user: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) {
      throw 'No internet connection. Please check your network and try again.';
    }

    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
      rethrow;
    }
  }

  /// Add a transaction.
  /// 1. Immediately saves locally to cache.
  /// 2. If online, syncs directly to Firestore.
  /// 3. If offline or if connection drops suddenly, queues into pending sync list.
  /// Returns `true` if synced to cloud immediately, or `false` if stored offline.
  Future<bool> addTransaction({required TransactionModel transaction}) async {
    // 1. Save to local offline cache immediately
    await offlineStorage.saveSingleTransactionLocally(transaction);

    // 2. Check internet connectivity
    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) {
      debugPrint(
        'Offline: Transaction queued for cloud sync when connected: ${transaction.id}',
      );
      await offlineStorage.savePendingSyncTransaction(transaction);
      return false;
    }

    try {
      final userId = _getCurrentUserId();
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id);

      await docRef
          .set(transaction.toMap())
          .timeout(const Duration(seconds: 5));
      debugPrint(
        'Transaction synced to cloud successfully: ${transaction.id}',
      );
      await offlineStorage.removePendingSyncTransaction(transaction.id);
      return true;
    } catch (e) {
      debugPrint(
        'Connection dropped/failed while syncing ($e). Queuing locally for auto-sync: ${transaction.id}',
      );
      await offlineStorage.savePendingSyncTransaction(transaction);
      return false;
    }
  }

  /// Syncs all queued offline transactions to Firestore when internet is available.
  /// Returns the number of transactions successfully synced.
  Future<int> syncPendingTransactions() async {
    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) return 0;

    final pending = await offlineStorage.getPendingSyncTransactions();
    if (pending.isEmpty) return 0;

    String userId;
    try {
      userId = _getCurrentUserId();
    } catch (e) {
      debugPrint('User not authenticated, skipping pending sync: $e');
      return 0;
    }

    int syncedCount = 0;
    for (final transaction in pending) {
      try {
        final docRef = firestore
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .doc(transaction.id);

        await docRef
            .set(transaction.toMap())
            .timeout(const Duration(seconds: 5));
        await offlineStorage.removePendingSyncTransaction(transaction.id);
        syncedCount++;
      } catch (e) {
        debugPrint(
          'Failed syncing pending transaction ${transaction.id}: $e',
        );
      }
    }

    debugPrint(
      'Cloud sync complete: $syncedCount of ${pending.length} transactions synced.',
    );
    return syncedCount;
  }

  Future<bool> saveIfNotExists({required TransactionModel transaction}) async {
    // 1. Save to local offline cache immediately
    await offlineStorage.saveSingleTransactionLocally(transaction);

    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) {
      await offlineStorage.savePendingSyncTransaction(transaction);
      return true;
    }

    try {
      final userId = _getCurrentUserId();
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id);

      return await firestore.runTransaction<bool>((tx) async {
        final doc = await tx.get(docRef);
        if (doc.exists) {
          return false;
        }
        tx.set(docRef, transaction.toMap());
        return true;
      }).timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Firestore transaction sync error (saved locally): $e');
      await offlineStorage.savePendingSyncTransaction(transaction);
      return true;
    }
  }

  Future<List<TransactionModel>> getTransactions() async {
    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) {
      debugPrint('Offline mode: fetching cached transactions from storage.');
      return offlineStorage.getCachedTransactions();
    }

    try {
      final userId = _getCurrentUserId();
      debugPrint('Fetching cloud transactions for user: $userId');

      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get()
          .timeout(const Duration(seconds: 6));

      final remoteList = snapshot.docs
          .map((doc) => TransactionModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      // Ensure any pending offline transactions are also included
      final pending = await offlineStorage.getPendingSyncTransactions();
      for (final p in pending) {
        if (!remoteList.any((t) => t.id == p.id)) {
          remoteList.insert(0, p);
        }
      }

      // Update local offline cache with latest remote data
      await offlineStorage.cacheTransactions(remoteList);
      debugPrint('Fetched & cached ${remoteList.length} transactions.');
      return remoteList;
    } catch (e) {
      debugPrint(
        'Network fetch failed ($e). Falling back to offline local storage.',
      );
      final cached = await offlineStorage.getCachedTransactions();
      return cached;
    }
  }

  Future<void> updateTransaction({
    required TransactionModel transaction,
  }) async {
    await offlineStorage.saveSingleTransactionLocally(transaction);
    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) {
      await offlineStorage.savePendingSyncTransaction(transaction);
      return;
    }

    try {
      final userId = _getCurrentUserId();
      await firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap())
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Error updating transaction in cloud: $e');
      await offlineStorage.savePendingSyncTransaction(transaction);
    }
  }

  Future<void> deleteTransaction({required String transactionId}) async {
    await offlineStorage.deleteTransactionLocally(transactionId);
    await offlineStorage.removePendingSyncTransaction(transactionId);

    final isOnline = await networkService.checkIsConnected();
    if (!isOnline) return;

    try {
      final userId = _getCurrentUserId();
      await firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .delete()
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Error deleting transaction in cloud: $e');
    }
  }
}
