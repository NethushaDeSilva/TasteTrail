import 'dart:async';

import '../models/app_user.dart';

/// Lightweight stand-in for FirebaseAuthException, kept so the UI layer can
/// keep the same catch/message pattern it used with Firebase.
class AuthException implements Exception {
  final String code;
  AuthException(this.code);
}

class _Account {
  final String password;
  final AppUser user;

  _Account({required this.password, required this.user});
}

/// In-memory, non-persisted replacement for the old Firebase-backed
/// AuthService. No real backend: accounts and the signed-in user only live
/// for the current app session.
class AuthService {
  AuthService._();

  static final Map<String, _Account> _accounts = <String, _Account>{};
  static final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();
  static AppUser? _currentUser;
  static int _nextId = 1;

  static Stream<AppUser?> authChanges() async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  static AppUser? get currentUser => _currentUser;

  static Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    final String key = email.trim().toLowerCase();

    if (_accounts.containsKey(key)) {
      throw AuthException('email-already-in-use');
    }
    if (password.length < 6) {
      throw AuthException('weak-password');
    }

    final AppUser user = AppUser(
      uid: 'local-user-${_nextId++}',
      email: email.trim(),
      displayName: name.trim(),
    );
    _accounts[key] = _Account(password: password, user: user);

    // Mirrors FirebaseAuth's behaviour of signing the new user in.
    _currentUser = user;
    _controller.add(_currentUser);
  }

  static Future<void> signIn(String email, String password) async {
    final String key = email.trim().toLowerCase();
    final _Account? account = _accounts[key];

    if (account == null) {
      throw AuthException('user-not-found');
    }
    if (account.password != password) {
      throw AuthException('wrong-password');
    }

    _currentUser = account.user;
    _controller.add(_currentUser);
  }

  static Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
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
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
