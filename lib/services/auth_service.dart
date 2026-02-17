import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';
import '../utils/zodiac.dart';
import '../config/google_oauth_client_ids.dart';

class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _authOverride = firebaseAuth,
       _firestoreOverride = firestore,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth? _authOverride;
  final FirebaseFirestore? _firestoreOverride;
  final GoogleSignIn _googleSignIn;
  Future<void>? _googleInit;

  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;

  Stream<AppUser?> get userChanges {
    return _auth.authStateChanges().asyncMap(_mapFirebaseUser);
  }

  Future<AppUser?> get currentUser async {
    final current = _auth.currentUser;
    if (current == null) {
      return null;
    }
    return _mapFirebaseUser(current);
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw const AuthException('sign-in-failed', 'Kullanici bulunamadi.');
    }
    final appUser = await _ensureUserDocument(user: user);
    return appUser;
  }

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required DateTime birthDate,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(displayName);

    final appUser = await _ensureUserDocument(
      user: credential.user!,
      displayName: displayName,
      birthDate: birthDate,
    );

    return appUser;
  }

  Future<AppUser> signInWithGoogle() async {
    await _ensureGoogleInitialized();

    GoogleSignInAccount googleAccount;
    try {
      googleAccount = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException(
          'google-cancelled',
          'Google girisi iptal edildi.',
        );
      }
      throw AuthException(
        error.code.name,
        error.description ?? 'Google girisi basarisiz.',
      );
    } on PlatformException catch (error) {
      final resolvedMessage = _mapPlatformErrorMessage(error);
      throw AuthException(error.code, resolvedMessage);
    }

    final googleAuth = googleAccount.authentication;
    if (googleAuth.idToken == null) {
      throw const AuthException(
        'google-missing-token',
        'Google kimlik belirteci alinmadi.',
      );
    }
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw const AuthException('google-failed', 'Google girisi basarisiz.');
    }

    final appUser = await _ensureUserDocument(user: user);
    return appUser;
  }

  Future<void> sendPasswordReset({required String email}) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _ensureGoogleInitialized();
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ], eagerError: true);
  }

  Future<void> _ensureGoogleInitialized() {
    _assertClientConfiguration();
    return _googleInit ??= _googleSignIn.initialize(
      clientId: GoogleOAuthClientIds.iosClientId,
      serverClientId: GoogleOAuthClientIds.androidServerClientId,
    );
  }

  void _assertClientConfiguration() {
    if (kIsWeb) {
      return;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        if (GoogleOAuthClientIds.androidServerClientId == null) {
          throw const AuthException(
            'google-server-client-id-missing',
            'Google girisi icin gerekli sunucu client ID degeri tanimlanmadi.',
          );
        }
        break;
      case TargetPlatform.iOS:
        if (GoogleOAuthClientIds.iosClientId == null) {
          throw const AuthException(
            'google-ios-client-id-missing',
            'Google girisi icin gerekli iOS client ID degeri tanimlanmadi.',
          );
        }
        break;
      default:
        break;
    }
  }

  String _mapPlatformErrorMessage(PlatformException error) {
    final description = error.message ?? '';
    if (description.contains('serverClientId must be provided')) {
      return 'Google girisi icin sunucu client ID eksik. Firebase konsolundan Web istemci kimligini ekleyin ve uygulamaya tanimlayin.';
    }
    if (description.isNotEmpty) {
      return description;
    }
    return 'Google girisi tamamlanamadi. (${error.code})';
  }

  Future<AppUser> _ensureUserDocument({
    required User user,
    String? displayName,
    DateTime? birthDate,
  }) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      final now = DateTime.now();
      final userBirthDate = birthDate;
      await docRef.set({
        'email': user.email ?? '',
        'name': displayName ?? user.displayName ?? '',
        'birthDate': userBirthDate != null
            ? Timestamp.fromDate(userBirthDate)
            : null,
        'zodiacSign': userBirthDate != null
            ? calculateZodiac(userBirthDate)
            : '',
        'isPremium': false,
        'premiumExpireDate': null,
        'role': UserRole.user.name,
        'onboardingCompleted': false,
        'createdAt': Timestamp.fromDate(now),
      });
      final createdSnapshot = await docRef.get();
      return AppUser.fromDocument(createdSnapshot);
    }

    return AppUser.fromDocument(snapshot);
  }

  Future<void> saveOnboardingData({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    final docRef = _firestore.collection('users').doc(uid);
    await docRef.set(data, SetOptions(merge: true));
  }

  Future<AppUser?> _mapFirebaseUser(User? user) async {
    if (user == null) {
      return null;
    }
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      return _ensureUserDocument(user: user);
    }
    return AppUser.fromDocument(doc);
  }
}

class AuthException implements Exception {
  const AuthException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'AuthException($code, $message)';
}
