import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_expense_tracker/features/expense/domain/expence_model.dart';

class ExpenseRepo {
  final _db = FirebaseFirestore.instance;

  Future<void> addExpense(Expense expense) async {
    await _db.collection('expenses').doc(expense.id).set(expense.toMap());
  }

  Stream<List<Expense>> getExpenses() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    try {
      return _db
          .collection('expenses')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs.map((e) => Expense.fromMap(e.data())).toList(),
          );
    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition') {
        print('Firestore index missing for query: ${e.message}');
        // Return empty stream so UI doesn’t crash
        return const Stream.empty();
      }
      rethrow; // propagate other errors
    }
  }
}
