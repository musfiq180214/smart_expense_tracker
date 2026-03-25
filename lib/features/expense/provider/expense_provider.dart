import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

/// ✅ NEW: selected year
final selectedYearProvider = StateProvider<int>((ref) {
  return DateTime.now().year;
});

/// ✅ NEW: extract available years
final availableYearsProvider = Provider<List<int>>((ref) {
  final expensesAsync = ref.watch(expenseStreamProvider);

  return expensesAsync.maybeWhen(
    data: (expenses) {
      final years = expenses.map((e) => e.date.year).toSet().toList();
      years.sort((a, b) => b.compareTo(a)); // latest first
      return years;
    },
    orElse: () => [],
  );
});

/// ✅ NEW: filtered expenses by selected year
final filteredExpensesProvider = Provider<List<Expense>>((ref) {
  final expensesAsync = ref.watch(expenseStreamProvider);
  final selectedYear = ref.watch(selectedYearProvider);

  return expensesAsync.maybeWhen(
    data: (expenses) {
      return expenses.where((e) => e.date.year == selectedYear).toList();
    },
    orElse: () => [],
  );
});
