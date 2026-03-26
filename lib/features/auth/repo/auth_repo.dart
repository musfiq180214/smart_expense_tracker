import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final _auth = FirebaseAuth.instance;

  // Sign Up
  Future<User?> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? "Registration failed");
    } catch (e) {
      throw AuthException(message: "Unknown error during registration");
    }
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? "Login failed");
    } catch (e) {
      throw AuthException(message: "Unknown error during login");
    }
  }

  // Sign Out
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Stream of Auth State
  Stream<User?> authStateChanges() => _auth.authStateChanges();
}

class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
}
