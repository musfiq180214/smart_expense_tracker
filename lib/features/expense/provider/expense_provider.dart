import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_tracker/features/expense/domain/expence_model.dart';
import 'package:smart_expense_tracker/features/expense/repo/expence_repo.dart';
import 'package:uuid/uuid.dart';

final expenseRepoProvider = Provider((ref) => ExpenseRepo());

final expenseStreamProvider = StreamProvider<List<Expense>>((ref) {
  return ref.watch(expenseRepoProvider).getExpenses();
});

final addExpenseProvider = Provider((ref) {
  return (String title, double amount, DateTime date) async {
    final repo = ref.read(expenseRepoProvider);

    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
    );

    await repo.addExpense(expense);
  };
});
