import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository.dart';
import '../domain/user_model.dart';

final profileRepoProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepository(FirebaseFirestore.instance);
});
final userProfileProvider = FutureProvider<AppUser?>((ref) async {
  final repo = ref.watch(profileRepoProvider);
  final auth = FirebaseAuth.instance;

  final user = auth.currentUser;

  if (user == null) return null;

  return repo.getUser(user.uid);
});

final updateContactProvider = Provider((ref) {
  return (String uid, String contact) async {
    final repo = ref.read(profileRepoProvider);
    await repo.updateContact(uid, contact);

    // 🔥 Refresh profile after update
    ref.invalidate(userProfileProvider);
  };
});
