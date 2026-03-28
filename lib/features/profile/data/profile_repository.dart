import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/user_model.dart';

abstract class IProfileRepository {
  Future<AppUser?> getUser(String uid);
  Future<void> updateContact(String uid, String contact);
}

class ProfileRepository implements IProfileRepository {
  final FirebaseFirestore firestore;

  ProfileRepository(this.firestore);

  @override
  Future<AppUser?> getUser(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return AppUser.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> updateContact(String uid, String contact) async {
    await firestore.collection('users').doc(uid).update({'contact': contact});
  }
}
