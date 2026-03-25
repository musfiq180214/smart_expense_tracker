import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_expense_tracker/features/expense/domain/expence_model.dart';

class ExpenseRepo {
  final _db = FirebaseFirestore.instance;

  Future<void> addExpense(Expense expense) async {
    await _db.collection('expenses').doc(expense.id).set(expense.toMap());
  }

  Stream<List<Expense>> getExpenses() {
    return _db
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => Expense.fromMap(e.data())).toList(),
        );
  }
}
