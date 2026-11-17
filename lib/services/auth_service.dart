import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../models/app_user.dart';

/// Wraps FirebaseAuthException so the UI layer's catch/message pattern
/// doesn't need to depend on the Firebase package directly.
class AuthException implements Exception {
  final String code;
  AuthException(this.code);
}

class AuthService {
  AuthService._();

  static final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  static AppUser? _toAppUser(fb.User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
    );
  }

  static Stream<AppUser?> authChanges() {
    return _auth.authStateChanges().map(_toAppUser);
  }

  static AppUser? get currentUser => _toAppUser(_auth.currentUser);

  static Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final fb.UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
      await credential.user?.updateDisplayName(name.trim());
    } on fb.FirebaseAuthException catch (error) {
      throw AuthException(error.code);
    }
  }

  static Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on fb.FirebaseAuthException catch (error) {
      throw AuthException(error.code);
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static String messageFor(AuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Check your network and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Wait a moment and try again.';
      case 'operation-not-allowed':
      case 'configuration-not-found':
        return 'Email/password sign-in is not enabled for this project yet.';
      default:
        return 'Something went wrong (${error.code}). Please try again.';
    }
  }
}
