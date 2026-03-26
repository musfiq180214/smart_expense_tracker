import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authRepoProvider = Provider<AuthRepo>((ref) => AuthRepo());

final authStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepoProvider);
  return repo.authStateChanges();
});
